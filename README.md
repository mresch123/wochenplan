# Wochenplan & Einkauf

GitHub-Pages-Version der privaten Wochenplan-App.

## Veröffentlichung
1. Neues GitHub-Repository anlegen, z. B. `wochenplan`.
2. Alle Dateien dieses Ordners in das Stammverzeichnis (`root`) des Repositories hochladen.
3. GitHub: **Settings → Pages → Build and deployment**.
4. **Source: Deploy from a branch**, Branch **main**, Folder **/(root)**, dann **Save**.
5. Nach dem Deployment ist die App typischerweise unter `https://<BENUTZERNAME>.github.io/wochenplan/` erreichbar.

## Funktionen
- Rollierender 4-Wochen-Plan mit 30 Gerichten
- Automatisch erzeugte Einkaufsliste aus den Rezepten, mit fixem Vorrat für Öle, Gewürze, Suppenwürfel, Honig und Wein
- Zusätzliche freie Einkaufsartikel pro Woche, inkl. Abhaken und Entfernen
- Export/Import als Backup

## Datenübernahme
Die App speichert Nutzdaten derzeit lokal im Browser. Vor dem Wechsel von einer lokalen HTML-Datei am besten **Export** verwenden und in der GitHub-Version anschließend **Import**.

## Dateien
- `index.html` – komplette App
- `manifest.webmanifest` – PWA-Metadaten
- `sw.js` – Offline-Cache / Service Worker
- `icon-192.png`, `icon-512.png` – App-Symbole (Wochenplan-/Einkauf-Icon)
- `.nojekyll` – verhindert unnötige Jekyll-Verarbeitung

## Später: Supabase
Für die geplante Synchronisation zwischen zwei Personen kann diese GitHub-Pages-URL als Site-/Redirect-URL in Supabase verwendet werden.
