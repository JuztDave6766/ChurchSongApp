# Canti Liturgici — ChurchSongApp

Demo pubblica di un canzoniere liturgico: 254 canti, ricerca, scalette,
modalità celebrazione, letture domenicali verificate e stampa A4.

**Demo:** https://juztdave6766.github.io/ChurchSongApp/

## Cosa contiene

- **254 canti** importati dai canzonieri dell'autore del repository, con fonte
  e pagina. I testi sono presentati come canzoniere (accordi sopra il testo in
  notazione ChordPro, oppure testo con link per ascoltare il brano).
- **Libreria cantabile** — ricerca per titolo, autore e versione; preferiti;
  filtri per celebrazione, momento liturgico, tema, stagione, stile e strumento.
- **Percorso per celebrazione** — si sceglie la funzione liturgica e si
  sfoglia il repertorio adatto a ogni momento.
- **Scalette** — creazione, modifica, riordino e persistenza locale; cinque
  modelli pronti costruiti sul repertorio reale e una scaletta demo.
- **Modalità Celebrazione** — schermata immersiva con avanzamento delle strofe,
  cronometro e riepilogo finale.
- **Letture del giorno** — calendario **Anno A** (Avvento 2025 → Cristo Re
  2026) verificato sulle citazioni CEI. Le voci non verificate sono nascoste.
- **Stampa A4** — anteprima e PDF con titolo, autore, fonte, tonalità, accordi
  e testo.
- **Modifica locale** — ogni canto importato può essere corretto; le modifiche
  restano nel browser e “Ripristina originale” annulla tutto.
- **Backup JSON** — esporta e reimporta modifiche, preferiti, scalette e canti
  personali.
- **IT/EN** e tema chiaro/scuro.

## Dati locali

Non esistono account, server o sincronizzazione. Preferiti, modifiche,
scalette e canti personali vivono in `localStorage` (SharedPreferences) del
browser. Il pulsante **Ripristina demo** cancella i dati locali e riporta
l'app allo stato iniziale. Usa **Esporta dati** per conservare una copia JSON.

## Sviluppo

Flutter non è sul PATH di default; in questo ambiente è in
`~/Programs/flutter`.

```bash
export PATH="$HOME/Programs/flutter/bin:$PATH"

flutter pub get
flutter run -d chrome
flutter analyze
flutter test
```

Build web con il base path di GitHub Pages:

```bash
flutter build web --release --base-href /ChurchSongApp/
python3 -m http.server 8787 --directory build/web
```

## Import del canzoniere

Il catalogo è generato da `tool/import_songbook.py` con poppler:

```bash
sudo apt install poppler-utils
python3 tool/import_songbook.py          # rigenera assets/data/personal_songs.json
python3 tool/import_songbook.py --report # elenco titoli/autori/tag
```

Lo script ricostruisce l'ordine di lettura dalle coordinate PDF, separa i canti
dai titoli di sezione, estrae autori e ritornelli, normalizza titoli e accenti,
deduplica le versioni presenti in più canzonieri e conserva fonte e pagina.
La cartella `song-sources/` con i PDF originali non è versionata.

## Letture domenicali

`assets/data/sundays.json` contiene le 52 domeniche dell'Anno A. Ogni voce ha
`verified: true`, la citazione CEI e l'URL della fonte. Il controller mostra
solo le voci verificate e, fuori dall'intervallo del calendario, non ripete
letture vecchie.

## Architettura

Local-first, nessun backend: lo stato utente vive in SharedPreferences come
JSON versionato (`churchsong.v1.*`), incapsulato in `LocalStore`.

```
lib/
  main.dart                     bootstrap
  app.dart                      provider + MaterialApp (tema, lingua)
  core/        theme.dart       palette e tipografia
               strings.dart     stringhe IT/EN
  domain/      models.dart      Song, Tag, LiturgicalFunction, Setlist…
               catalog.dart     tag, celebrazioni, modelli di scaletta
               chordpro.dart    parser ChordPro
  data/        local_store.dart
               personal_songs_service.dart
               library_controller.dart   catalogo, override, preferiti, backup
               setlist_controller.dart
               settings_controller.dart
               sundays_service.dart
               backup_file*.dart
  ui/          shell/ home/ library/ function/ setlists/ event/ settings/ shared/
tool/          import_songbook.py
assets/data/   personal_songs.json, sundays.json
```

## Licenze

- **Codice:** MIT — vedi [LICENSE](LICENSE).
- **Testi, accordi e arrangiamenti:** tutti i diritti riservati, pubblicati con
  il permesso dell'autore del repository. Dettagli e crediti in
  [CREDITS.md](CREDITS.md).

Per segnalazioni di copyright o richieste di rimozione apri una issue:
https://github.com/JuztDave6766/ChurchSongApp/issues
