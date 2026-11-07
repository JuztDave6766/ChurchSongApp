import 'package:flutter/widgets.dart';

import '../domain/models.dart';

/// Lightweight, compile-time checked localisation.
///
/// Every user-visible string goes through this class. Adding a language means
/// adding one implementation and one line in [supportedLocales]; no code
/// generation step is required. The app is wired to `MaterialApp.locale`, so
/// switching language rebuilds the whole tree.
abstract class AppStrings {
  const AppStrings();

  static AppStrings of(BuildContext context) =>
      Localizations.of<AppStrings>(context, AppStrings)!;

  String get languageCode;

  // App & navigation.
  String get appName;
  String get appTagline;
  String get navHome;
  String get navSongs;
  String get navSetlists;
  String get navSettings;

  // Common.
  String get cancel;
  String get close;
  String get save;
  String get delete;
  String get done;
  String get all;
  String get remove;
  String songCount(int count);
  String momentCount(int count);
  String minutesShort(int minutes);
  String get optional;

  // Home.
  String get homeGreeting;
  String get homeTitle;
  String get homeSubtitle;
  String get chooseCelebration;
  String get chooseCelebrationHint;
  String get recentSetlists;
  String get seeAll;
  String get noSetlistsHome;
  String get startPreparing;

  // Celebration / function detail.
  String get celebrationMoments;
  String get createSetlist;
  String get browseSongs;
  String songsForMoment(int count);
  String get recommendedSongs;

  // Song library.
  String get libraryTitle;
  String get librarySubtitle;
  String get searchSongs;
  String get favoritesOnly;
  String get filterBy;
  String get clearFilters;
  String get noSongsFound;
  String get noSongsFoundHint;
  String get songsLabel;
  String get noSongs;
  String get themesLabel;
  String filtersCount(int count);

  // Styles, instruments and repertoire.
  String get stylesLabel;
  String get instrumentsLabel;
  String get youtubeLabel;
  String get watchOnYoutube;
  String get sheetMusic;
  String get openSheet;
  String get licenseLabel;
  String licenseName(SongLicense license);
  String get textProtectedTitle;
  String get textProtectedBody;
  String get personalSourceLabel;

  // Add song flow.
  String get addSong;
  String get addSongTitle;
  String get addSongMode;
  String get addSongAutomatic;
  String get addSongManual;
  String get importTitleHint;
  String get youtubeUrlLabel;
  String get fetchInfo;
  String get fetching;
  String get searchOnline;
  String get searchOnlineHint;
  String get titleField;
  String get authorField;
  String get keyField;
  String get textSectionsHint;
  String get youtubeIdField;
  String get sheetUrlField;
  String get songSaved;
  String get importedData;
  String get importError;
  String get editSong;
  String get deleteSong;
  String get deleteSongQuestion;

  // Sunday readings.
  String get sundaysCardTitle;
  String get sundaysCardHint;
  String get firstReading;
  String get prayerVariantTitle;
  String get prayerVariantHint;
  String get navCalendar;
  String get calendarTitle;
  String get calendarSubtitle;
  String get calendarToday;
  String get calendarNoData;
  String get prepareMassForDay;
  String get saintsOfTheDay;
  String get massOfDay;
  String get chordsSearch;
  String get psalmReading;
  String get psalmResponseLabel;
  String get secondReading;
  String get gospel;
  String get suggestedPsalm;
  String get suggestedAlleluia;
  String get suggestedCommunion;
  String get createSundaySetlist;
  String get sundayNoData;

  // Ready-made templates.
  String get fromTemplate;
  String get templatesTitle;
  String get useTemplate;

  // Settings: YouTube key.
  String get youtubeApiKeyLabel;
  String get youtubeApiKeyHint;
  String get keySaved;

  // Song detail.
  String get songDetails;
  String get lyricsLabel;
  String get keyLabel;
  String get authorLabel;
  String get addToSetlist;
  String get addedToSetlist;
  String get favoriteAdded;
  String get favoriteRemoved;
  String sectionVerse(int number);
  String get sectionChorus;
  String get sectionBridge;
  String get sectionResponse;

  // Setlists.
  String get setlistsTitle;
  String get setlistsSubtitle;
  String get newSetlist;
  String get emptySetlistsTitle;
  String get emptySetlistsBody;
  String get createFirstSetlist;
  String get untitledSetlist;
  String get setlistName;
  String get setlistNameHint;
  String get startCelebration;
  String get editSetlist;
  String get deleteSetlist;
  String get deleteSetlistQuestion;
  String get setlistSaved;
  String get noSongsYet;
  String get addSongs;
  String get replaceSong;
  String get addToMoment;
  String get chooseSong;
  String get add;
  String get moveUp;
  String get moveDown;
  String get setlistDetail;
  String get emptyMoment;

