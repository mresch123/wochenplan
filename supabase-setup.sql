-- Wochenplan: gemeinsamer Haushalt + sichere Synchronisierung
create extension if not exists pgcrypto;

create table if not exists public.households (
  id uuid primary key default gen_random_uuid(),
  name text not null default 'Unser Haushalt',
  join_code text not null unique default upper(substr(replace(gen_random_uuid()::text,'-',''),1,8)),
  state jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  updated_by uuid references auth.users(id) on delete set null
);

create table if not exists public.household_members (
  household_id uuid not null references public.households(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (household_id,user_id),
  unique (user_id)
);

alter table public.households enable row level security;
alter table public.household_members enable row level security;

revoke all on public.households from anon;
revoke all on public.household_members from anon;
grant select, update on public.households to authenticated;
grant select on public.household_members to authenticated;

create or replace function public.is_household_member(p_household_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.household_members hm
    where hm.household_id = p_household_id
      and hm.user_id = auth.uid()
  );
$$;

grant execute on function public.is_household_member(uuid) to authenticated;

drop policy if exists "members_select_own" on public.household_members;
create policy "members_select_own"
on public.household_members
for select
to authenticated
using (user_id = auth.uid());

drop policy if exists "households_select_member" on public.households;
create policy "households_select_member"
on public.households
for select
to authenticated
using (public.is_household_member(id));

drop policy if exists "households_update_member" on public.households;
create policy "households_update_member"
on public.households
for update
to authenticated
using (public.is_household_member(id))
with check (public.is_household_member(id));

create or replace function public.create_household(p_name text, p_state jsonb)
returns table(household_id uuid, join_code text)
language plpgsql
security definer
set search_path = public
as $$
declare
  h public.households;
begin
  if auth.uid() is null then raise exception 'Nicht angemeldet'; end if;
  if exists(select 1 from public.household_members where user_id=auth.uid()) then
    raise exception 'Dieses Konto ist bereits einem Haushalt zugeordnet';
  end if;
  insert into public.households(name,state,updated_by)
  values(coalesce(nullif(trim(p_name),''),'Unser Haushalt'),coalesce(p_state,'{}'::jsonb),auth.uid())
  returning * into h;
  insert into public.household_members(household_id,user_id) values(h.id,auth.uid());
  return query select h.id,h.join_code;
end;
$$;

grant execute on function public.create_household(text,jsonb) to authenticated;

create or replace function public.join_household(p_code text)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  hid uuid;
begin
  if auth.uid() is null then raise exception 'Nicht angemeldet'; end if;
  if exists(select 1 from public.household_members where user_id=auth.uid()) then
    raise exception 'Dieses Konto ist bereits einem Haushalt zugeordnet';
  end if;
  select id into hid from public.households where join_code=upper(trim(p_code));
  if hid is null then raise exception 'Einladungscode nicht gefunden'; end if;
  insert into public.household_members(household_id,user_id) values(hid,auth.uid());
  return hid;
end;
$$;

grant execute on function public.join_household(text) to authenticated;

-- Realtime für Änderungen am gemeinsamen Haushalt aktivieren
alter table public.households replica identity full;
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname='supabase_realtime' and schemaname='public' and tablename='households'
  ) then
    alter publication supabase_realtime add table public.households;
  end if;
end $$;
