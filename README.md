# Canti Liturgici (ChurchSongApp)

App Flutter personale per la pastorale musicale: catalogo di canti etichettati
per celebrazione e momento liturgico, scalette personalizzate e una modalità
"Celebrazione" per accompagnare l'evento dall'interno dell'app.

## Contenuti

- **28 canti demo** con testi segnaposto originali; le preghiere tradizionali
  (Padre Nostro, Ave Maria, Magnificat, Salve Regina) sono di pubblico dominio.
- **254 canti del canzoniere personale**, importati dai PDF in `song-sources/`:
  - *Canti per la Santa Messa* (ordinati per momento liturgico e anno);
  - *Lodate e benedite — Canti per la liturgia e per la preghiera* (SNPG-CEI);
  - *Canti — Santuario della Madonna delle Grazie*.

> **Uso personale.** I testi importati provengono dai canzonieri dell'utente e
> restano nel build locale con licenza `personalUse`. Non vanno ridistribuiti
> in una versione pubblica dell'app. Ogni scheda mostra la fonte e la pagina.
> La cartella `song-sources/` non è versionata.

Nessun file audio è incluso: la modalità celebrazione è una presentazione
guidata dei testi con avanzamento automatico delle strofe. L'audio è un "seam"
futuro già previsto nei modelli (`Song.audioAsset`) e nell'evento.

## Funzioni

- **Libreria cantabile** — ricerca per titolo/autore, preferiti, filtro per
  celebrazione, momento, tema, stagione (Avvento, Natale, Quaresima, Pasqua,
  Pentecoste, Defunti, Tradizionale), stile e strumento.
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

Build web di rilascio:

```bash
flutter build web --release
python3 -m http.server 8787 --directory build/web
```

Test e analisi:

```bash
flutter analyze   # 0 problemi
flutter test      # 63 test: modelli, catalogo, import, controller, persistenza, smoke e flussi end-to-end
```

## Import del canzoniere

Il catalogo personale è generato da `tool/import_songbook.py` con poppler:

```bash
sudo apt install poppler-utils           # pdftohtml, pdftotext
python3 tool/import_songbook.py          # rigenera assets/data/personal_songs.json
python3 tool/import_songbook.py --report # elenco titoli/autori/tag
```

Lo script ricostruisce l'ordine di lettura dalle coordinate PDF, separa i canti
dai titoli di sezione, estrae autori e ritornelli, normalizza titoli e accenti,
deduplica le versioni presenti in più canzonieri e conserva fonte e pagina.
Il file generato viene caricato all'avvio da `PersonalSongsService` e unito al
catalogo in `LibraryController`.

## Architettura

Local-first, nessun backend: tutto lo stato utente vive in
`SharedPreferences` come JSON versioned (`churchsong.v1.*`), incapsulato in
`LocalStore`.

```
lib/
  main.dart                     bootstrap: LocalStore + canzoniere personale
  app.dart                      MultiProvider + MaterialApp (theme, locale, l10n)
  core/        theme.dart       palette, tipografia (Cormorant + Manrope), componenti
               strings.dart     stringhe IT/EN + delegate
  domain/      models.dart      Song, Tag, LiturgicalFunction/Moment, Setlist… (no Flutter)
               catalog.dart     tag statici, 4 celebrazioni con momenti, 28 canti demo
  data/        local_store.dart wrapper SharedPreferences
               personal_songs_service.dart  carica assets/data/personal_songs.json
               library_controller.dart  catalogo + canzoniere + user songs, filtri
               setlist_controller.dart  CRUD scalette + seed demo
               settings_controller.dart lingua, tema, premium
               services.dart    DownloadService (stub) + SyncService (stub locale)
  ui/          shell/           shell responsive: bottom nav / navigation rail (≥960px)
               home/ library/ function/ setlists/ event/ settings/ shared/
tool/          import_songbook.py  estrattore PDF -> JSON (poppler)
assets/data/   personal_songs.json  canzoniere personale (254 canti)
song-sources/  PDF originali dell'utente (ignorati da git)
```

Scelte prototipali pensate per l'evoluzione:

- **i18n**: i titoli dei canti sono `Map<String, String>` per lingua; le
  stringhe UI vivono in una classe unica pronta a migrare ad ARB/`intl`.
- **offline**: `DownloadService` è un'interfaccia: sostituire il demo con
  caricamenti reali (CDN/PDF/audio) non tocca controller né UI.
- **cloud sync**: `Setlist.remoteId`, `SyncService` e il persist layer
  isolano già ciò che andrà sincronizzato; sostituire `LocalStore` con un DB
  (Drift/Isar) è trasparente ai repository.
- **licenze**: `SongLicense.personalUse` tiene separato il canzoniere locale
  dal catalogo pubblico/demo e impedisce di confondere i due regimi.

## Roadmap

1. ~~Catalogo reale da import~~ — fatto: 254 canti dai tre canzonieri.
2. Verifica manuale di titoli/autori ambigui e aggiunta di YouTube/spartiti.
3. Audio reale: player, trasposizione, file scaricati sul device.
4. Sincronizzazione multi-account con backend quando sarà definito.
5. Stampa/definitivo dei fogli con tonalità e testi.