  // Event.
  String get eventMode;
  String get nowSinging;
  String get nextSong;
  String get previousSong;
  String get finishEvent;
  String get finishEventQuestion;
  String get eventComplete;
  String get eventCompleteBody;
  String songsSung(int count);
  String get elapsedLabel;
  String get backToSetlist;
  String get presentation;
  String get playPresentation;
  String get pausePresentation;
  String get exitEvent;
  String get exitEventQuestion;
  String get stay;
  String get exit;
  String get upcoming;
  String get eventNoSongs;
  String get audioDemoNotice;
  String stanzaProgress(int current, int total);

  // Settings.
  String get settingsTitle;
  String get settingsSubtitle;
  String get language;
  String get italian;
  String get english;
  String get appearance;
  String get systemTheme;
  String get lightTheme;
  String get darkTheme;
  String get premium;
  String get premiumDescription;
  String get premiumActive;
  String get premiumInactive;
  String get enablePremiumDemo;
  String get premiumFeatureTitle;
  String get premiumFeatureBody;
  String get activateDemo;
  String get downloadAll;
  String get allDownloaded;
  String get offline;
  String get offlineDescription;
  String get downloadedSongs;
  String get noDownloads;
  String get download;
  String get downloading;
  String get downloaded;
  String get removeDownload;
  String get sync;
  String get syncDescription;
  String get syncComingSoon;
  String get about;
  String get aboutDescription;
  String get version;
  String get resetData;
  String get resetDataQuestion;
  String get reset;
  String get dataReset;

  // Public demo, chords, print, backup and credits.
  String get demoBadge;
  String get localDataTitle;
  String get localDataBody;
  String get versionField;
  String get chordProHint;
  String get printSong;
  String get printHint;
  String get closePrint;
  String get searchOnYoutube;
  String get locallyEdited;
  String get restoreOriginal;
  String get backupTitle;
  String get backupDescription;
  String get exportData;
  String get importData;
  String get backupExported;
  String get backupImported;
  String get backupInvalid;
  String get copyData;
  String get pasteData;
  String get creditsTitle;
  String get creditsBody;
  String get openCredits;
  String get takedown;
}

class AppStringsIt extends AppStrings {
  const AppStringsIt();

  @override
  String get languageCode => 'it';

  @override
  String get appName => 'Canti Liturgici';
  @override
  String get appTagline => 'Prepara, raccogli e vivi la tua celebrazione';
  @override
  String get navHome => 'Oggi';
  @override
  String get navSongs => 'Canti';
  @override
  String get navSetlists => 'Scalette';
  @override
  String get navSettings => 'Impostazioni';

  @override
  String get cancel => 'Annulla';
  @override
  String get close => 'Chiudi';
  @override
  String get save => 'Salva';
  @override
  String get delete => 'Elimina';
  @override
  String get done => 'Fatto';
  @override
  String get all => 'Tutti';
  @override
  String get remove => 'Rimuovi';
  @override
  String songCount(int count) => count == 1 ? '1 canto' : '$count canti';
  @override
  String momentCount(int count) =>
      count == 1 ? '1 momento' : '$count momenti';
  @override
  String minutesShort(int minutes) => '$minutes min';
  @override
  String get optional => 'facoltativo';

  @override
  String get homeGreeting => 'Il Signore sia con voi';
  @override
  String get homeTitle => 'La tua celebrazione,\nun canto alla volta.';
  @override
  String get homeSubtitle =>
      'Scegli la funzione liturgica e componi la scaletta giusta per ogni momento.';
  @override
  String get chooseCelebration => 'Scegli la celebrazione';
  @override
  String get chooseCelebrationHint =>
      'I canti verranno filtrati per il momento liturgico.';
  @override
  String get recentSetlists => 'Le tue scalette';
  @override
  String get seeAll => 'Vedi tutte';
  @override
  String get noSetlistsHome =>
      'Non hai ancora preparato nessuna scaletta. Inizia da una celebrazione.';
  @override
  String get startPreparing => 'Inizia a preparare';

  @override
  String get celebrationMoments => 'Momenti della celebrazione';
  @override
  String get createSetlist => 'Crea una scaletta';
  @override
  String get browseSongs => 'Sfoglia i canti';
  @override
  String songsForMoment(int count) =>
      count == 1 ? '1 canto adatto' : '$count canti adatti';
  @override
  String get recommendedSongs => 'Canti consigliati';

  @override
  String get libraryTitle => 'Canti';
  @override
  String get librarySubtitle => 'Tutti i canti, ordinati per tag e momento.';
  @override
  String get searchSongs => 'Cerca un canto...';
  @override
  String get favoritesOnly => 'Preferiti';
  @override
  String get filterBy => 'Filtra per tag';
  @override
  String get clearFilters => 'Azzera filtri';
  @override
  String get noSongsFound => 'Nessun canto trovato';
  @override
  String get noSongsFoundHint =>
      'Prova a cambiare la ricerca o a rimuovere qualche filtro.';
  @override
  String get songsLabel => 'Canti';
  @override
  String get noSongs => 'Nessun canto disponibile.';
  @override
  String get themesLabel => 'Temi';
  @override
  String filtersCount(int count) =>
      count == 1 ? '1 filtro attivo' : '$count filtri attivi';

