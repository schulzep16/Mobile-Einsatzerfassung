# Mobile Einsatzberichte

Feuerwehr Einsatzdokumentation mit Flutter.

## Webbetrieb

Die App ist fuer Web aktiviert und kann als reine Webapp betrieben werden.

### Lokaler Start (Web)

```bash
flutter run -d chrome
```

### Web-Release bauen

```bash
flutter build web
```

Das Build liegt danach in `build/web`.

### Verteilung

Die Webapp besteht aus statischen Dateien. Zur Verteilung wird nur ein statischer Host benoetigt
(z. B. Nginx, Apache, GitHub Pages, Netlify, internes Intranet-Hosting).

### Offline-Nutzung (PWA)

Nach dem ersten Laden kann die App als PWA installiert werden und mit lokalem Datenspeicher
weiterlaufen. Internet wird danach fuer den Betrieb nicht dauerhaft benoetigt.

## Hinweis zu Plattformen

Die App kann weiterhin auch als mobile Flutter-App gebaut werden.
