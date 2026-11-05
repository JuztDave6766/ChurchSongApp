# Canti Liturgici (ChurchSongApp)

Prototipo funzionante di un'app Flutter per la pastorale musicale: catalogo di
canti etichettati per celebrazione e momento liturgico, scalette personalizzate
e una modalità "Celebrazione" per accompagnare l'evento dall'interno
dell'app.

> **Contenuti demo.** I 28 canti del catalogo sono testi segnaposto originali
> (le preghiere tradizionali — Padre Nostro, Ave Maria, Magnificat, Salve
> Regina — sono di pubblico dominio). Nessun file audio è incluso: la
> modalità celebrazione è una presentazione guidata dei testi con avanzamento
> automatico delle strofe. L'audio è un "seam" futuro già previsto nei modelli
> (`Song.audioAsset`) e nell'evento.

## Funzioni

- **Libreria cantabile** — ricerca, preferiti, filtro per tag
  (celebrazione: Messa, Via Crucis, Adorazione, Preghiera; momento:
  ingresso, offertorio, comunione, stazione, benedizione, …; temi).
- **Percorso per celebrazione** — si sceglie la funzione liturgica e si
  sfoglia i canti adatti a ogni momento, con suggerimenti contestuali.
- **Scalette** — creazione/modifica (nome, momenti, ordine dei canti,
  selezione dal picker filtrato), persistenza locale, scaletta demo "Messa
  domenicale".
- **Modalità Celebrazione** — schermata immersiva con cronometro, avanzamento
  strofa per strofa, canto precedente/successivo, registrazione dei canti
  percorsi e riepilogo finale.
- **Download offline (Premium)** — simulati via `DemoDownloadService`:
  entitlement, dialog di attivazione demo, download singolo o "scarica tutti",
  indicatore offline nelle liste.
- **IT/EN** — cambi lingua immediato, stringhe centralizzate in
  `lib/core/strings.dart` (custom delegate + `flutter_localizations`).
- **Tema chiaro/scuro** con palette liturgica (pergamena/viola/oro), Material 3.

## Avvio

Flutter non è sul PATH di default; è installato in `~/Programs/flutter`.

```bash
export PATH="$HOME/Programs/flutter/bin:$PATH"

flutter pub get
flutter run                 # su dispositivo/emulatore attivo
flutter run -d chrome       # preview web in hot reload
```

Build web di rilascio (già presente in `build/web`, servibile con un semplice
server statico):

```bash
flutter build web --release
python3 -m http.server 8787 --directory build/web
```

Test e analisi:

```bash
flutter analyze   # 0 problemi
flutter test      # 41 test: modelli, catalogo, controller, persistenza, smoke e flussi end-to-end
```

## Architettura

Local-first, nessun backend: tutto lo stato utente vive in
`SharedPreferences` come JSON versioned (`churchsong.v1.*`), incapsulato in
`LocalStore`.

```
lib/
  main.dart                     bootstrap: apre LocalStore, monta ChurchSongApp
  app.dart                      MultiProvider + MaterialApp (theme, locale, l10n)
  core/        theme.dart       palette, tipografia (Cormorant + Manrope), componenti
               strings.dart     stringhe IT/EN + delegate
  domain/      models.dart      Song, Tag, LiturgicalFunction/Moment, Setlist… (no Flutter: riutilizzabili per cloud-sync/isolati)
               catalog.dart     tag statici, 4 celebrazioni con momenti, 28 canti demo
  data/        local_store.dart wrapper SharedPreferences (JSON, prefisso di versione)
               library_controller.dart  preferiti, download, query/filtri
               setlist_controller.dart  CRUD scalette + seed demo
               settings_controller.dart lingua, tema, premium
               services.dart    DownloadService (stub) + SyncService (stub locale)
  ui/          shell/           shell responsive: bottom nav / navigation rail (≥960px)
               home/ library/ function/ setlists/ event/ settings/ shared/
```

Scelte prototipali pensate per l'evoluzione:

- **i18n**: i titoli dei canti sono `Map<String, String>` per lingua; le
  stringhe UI vivono in una classe unica pronta a migrare ad ARB/`intl`.
- **offline**: `DownloadService` è un'interfaccia: sostituire il demo con
  caricamenti reali (CDN/PDF/audio) non tocca controller né UI.
- **cloud sync**: `Setlist.remoteId`, `SyncService` e il persist layer
  isolarono già ciò che andrà sincronizzato; sostituire `LocalStore` con un DB
  (Drift/Isar) è trasparente ai repository.

## Roadmap

1. Catalogo reale da CMS/import (oggi il catalogo è compilato a mano in
   `catalog.dart`).
2. Audio reale: player (solo testo demo oggi), trasposizione, file scaricati
   sul device.
3. Sincronizzazione multi-account con backend quando sarà definito.
4. Stampa/definitivo dei fogli con tonalità e testi.