  @override
  String get stylesLabel => 'Stili';
  @override
  String get instrumentsLabel => 'Strumenti';
  @override
  String get youtubeLabel => 'YouTube';
  @override
  String get watchOnYoutube => 'Guarda su YouTube';
  @override
  String get sheetMusic => 'Spartito';
  @override
  String get openSheet => 'Apri lo spartito';
  @override
  String get licenseLabel => 'Licenza';
  @override
  String licenseName(SongLicense license) => switch (license) {
        SongLicense.demo => 'Testo demo',
        SongLicense.publicDomain => 'Pubblico dominio',
        SongLicense.copyrighted => 'Diritti riservati',
        SongLicense.personalUse => 'Canzoniere personale',
      };
  @override
  String get textProtectedTitle => 'Testo non incluso';
  @override
  String get textProtectedBody =>
      'Questo canto è protetto da copyright: il testo non è distribuito '
      'dall\'app. Inseriscilo dal tuo canzoniere autorizzato e usa i link '
      'qui sotto per l\'anteprima e lo spartito.';
  @override
  String get personalSourceLabel => 'Fonte';
  @override
  String get addSong => 'Aggiungi canto';
  @override
  String get addSongTitle => 'Aggiungi un canto';
  @override
  String get addSongMode => 'Come vuoi aggiungerlo?';
  @override
  String get addSongAutomatic => 'Automatico';
  @override
  String get addSongManual => 'Manuale';
  @override
  String get importTitleHint =>
      'Incolla un link YouTube oppure scrivi il titolo e cerca online.';
  @override
  String get youtubeUrlLabel => 'Link YouTube*';
  @override
  String get fetchInfo => 'Estrai i dati';
  @override
  String get fetching => 'Ricerca...';
  @override
  String get searchOnline => 'Cerca online';
  @override
  String get searchOnlineHint =>
      'Apre YouTube con la tua ricerca: copia poi titolo, autore e tag, '
      'oppure incola il link per completare l\'importazione.';
  @override
  String get titleField => 'Titolo';
  @override
  String get authorField => 'Autore';
  @override
  String get keyField => 'Tonalità';
  @override
  String get textSectionsHint =>
      'Una strofa per blocco, separata da una riga vuota. Scrivi "R:" in '
      'prima riga per un ritornello. Accordi inline: [Re]Alzo gli occhi.';
  @override
  String get youtubeIdField => 'ID video YouTube';
  @override
  String get sheetUrlField => 'Link allo spartito (URL)';
  @override
  String get songSaved => 'Canto salvato nella libreria';
  @override
  String get importedData => 'Dati recuperati: controlla e completa';
  @override
  String get importError => 'Importazione fallita. Controlla il link o la rete.';
  @override
  String get editSong => 'Modifica canto';
  @override
  String get deleteSong => 'Elimina canto';
  @override
  String get deleteSongQuestion =>
      'Eliminare questo canto dalla tua libreria? Non si può annullare.';

  @override
  String get sundaysCardTitle => 'Letture del giorno';
  @override
  String get sundaysCardHint =>
      'Letture domenicali (Anno A, Avvento 2025 – Cristo Re 2026) e canti suggeriti a tema.';
  @override
  String get prayerVariantTitle => 'Tipo di preghiera';
  @override
  String get prayerVariantHint =>
      'Scegli se è una preghiera libera o dal breviario, di mattina o di sera.';
  @override
  String get navCalendar => 'Calendario';
  @override
  String get calendarTitle => 'Calendario liturgico';
  @override
  String get calendarSubtitle =>
      'Tempi liturgici, santi e messe del giorno per l\'Anno A.';
  @override
  String get calendarToday => 'Oggi';
  @override
  String get calendarNoData =>
      'Nessun dato verificato per questa data.';
  @override
  String get prepareMassForDay => 'Prepara la Messa del giorno';
  @override
  String get saintsOfTheDay => 'Santo del giorno';
  @override
  String get massOfDay => 'Messa del giorno';
  @override
  String get chordsSearch => 'Cerca accordi online';
  @override
  String get firstReading => 'Prima lettura';
  @override
  String get psalmReading => 'Salmo responsoriale';
  @override
  String get psalmResponseLabel => 'Risposta';
  @override
  String get secondReading => 'Seconda lettura';
  @override
  String get gospel => 'Vangelo';
  @override
  String get suggestedPsalm => 'Per il salmo';
  @override
  String get suggestedAlleluia => 'Per l\'alleluia';
  @override
  String get suggestedCommunion => 'Per la comunione';
  @override
  String get createSundaySetlist => 'Crea una scaletta a tema';
  @override
  String get sundayNoData =>
      'Le letture di questa domenica non sono presenti nel calendario '
      'verificato della demo (Anno A: Avvento 2025 – Cristo Re 2026).';

  @override
  String get fromTemplate => 'Da modello';
  @override
  String get templatesTitle => 'Modelli pronti';
  @override
  String get useTemplate => 'Usa questo modello';

