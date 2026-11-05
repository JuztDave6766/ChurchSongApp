import 'package:flutter/widgets.dart';

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
