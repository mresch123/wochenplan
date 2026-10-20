# Wochenplan & Einkauf

Gemeinsamer rollierender Wochenplan mit Einkaufsliste.

## Dateien
- `index.html` – App inkl. Supabase-Anbindung
- `manifest.webmanifest` – PWA-Metadaten
- `sw.js` – Offline-Cache
- `icon-192.png`, `icon-512.png` – App-Icons
- `supabase-setup.sql` – einmalig im Supabase SQL Editor ausführen

## GitHub Pages
Repository `wochenplan` → Settings → Pages → Deploy from branch → `main` → `/(root)`.

## Supabase
1. `supabase-setup.sql` vollständig im SQL Editor ausführen.
2. Authentication → URL Configuration:
   - Site URL: `https://mresch123.github.io/wochenplan/`
   - Redirect URL: `https://mresch123.github.io/wochenplan/`
3. App öffnen → Anmelden → Haushalt erstellen.
4. Einladungscode an zweite Person geben → dort registrieren → Code eingeben → Beitreten.