  @override
  String get youtubeApiKeyLabel => 'Chiave YouTube Data API (facoltativa)';
  @override
  String get youtubeApiKeyHint =>
      'Abilita la ricerca automatica dei canti da titolo.';
  @override
  String get keySaved => 'Chiave salvata';

  @override
  String get songDetails => 'Canto';
  @override
  String get lyricsLabel => 'Testo';
  @override
  String get keyLabel => 'Tonalità';
  @override
  String get authorLabel => 'Autore';
  @override
  String get addToSetlist => 'Aggiungi a una scaletta';
  @override
  String get addedToSetlist => 'Canto aggiunto alla scaletta';
  @override
  String get favoriteAdded => 'Aggiunto ai preferiti';
  @override
  String get favoriteRemoved => 'Rimosso dai preferiti';
  @override
  String sectionVerse(int number) => 'Strofa $number';
  @override
  String get sectionChorus => 'Ritornello';
  @override
  String get sectionBridge => 'Ponte';
  @override
  String get sectionResponse => 'Risposta';

  @override
  String get setlistsTitle => 'Scalette';
  @override
  String get setlistsSubtitle =>
      'I tuoi elenchi di canti, pronti per la celebrazione.';
  @override
  String get newSetlist => 'Nuova scaletta';
  @override
  String get emptySetlistsTitle => 'Ancora nessuna scaletta';
  @override
  String get emptySetlistsBody =>
      'Crea un elenco di canti per una celebrazione: potrai riaprirlo e avviarlo quando vuoi.';
  @override
  String get createFirstSetlist => 'Crea la prima scaletta';
  @override
  String get untitledSetlist => 'Scaletta senza titolo';
  @override
  String get setlistName => 'Nome della scaletta';
  @override
  String get setlistNameHint => 'Es. Messa domenicale delle 10';
  @override
  String get startCelebration => 'Avvia la celebrazione';
  @override
  String get editSetlist => 'Modifica';
  @override
  String get deleteSetlist => 'Elimina scaletta';
  @override
  String get deleteSetlistQuestion =>
      'Vuoi eliminare questa scaletta? L\'operazione non può essere annullata.';
  @override
  String get setlistSaved => 'Scaletta salvata';
  @override
  String get noSongsYet => 'Nessun canto in questa scaletta';
  @override
  String get addSongs => 'Aggiungi canti';
  @override
  String get replaceSong => 'Sostituisci canto';
  @override
  String get addToMoment => 'Aggiungi a un momento';
  @override
  String get chooseSong => 'Scegli un canto';
  @override
  String get add => 'Aggiungi';
  @override
  String get moveUp => 'Sposta su';
  @override
  String get moveDown => 'Sposta giù';
  @override
  String get setlistDetail => 'Scaletta';
  @override
  String get emptyMoment => 'Nessun canto per questo momento';

  @override
  String get eventMode => 'Celebrazione';
  @override
  String get nowSinging => 'Ora si canta';
  @override
  String get nextSong => 'Canto successivo';
  @override
  String get previousSong => 'Canto precedente';
  @override
  String get finishEvent => 'Termina la celebrazione';
  @override
  String get finishEventQuestion =>
      'Vuoi concludere la celebrazione? La scaletta resterà salvata.';
  @override
  String get eventComplete => 'Celebrazione conclusa';
  @override
  String get eventCompleteBody =>
      'Grazie per aver cantato con la tua comunità.';
  @override
  String songsSung(int count) =>
      count == 1 ? '1 canto cantato' : '$count canti cantati';
  @override
  String get elapsedLabel => 'Tempo';
  @override
  String get backToSetlist => 'Torna alla scaletta';
  @override
  String get presentation => 'Presentazione';
  @override
  String get playPresentation => 'Avvia la presentazione';
  @override
  String get pausePresentation => 'Metti in pausa';
  @override
  String get exitEvent => 'Esci dalla celebrazione';
  @override
  String get exitEventQuestion =>
      'Vuoi uscire? La celebrazione resta salvata nella scaletta.';
  @override
  String get stay => 'Resta';
  @override
  String get exit => 'Esci';
  @override
  String get upcoming => 'In arrivo';
  @override
  String get eventNoSongs => 'Questa scaletta non contiene canti.';
  @override
  String get audioDemoNotice =>
      'Presentazione del testo: nessun file audio nella versione demo.';
  @override
  String stanzaProgress(int current, int total) => '$current di $total';

  @override
  String get settingsTitle => 'Impostazioni';
  @override
  String get settingsSubtitle => 'Personalizza l\'app e gestisci i contenuti.';
  @override
  String get language => 'Lingua';
  @override
  String get italian => 'Italiano';
  @override
  String get english => 'English';
  @override
  String get appearance => 'Aspetto';
  @override
  String get systemTheme => 'Sistema';
  @override
  String get lightTheme => 'Chiaro';
  @override
  String get darkTheme => 'Scuro';
  @override
  String get premium => 'Premium';
  @override
  String get premiumDescription =>
      'Sblocca il download dei canti per l\'uso offline. Nella demo puoi attivarlo liberamente.';
  @override
  String get premiumActive => 'Premium attivo';
  @override
  String get premiumInactive => 'Versione gratuita';
  @override
  String get enablePremiumDemo => 'Attiva premium (demo)';
  @override
  String get premiumFeatureTitle => 'Funzionalità Premium';
  @override
  String get premiumFeatureBody =>
      'Il download dei canti per l\'uso offline fa parte della versione Premium. Puoi attivarla ora in modalità demo.';
  @override
  String get activateDemo => 'Attiva demo';
  @override
  String get downloadAll => 'Scarica tutti i canti';
  @override
  String get allDownloaded => 'Tutti i canti sono disponibili offline';
  @override
  String get offline => 'Contenuti offline';
  @override
  String get offlineDescription =>
      'I canti scaricati restano disponibili anche senza connessione.';
  @override
  String get downloadedSongs => 'Canti scaricati';
  @override
  String get noDownloads => 'Nessun canto scaricato.';
  @override
  String get download => 'Scarica';
  @override
  String get downloading => 'Scaricamento...';
  @override
  String get downloaded => 'Scaricato';
  @override
  String get removeDownload => 'Rimuovi download';
  @override
  String get sync => 'Sincronizzazione cloud';
  @override
  String get syncDescription =>
      'Salva le scalette e i preferiti su più dispositivi. In arrivo in una prossima versione.';
  @override
  String get syncComingSoon => 'Prossimamente';
  @override
  String get about => 'Informazioni';
  @override
  String get aboutDescription =>
      'Canti Liturgici aiuta le comunità a preparare e vivere le celebrazioni. Contenuti demo inclusi nel prototipo.';
  @override
  String get version => 'Versione';
  @override
  String get resetData => 'Ripristina i dati demo';
  @override
  String get resetDataQuestion =>
      'Verranno eliminate scalette, preferiti e download. Vuoi continuare?';
  @override
  String get reset => 'Ripristina';
  @override
  String get dataReset => 'Dati ripristinati';

  @override
  String get demoBadge => 'Demo pubblica';
  @override
  String get localDataTitle => 'I tuoi dati restano in questo browser';
  @override
  String get localDataBody =>
      'La demo non ha account né sincronizzazione. Preferiti, modifiche e '
      'scalette sono salvati solo su questo dispositivo: esportali prima di '
      'cambiare browser o ripristinare la demo.';
  @override
  String get versionField => 'Versione / autore della musica';
  @override
  String get chordProHint =>
      'Accordi inline sopra la sillaba: [Re]Alzo gli occhi verso i [Sim]monti. '
      'Una strofa per blocco, separata da una riga vuota; "R:" per il '
      'ritornello.';
  @override
  String get printSong => 'Stampa';
  @override
  String get printHint =>
      'Foglio A4 pronto per la stampa: titolo, autore, fonte, accordi e testo.';
  @override
  String get closePrint => 'Chiudi';
  @override
  String get searchOnYoutube => 'Cerca su YouTube';
  @override
  String get locallyEdited => 'Modificato localmente';
  @override
  String get restoreOriginal => 'Ripristina originale';
  @override
  String get backupTitle => 'Backup e ripristino';
  @override
  String get backupDescription =>
      'Esporta preferiti, modifiche, canti creati e scalette in un file JSON. '
      'Importalo su un altro browser o dopo un ripristino.';
  @override
  String get exportData => 'Esporta dati';
  @override
  String get importData => 'Importa dati';
  @override
  String get backupExported => 'Backup esportato';
  @override
  String get backupImported => 'Backup importato';
  @override
  String get backupInvalid => 'Il file non è un backup valido';
  @override
  String get copyData => 'Copia';
  @override
  String get pasteData => 'Incolla il JSON';
  @override
  String get creditsTitle => 'Crediti e licenze';
  @override
  String get creditsBody =>
      'Il codice dell\'app è distribuito con licenza MIT. I testi e gli '
      'accordi provengono dai canzonieri indicati in ogni scheda e sono '
      'pubblicati su licenza dichiarata dal curatore della demo. Per '
      'richieste di rimozione apri una segnalazione su GitHub Issues.';
  @override
  String get openCredits => 'Apri i crediti';
  @override
  String get takedown => 'Segnala un problema di copyright';
}

class AppStringsEn extends AppStrings {
  const AppStringsEn();

  @override
  String get languageCode => 'en';

  @override
  String get appName => 'Liturgical Songs';
  @override
  String get appTagline => 'Prepare, gather and live your celebration';
  @override
  String get navHome => 'Today';
  @override
  String get navSongs => 'Songs';
  @override
  String get navSetlists => 'Setlists';
  @override
  String get navSettings => 'Settings';

  @override
  String get cancel => 'Cancel';
  @override
  String get close => 'Close';
  @override
  String get save => 'Save';
  @override
  String get delete => 'Delete';
  @override
  String get done => 'Done';
  @override
  String get all => 'All';
  @override
  String get remove => 'Remove';
  @override
  String songCount(int count) => count == 1 ? '1 song' : '$count songs';
  @override
  String momentCount(int count) =>
      count == 1 ? '1 moment' : '$count moments';
  @override
  String minutesShort(int minutes) => '$minutes min';
  @override
  String get optional => 'optional';

  @override
  String get homeGreeting => 'The Lord be with you';
  @override
  String get homeTitle => 'Your celebration,\none song at a time.';
  @override
  String get homeSubtitle =>
      'Choose the liturgical celebration and build the right setlist for every moment.';
  @override
  String get chooseCelebration => 'Choose the celebration';
  @override
  String get chooseCelebrationHint =>
      'Songs will be filtered by liturgical moment.';
  @override
  String get recentSetlists => 'Your setlists';
  @override
  String get seeAll => 'See all';
  @override
  String get noSetlistsHome =>
      'You have not prepared a setlist yet. Start from a celebration.';
  @override
  String get startPreparing => 'Start preparing';

  @override
  String get celebrationMoments => 'Moments of the celebration';
  @override
  String get createSetlist => 'Create a setlist';
  @override
  String get browseSongs => 'Browse songs';
  @override
  String songsForMoment(int count) =>
      count == 1 ? '1 suitable song' : '$count suitable songs';
  @override
  String get recommendedSongs => 'Recommended songs';

  @override
  String get libraryTitle => 'Songs';
  @override
  String get librarySubtitle => 'Every song, organised by tag and moment.';
  @override
  String get searchSongs => 'Search a song...';
  @override
  String get favoritesOnly => 'Favourites';
  @override
  String get filterBy => 'Filter by tag';
  @override
  String get clearFilters => 'Clear filters';
  @override
  String get noSongsFound => 'No songs found';
  @override
  String get noSongsFoundHint =>
      'Try changing your search or removing a filter.';
  @override
  String get songsLabel => 'Songs';
  @override
  String get noSongs => 'No songs available.';
  @override
  String get themesLabel => 'Themes';
  @override
  String filtersCount(int count) =>
      count == 1 ? '1 active filter' : '$count active filters';

  @override
  String get stylesLabel => 'Styles';
  @override
  String get instrumentsLabel => 'Instruments';
  @override
  String get youtubeLabel => 'YouTube';
  @override
  String get watchOnYoutube => 'Watch on YouTube';
  @override
  String get sheetMusic => 'Sheet music';
  @override
  String get openSheet => 'Open the sheet music';
  @override
  String get licenseLabel => 'Licence';
  @override
  String licenseName(SongLicense license) => switch (license) {
        SongLicense.demo => 'Demo text',
        SongLicense.publicDomain => 'Public domain',
        SongLicense.copyrighted => 'All rights reserved',
        SongLicense.personalUse => 'Personal songbook',
      };
  @override
  String get textProtectedTitle => 'Text not included';
  @override
  String get textProtectedBody =>
      'This song is copyrighted and its lyrics are not distributed by the '
      'app. Enter them from your authorised hymn book and use the links '
      'below for the preview and the sheet music.';
  @override
  String get personalSourceLabel => 'Source';
  @override
  String get addSong => 'Add song';
  @override
  String get addSongTitle => 'Add a song';
  @override
  String get addSongMode => 'How do you want to add it?';
  @override
  String get addSongAutomatic => 'Automatic';
  @override
  String get addSongManual => 'Manual';
  @override
  String get importTitleHint =>
      'Paste a YouTube link or type the title and search online.';
  @override
  String get youtubeUrlLabel => 'YouTube link*';
  @override
  String get fetchInfo => 'Fetch details';
  @override
  String get fetching => 'Searching...';
  @override
  String get searchOnline => 'Search online';
  @override
  String get searchOnlineHint =>
      'Opens YouTube with your query: then copy title, author and tags, '
      'or paste the link to complete the import.';
  @override
  String get titleField => 'Title';
  @override
  String get authorField => 'Author';
  @override
  String get keyField => 'Key';
  @override
  String get textSectionsHint =>
      'One verse per block, separated by a blank line. Write "R:" on the '
      'first line for a chorus. Inline chords: [D]I lift up my eyes.';
  @override
  String get youtubeIdField => 'YouTube video id';
  @override
  String get sheetUrlField => 'Sheet music link (URL)';
  @override
  String get songSaved => 'Song saved to your library';
  @override
  String get importedData => 'Details fetched: check and complete';
  @override
  String get importError => 'Import failed. Check the link or the connection.';
  @override
  String get editSong => 'Edit song';
  @override
  String get deleteSong => 'Delete song';
  @override
  String get deleteSongQuestion =>
      'Delete this song from your library? This cannot be undone.';

  @override
  String get sundaysCardTitle => "Today's readings";
  @override
  String get sundaysCardHint =>
      'Sunday readings (Year A, Advent 2025 – Christ the King 2026) with themed song suggestions.';
  @override
  String get prayerVariantTitle => 'Prayer type';
  @override
  String get prayerVariantHint =>
      'Choose a free prayer or the breviary, morning or evening.';
  @override
  String get navCalendar => 'Calendar';
  @override
  String get calendarTitle => 'Liturgical calendar';
  @override
  String get calendarSubtitle =>
      'Liturgical seasons, saints and daily Masses for Year A.';
  @override
  String get calendarToday => 'Today';
  @override
  String get calendarNoData =>
      'No verified data for this date.';
  @override
  String get prepareMassForDay => 'Prepare the day\'s Mass';
  @override
  String get saintsOfTheDay => 'Saint of the day';
  @override
  String get massOfDay => 'Mass of the day';
  @override
  String get chordsSearch => 'Search chords online';
  @override
  String get firstReading => 'First reading';
  @override
  String get psalmReading => 'Responsorial psalm';
  @override
  String get psalmResponseLabel => 'Response';
  @override
  String get secondReading => 'Second reading';
  @override
  String get gospel => 'Gospel';
  @override
  String get suggestedPsalm => 'For the psalm';
  @override
  String get suggestedAlleluia => 'For the alleluia';
  @override
  String get suggestedCommunion => 'For communion';
  @override
  String get createSundaySetlist => 'Create a themed setlist';
  @override
  String get sundayNoData =>
      'The readings for this Sunday are not in the demo\'s verified '
      'calendar (Year A: Advent 2025 – Christ the King 2026).';

  @override
  String get fromTemplate => 'From template';
  @override
  String get templatesTitle => 'Ready-made templates';
  @override
  String get useTemplate => 'Use this template';

  @override
  String get youtubeApiKeyLabel => 'YouTube Data API key (optional)';
  @override
  String get youtubeApiKeyHint =>
      'Enables automatic song lookup from the title.';
  @override
  String get keySaved => 'Key saved';

  @override
  String get songDetails => 'Song';
  @override
  String get lyricsLabel => 'Lyrics';
  @override
  String get keyLabel => 'Key';
  @override
  String get authorLabel => 'Author';
  @override
  String get addToSetlist => 'Add to a setlist';
  @override
  String get addedToSetlist => 'Song added to the setlist';
  @override
  String get favoriteAdded => 'Added to favourites';
  @override
  String get favoriteRemoved => 'Removed from favourites';
  @override
  String sectionVerse(int number) => 'Verse $number';
  @override
  String get sectionChorus => 'Chorus';
  @override
  String get sectionBridge => 'Bridge';
  @override
  String get sectionResponse => 'Response';

  @override
  String get setlistsTitle => 'Setlists';
  @override
  String get setlistsSubtitle =>
      'Your song lists, ready for the celebration.';
  @override
  String get newSetlist => 'New setlist';
  @override
  String get emptySetlistsTitle => 'No setlists yet';
  @override
  String get emptySetlistsBody =>
      'Create a list of songs for a celebration: reopen and start it whenever you like.';
  @override
  String get createFirstSetlist => 'Create your first setlist';
  @override
  String get untitledSetlist => 'Untitled setlist';
  @override
  String get setlistName => 'Setlist name';
  @override
  String get setlistNameHint => 'E.g. Sunday Mass at 10';
  @override
  String get startCelebration => 'Start the celebration';
  @override
  String get editSetlist => 'Edit';
  @override
  String get deleteSetlist => 'Delete setlist';
  @override
  String get deleteSetlistQuestion =>
      'Delete this setlist? This cannot be undone.';
  @override
  String get setlistSaved => 'Setlist saved';
  @override
  String get noSongsYet => 'No songs in this setlist';
  @override
  String get addSongs => 'Add songs';
  @override
  String get replaceSong => 'Replace song';
  @override
  String get addToMoment => 'Add to a moment';
  @override
  String get chooseSong => 'Choose a song';
  @override
  String get add => 'Add';
  @override
  String get moveUp => 'Move up';
  @override
  String get moveDown => 'Move down';
  @override
  String get setlistDetail => 'Setlist';
  @override
  String get emptyMoment => 'No songs for this moment';

  @override
  String get eventMode => 'Celebration';
  @override
  String get nowSinging => 'Now singing';
  @override
  String get nextSong => 'Next song';
  @override
  String get previousSong => 'Previous song';
  @override
  String get finishEvent => 'End the celebration';
  @override
  String get finishEventQuestion =>
      'End the celebration? The setlist will be kept.';
  @override
  String get eventComplete => 'Celebration complete';
  @override
  String get eventCompleteBody =>
      'Thank you for singing with your community.';
  @override
  String songsSung(int count) =>
      count == 1 ? '1 song sung' : '$count songs sung';
  @override
  String get elapsedLabel => 'Time';
  @override
  String get backToSetlist => 'Back to the setlist';
  @override
  String get presentation => 'Presentation';
  @override
  String get playPresentation => 'Start presentation';
  @override
  String get pausePresentation => 'Pause';
  @override
  String get exitEvent => 'Leave the celebration';
  @override
  String get exitEventQuestion =>
      'Leave now? The celebration is saved in the setlist.';
  @override
  String get stay => 'Stay';
  @override
  String get exit => 'Leave';
  @override
  String get upcoming => 'Up next';
  @override
  String get eventNoSongs => 'This setlist has no songs.';
  @override
  String get audioDemoNotice =>
      'Lyrics presentation: no audio files in the demo version.';
  @override
  String stanzaProgress(int current, int total) => '$current of $total';

  @override
  String get settingsTitle => 'Settings';
  @override
  String get settingsSubtitle => 'Personalise the app and manage content.';
  @override
  String get language => 'Language';
  @override
  String get italian => 'Italiano';
  @override
  String get english => 'English';
  @override
  String get appearance => 'Appearance';
  @override
  String get systemTheme => 'System';
  @override
  String get lightTheme => 'Light';
  @override
  String get darkTheme => 'Dark';
  @override
  String get premium => 'Premium';
  @override
  String get premiumDescription =>
      'Unlock song downloads for offline use. In this demo you can enable it freely.';
  @override
  String get premiumActive => 'Premium active';
  @override
  String get premiumInactive => 'Free version';
  @override
  String get enablePremiumDemo => 'Enable premium (demo)';
  @override
  String get premiumFeatureTitle => 'Premium feature';
  @override
  String get premiumFeatureBody =>
      'Downloading songs for offline use is part of the Premium version. You can enable it now in demo mode.';
  @override
  String get activateDemo => 'Enable demo';
  @override
  String get downloadAll => 'Download all songs';
  @override
  String get allDownloaded => 'All songs are available offline';
  @override
  String get offline => 'Offline content';
  @override
  String get offlineDescription =>
      'Downloaded songs stay available without a connection.';
  @override
  String get downloadedSongs => 'Downloaded songs';
  @override
  String get noDownloads => 'No downloaded songs.';
  @override
  String get download => 'Download';
  @override
  String get downloading => 'Downloading...';
  @override
  String get downloaded => 'Downloaded';
  @override
  String get removeDownload => 'Remove download';
  @override
  String get sync => 'Cloud sync';
  @override
  String get syncDescription =>
      'Store setlists and favourites across devices. Coming in a future release.';
  @override
  String get syncComingSoon => 'Coming soon';
  @override
  String get about => 'About';
  @override
  String get aboutDescription =>
      'Liturgical Songs helps communities prepare and live their celebrations. Demo content included in the prototype.';
  @override
  String get version => 'Version';
  @override
  String get resetData => 'Restore demo data';
  @override
  String get resetDataQuestion =>
      'Setlists, favourites and downloads will be removed. Continue?';
  @override
  String get reset => 'Restore';
  @override
  String get dataReset => 'Data restored';

  @override
  String get demoBadge => 'Public demo';
  @override
  String get localDataTitle => 'Your data stays in this browser';
  @override
  String get localDataBody =>
      'The demo has no accounts and no sync. Favourites, edits and setlists '
      'are stored only on this device: export them before changing browser '
      'or resetting the demo.';
  @override
  String get versionField => 'Version / music author';
  @override
  String get chordProHint =>
      'Inline chords above the syllable: [D]I lift up my eyes to the [Bm]hills. '
      'One verse per block, separated by a blank line; "R:" for the chorus.';
  @override
  String get printSong => 'Print';
  @override
  String get printHint =>
      'A4 sheet ready to print: title, author, source, chords and lyrics.';
  @override
  String get closePrint => 'Close';
  @override
  String get searchOnYoutube => 'Search on YouTube';
  @override
  String get locallyEdited => 'Locally edited';
  @override
  String get restoreOriginal => 'Restore original';
  @override
  String get backupTitle => 'Backup and restore';
  @override
  String get backupDescription =>
      'Export favourites, edits, created songs and setlists to a JSON file. '
      'Import it in another browser or after a reset.';
  @override
  String get exportData => 'Export data';
  @override
  String get importData => 'Import data';
  @override
  String get backupExported => 'Backup exported';
  @override
  String get backupImported => 'Backup imported';
  @override
  String get backupInvalid => 'This is not a valid backup file';
  @override
  String get copyData => 'Copy';
  @override
  String get pasteData => 'Paste the JSON';
  @override
  String get creditsTitle => 'Credits and licences';
  @override
  String get creditsBody =>
      'The app code is released under the MIT licence. Lyrics and chords come '
      'from the songbooks named on each song and are published under the '
      'licence declared by the demo curator. For takedown requests, open a '
      'GitHub Issue.';
  @override
  String get openCredits => 'Open credits';
  @override
  String get takedown => 'Report a copyright issue';
}

class AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const AppStringsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'it' || locale.languageCode == 'en';

  @override
  Future<AppStrings> load(Locale locale) async =>
      locale.languageCode == 'en' ? const AppStringsEn() : const AppStringsIt();

  @override
  bool shouldReload(AppStringsDelegate old) => false;
}
