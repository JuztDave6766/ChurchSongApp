import 'models.dart';

/// Static catalogue of tags, celebrations and demo songs.
///
/// In a production build this data would come from a CMS or an import file;
/// the rest of the app only depends on these lookup maps, so the source can
/// be swapped without touching the UI.

const List<Tag> kTags = [
  // Celebrations.
  Tag(id: 'messa', kind: TagKind.celebration, it: 'Messa', en: 'Mass'),
  Tag(
    id: 'via-crucis',
    kind: TagKind.celebration,
    it: 'Via Crucis',
    en: 'Stations of the Cross',
  ),
  Tag(
    id: 'adorazione',
    kind: TagKind.celebration,
    it: 'Adorazione eucaristica',
    en: 'Eucharistic Adoration',
  ),
  Tag(
    id: 'preghiera',
    kind: TagKind.celebration,
    it: 'Preghiera',
    en: 'Prayer',
  ),

  // Moments - Mass.
  Tag(id: 'ingresso', kind: TagKind.moment, it: 'Ingresso', en: 'Entrance'),
  Tag(
    id: 'atto-penitenziale',
    kind: TagKind.moment,
    it: 'Atto penitenziale',
    en: 'Penitential act',
  ),
  Tag(id: 'gloria', kind: TagKind.moment, it: 'Gloria', en: 'Gloria'),
  Tag(
    id: 'salmo',
    kind: TagKind.moment,
    it: 'Liturgia della Parola',
    en: 'Liturgy of the Word',
  ),
  Tag(id: 'offertorio', kind: TagKind.moment, it: 'Offertorio', en: 'Offertory'),
  Tag(
    id: 'versetto-alleluia',
    kind: TagKind.moment,
    it: 'Versetto dell\'alleluia',
    en: 'Alleluia verse',
  ),
  Tag(id: 'santo', kind: TagKind.moment, it: 'Santo', en: 'Holy'),
  Tag(id: 'comunione', kind: TagKind.moment, it: 'Comunione', en: 'Communion'),
  Tag(
    id: 'ringraziamento',
    kind: TagKind.moment,
    it: 'Ringraziamento',
    en: 'Thanksgiving',
  ),
  Tag(id: 'congedo', kind: TagKind.moment, it: 'Congedo', en: 'Dismissal'),

  // Moments - Via Crucis.
  Tag(
    id: 'introduzione',
    kind: TagKind.moment,
    it: 'Introduzione',
    en: 'Introduction',
  ),
  Tag(id: 'stazione', kind: TagKind.moment, it: 'Stazione', en: 'Station'),
  Tag(id: 'conclusione', kind: TagKind.moment, it: 'Conclusione', en: 'Conclusion'),

  // Moments - Adoration.
  Tag(id: 'esposizione', kind: TagKind.moment, it: 'Esposizione', en: 'Exposition'),
  Tag(id: 'adorazione-momento', kind: TagKind.moment, it: 'Adorazione', en: 'Adoration'),
  Tag(id: 'silenzio', kind: TagKind.moment, it: 'Silenzio', en: 'Silence'),
  Tag(id: 'benedizione', kind: TagKind.moment, it: 'Benedizione', en: 'Blessing'),
  Tag(id: 'reposizione', kind: TagKind.moment, it: 'Reposizione', en: 'Reposition'),

  // Moments - Prayer.
  Tag(id: 'apertura', kind: TagKind.moment, it: 'Apertura', en: 'Opening'),
  Tag(id: 'ascolto', kind: TagKind.moment, it: 'Ascolto', en: 'Listening'),
  Tag(id: 'intercessione', kind: TagKind.moment, it: 'Intercessione', en: 'Intercession'),

  // Themes.
  Tag(id: 'gioia', kind: TagKind.theme, it: 'Gioia', en: 'Joy'),
  Tag(id: 'luce', kind: TagKind.theme, it: 'Luce', en: 'Light'),
  Tag(id: 'pace', kind: TagKind.theme, it: 'Pace', en: 'Peace'),
  Tag(id: 'speranza', kind: TagKind.theme, it: 'Speranza', en: 'Hope'),
  Tag(id: 'fiducia', kind: TagKind.theme, it: 'Fiducia', en: 'Trust'),
  Tag(
    id: 'spirito-santo',
    kind: TagKind.theme,
    it: 'Spirito Santo',
    en: 'Holy Spirit',
  ),
  Tag(id: 'mariano', kind: TagKind.theme, it: 'Mariano', en: 'Marian'),
  Tag(id: 'penitenza', kind: TagKind.theme, it: 'Penitenza', en: 'Repentance'),
  Tag(id: 'eucaristia', kind: TagKind.theme, it: 'Eucaristia', en: 'Eucharist'),
  Tag(id: 'croce', kind: TagKind.theme, it: 'Croce', en: 'Cross'),
  Tag(id: 'comunita', kind: TagKind.theme, it: 'Comunità', en: 'Community'),

  // Seasons and traditional repertoire.
  Tag(id: 'avvento', kind: TagKind.theme, it: 'Avvento', en: 'Advent'),
  Tag(id: 'natale', kind: TagKind.theme, it: 'Natale', en: 'Christmas'),
  Tag(id: 'quaresima', kind: TagKind.theme, it: 'Quaresima', en: 'Lent'),
  Tag(id: 'pasqua', kind: TagKind.theme, it: 'Pasqua', en: 'Easter'),
  Tag(id: 'pentecoste', kind: TagKind.theme, it: 'Pentecoste', en: 'Pentecost'),
  Tag(id: 'defunti', kind: TagKind.theme, it: 'Defunti', en: 'All Souls'),
  Tag(
    id: 'tradizionale',
    kind: TagKind.theme,
    it: 'Tradizionale',
    en: 'Traditional',
  ),

  // Styles.
  Tag(id: 'taize', kind: TagKind.style, it: 'Taizé', en: 'Taizé'),
  Tag(id: 'lourdes', kind: TagKind.style, it: 'Lourdes', en: 'Lourdes'),
  Tag(
    id: 'gregorian',
    kind: TagKind.style,
    it: 'Gregoriano e latino',
    en: 'Gregorian and Latin',
  ),
  Tag(
    id: 'contemporaneo',
    kind: TagKind.style,
    it: 'Contemporaneo',
    en: 'Contemporary',
  ),

  // Instruments.
  Tag(id: 'chitarra', kind: TagKind.instrument, it: 'Chitarra', en: 'Guitar'),
  Tag(id: 'organo', kind: TagKind.instrument, it: 'Organo', en: 'Organ'),
  Tag(
    id: 'pianoforte',
    kind: TagKind.instrument,
    it: 'Pianoforte',
    en: 'Piano',
  ),
  Tag(id: 'corale', kind: TagKind.instrument, it: 'Corale', en: 'Choir'),
];

final Map<String, Tag> kTagsById = {
  for (final tag in kTags) tag.id: tag,
};

/// Tags that describe *when* a song is sung, across all celebrations.
const Set<String> kMomentIds = {
  'ingresso',
  'atto-penitenziale',
  'gloria',
  'salmo',
  'offertorio',
  'versetto-alleluia',
  'santo',
  'comunione',
  'ringraziamento',
  'congedo',
  'introduzione',
  'stazione',
  'conclusione',
  'esposizione',
  'adorazione-momento',
  'silenzio',
  'benedizione',
  'reposizione',
  'apertura',
  'ascolto',
  'intercessione',
};

const List<LiturgicalFunction> kFunctions = [
  LiturgicalFunction(
    id: 'messa',
    it: 'Messa',
    en: 'Mass',
    descriptionIt:
        'Dall\'ingresso al congedo: i canti per ogni momento della celebrazione eucaristica.',
    descriptionEn:
        'From entrance to dismissal: songs for every moment of the Eucharist.',
    iconName: 'church',
    moments: [
      LiturgicalMoment(
        id: 'ingresso',
        it: 'Ingresso',
        en: 'Entrance',
        hintIt: 'Mentre l\'assemblea si raduna e il sacerdote entra.',
        hintEn: 'While the assembly gathers and the priest enters.',
      ),
      LiturgicalMoment(
        id: 'atto-penitenziale',
        it: 'Atto penitenziale',
        en: 'Penitential act',
        hintIt: 'Kyrie o canto che chiede perdono.',
        hintEn: 'Kyrie or a song asking for forgiveness.',
      ),
      LiturgicalMoment(
        id: 'gloria',
        it: 'Gloria',
        en: 'Gloria',
        hintIt: 'Nelle domeniche e nelle solennità.',
        hintEn: 'On Sundays and solemnities.',
        optional: true,
      ),
      LiturgicalMoment(
        id: 'salmo',
        it: 'Liturgia della Parola',
        en: 'Liturgy of the Word',
        hintIt: 'Salmo responsoriale o canto alla Parola.',
        hintEn: 'Responsorial psalm or song for the Word.',
      ),
      LiturgicalMoment(
        id: 'versetto-alleluia',
        it: 'Versetto dell\'alleluia',
        en: 'Alleluia verse',
        hintIt: 'Canto acclamativo prima del Vangelo.',
        hintEn: 'Acclamatory verse before the Gospel.',
        optional: true,
      ),
      LiturgicalMoment(
        id: 'offertorio',
        it: 'Offertorio',
        en: 'Offertory',
        hintIt: 'Presentazione dei doni e del pane e del vino.',
        hintEn: 'Presentation of the gifts, bread and wine.',
      ),
      LiturgicalMoment(
        id: 'santo',
        it: 'Santo',
        en: 'Holy',
        hintIt: 'Acclamazione al Santo.',
        hintEn: 'The Holy acclamation.',
      ),
      LiturgicalMoment(
        id: 'comunione',
        it: 'Comunione',
        en: 'Communion',
        hintIt: 'Canto durante la distribuzione della Comunione.',
        hintEn: 'Song during the distribution of Communion.',
      ),
      LiturgicalMoment(
        id: 'ringraziamento',
        it: 'Ringraziamento',
        en: 'Thanksgiving',
        hintIt: 'Dopo la comunione, prima del congedo.',
        hintEn: 'After Communion, before the dismissal.',
        optional: true,
      ),
      LiturgicalMoment(
        id: 'congedo',
        it: 'Congedo',
        en: 'Dismissal',
        hintIt: 'Canto finale al termine della celebrazione.',
        hintEn: 'Final song at the end of the celebration.',
      ),
    ],
  ),
  LiturgicalFunction(
    id: 'via-crucis',
    it: 'Via Crucis',
    en: 'Stations of the Cross',
    descriptionIt:
        'Quattordici stazioni per camminare con Cristo verso il Calvario.',
    descriptionEn:
        'Fourteen stations to walk with Christ towards Calvary.',
    iconName: 'route',
    moments: [
      LiturgicalMoment(
        id: 'introduzione',
        it: 'Introduzione',
        en: 'Introduction',
        hintIt: 'Canto di apertura e preghiera iniziale.',
        hintEn: 'Opening song and initial prayer.',
      ),
      LiturgicalMoment(
        id: 'stazione',
        it: 'Stazioni',
        en: 'Stations',
        hintIt: 'Canti da alternare alle quattordici stazioni.',
        hintEn: 'Songs to alternate with the fourteen stations.',
      ),
      LiturgicalMoment(
        id: 'conclusione',
        it: 'Conclusione',
        en: 'Conclusion',
        hintIt: 'Canto e preghiera finale.',
        hintEn: 'Final song and prayer.',
      ),
    ],
  ),
  LiturgicalFunction(
    id: 'adorazione',
    it: 'Adorazione',
    en: 'Adoration',
    descriptionIt:
        'Un tempo di silenzio e di incontro davanti al Santissimo Sacramento.',
    descriptionEn:
        'A time of silence and encounter before the Blessed Sacrament.',
    iconName: 'sun',
    moments: [
      LiturgicalMoment(
        id: 'esposizione',
        it: 'Esposizione',
        en: 'Exposition',
        hintIt: 'Canto mentre il Santissimo viene esposto.',
        hintEn: 'Song while the Blessed Sacrament is exposed.',
      ),
      LiturgicalMoment(
        id: 'adorazione-momento',
        it: 'Adorazione',
        en: 'Adoration',
        hintIt: 'Canti meditativi durante l\'adorazione.',
        hintEn: 'Meditative songs during adoration.',
      ),
      LiturgicalMoment(
        id: 'silenzio',
        it: 'Silenzio',
        en: 'Silence',
        hintIt: 'Canto breve che introduce il silenzio.',
        hintEn: 'A short song introducing silence.',
        optional: true,
      ),
      LiturgicalMoment(
        id: 'benedizione',
        it: 'Benedizione',
        en: 'Blessing',
        hintIt: 'Canto durante la benedizione eucaristica.',
        hintEn: 'Song during the Eucharistic blessing.',
      ),
      LiturgicalMoment(
        id: 'reposizione',
        it: 'Reposizione',
        en: 'Reposition',
        hintIt: 'Canto finale mentre il Santissimo viene riposto.',
        hintEn: 'Final song while the Sacrament is returned.',
        optional: true,
      ),
    ],
  ),
  LiturgicalFunction(
    id: 'preghiera',
    it: 'Preghiera',
    en: 'Prayer',
    descriptionIt:
        'Per un incontro di preghiera, un gruppo, un momento di ascolto e intercessione.',
    descriptionEn:
        'For a prayer meeting, a group, a time of listening and intercession.',
    iconName: 'hands',
    moments: [
      LiturgicalMoment(
        id: 'apertura',
        it: 'Apertura',
        en: 'Opening',
        hintIt: 'Canto per iniziare la preghiera insieme.',
        hintEn: 'Song to begin praying together.',
      ),
      LiturgicalMoment(
        id: 'ascolto',
        it: 'Ascolto',
        en: 'Listening',
        hintIt: 'Canto che accompagna la Parola e il silenzio.',
        hintEn: 'Song accompanying the Word and silence.',
      ),
      LiturgicalMoment(
        id: 'intercessione',
        it: 'Intercessione',
        en: 'Intercession',
        hintIt: 'Canto per le intenzioni e per il mondo.',
        hintEn: 'Song for intentions and for the world.',
      ),
      LiturgicalMoment(
        id: 'ringraziamento',
        it: 'Ringraziamento',
        en: 'Thanksgiving',
        hintIt: 'Canto di gratitudine.',
        hintEn: 'A song of gratitude.',
        optional: true,
      ),
      LiturgicalMoment(
        id: 'conclusione',
        it: 'Conclusione',
        en: 'Conclusion',
        hintIt: 'Canto mariano o finale.',
        hintEn: 'Marian or final song.',
      ),
    ],
  ),
];

final Map<String, LiturgicalFunction> kFunctionsById = {
  for (final function in kFunctions) function.id: function,
};

// ---------------------------------------------------------------------------
// Demo songs. Lyrics are original placeholder texts written for this
// prototype; the traditional prayers (Padre Nostro, Ave Maria, Magnificat,
// Salve Regina) are public domain.
// ---------------------------------------------------------------------------

const List<Song> kDemoSongs = [
  Song(
    id: 'cantiamo-al-signore',
    titles: {'it': 'Cantiamo al Signore'},
    author: 'Testo dimostrativo',
    keySignature: 'Re maggiore',
    duration: Duration(minutes: 3, seconds: 40),
    tagIds: ['messa', 'ingresso', 'gioia', 'comunita', 'versetto-alleluia',
             'chitarra'],
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'Cantiamo al Signore che viene,\n'
            'apriamo la porta del cuore;\n'
            'la sua luce cammina davanti a noi,\n'
            'la sua pace ci accompagna.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Ecco il giorno che il Signore ha fatto,\n'
            'esultiamo e rallegriamoci in lui.\n'
            'Ogni popolo lo lodi,\n'
            'ogni voce canti la sua bontà.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Come fratelli ci raduniamo,\n'
            'una sola famiglia nell\'amore;\n'
            'il suo Spirito ci guida,\n'
            'la sua parola ci sostiene.',
      ),
    ],
  ),
  Song(
    id: 'ecco-noi-veniamo',
    titles: {'it': 'Ecco, noi veniamo'},
    author: 'Testo dimostrativo',
    keySignature: 'Sol maggiore',
    duration: Duration(minutes: 3),
    tagIds: ['messa', 'ingresso', 'comunita'],
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'Ecco, noi veniamo a te, Signore,\n'
            'ascolta la voce del tuo popolo.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Le mani alzate, il cuore aperto,\n'
            'portiamo la gioia e la fatica.\n'
            'Camminiamo insieme verso la tua casa,\n'
            'sostenuti dalla tua promessa.',
      ),
    ],
  ),
  Song(
    id: 'signore-pieta',
    titles: {'it': 'Signore, pietà'},
    author: 'Testo dimostrativo',
    keySignature: 'Mi minore',
    duration: Duration(minutes: 2, seconds: 20),
    tagIds: ['messa', 'atto-penitenziale', 'penitenza'],
    sections: [
      SongSection(
        kind: SectionKind.response,
        text: 'Signore, pietà.\nCristo, pietà.\nSignore, pietà.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Ti abbiamo lasciato, Signore,\n'
            'ma tu ci attendi con pazienza.\n'
            'Guariscici dalla nostra superbia,\n'
            'donaci un cuore nuovo.',
      ),
    ],
  ),
  Song(
    id: 'gloria-a-dio',
    titles: {'it': 'Gloria a Dio nell\'alto'},
    author: 'Testo dimostrativo',
    keySignature: 'Do maggiore',
    duration: Duration(minutes: 4),
    tagIds: ['messa', 'gloria', 'gioia', 'chitarra', 'pianoforte'],
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'Gloria a Dio nell\'alto dei cieli,\n'
            'e pace in terra agli uomini di buona volontà.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Ti lodiamo, ti benediciamo,\n'
            'ti adoriamo, ti glorifichiamo.\n'
            'Signore Dio, re del cielo,\n'
            'Dio Padre onnipotente.',
      ),
    ],
  ),
  Song(
    id: 'salmo-pastore',
    titles: {'it': 'Il Signore è il mio pastore'},
    author: 'Testo dimostrativo',
    keySignature: 'Fa maggiore',
    duration: Duration(minutes: 3, seconds: 10),
    tagIds: ['messa', 'salmo', 'fiducia', 'speranza'],
    sections: [
      SongSection(
        kind: SectionKind.response,
        text: 'Il Signore è il mio pastore:\nnon manco di nulla.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Mi fa riposare in verdi pascoli,\n'
            'mi conduce a sorgenti tranquille.\n'
            'Anche se cammino in valle oscura,\n'
            'non temo alcun male, perché sei con me.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Davanti a me prepari la tua mensa,\n'
            'il tuo calice mi riempie di gioia.\n'
            'Bontà e misericordia mi seguono\n'
            'tutti i giorni della mia vita.',
      ),
    ],
  ),
  Song(
    id: 'tu-sei-la-luce',
    titles: {'it': 'Tu sei la luce'},
    author: 'Testo dimostrativo',
    keySignature: 'La minore',
    duration: Duration(minutes: 3, seconds: 30),
    tagIds: ['messa', 'offertorio', 'luce', 'eucaristia'],
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'Tu sei la luce che non si spegne,\n'
            'il pane che sazia ogni fame.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Portiamo il pane, portiamo il vino,\n'
            'frutto del lavoro e della tua grazia.\n'
            'Trasformali in segno d\'amore,\n'
            'in cibo di vita per tutti noi.',
      ),
    ],
  ),
  Song(
    id: 'offriamo-a-te',
    titles: {'it': 'Offriamo a te'},
    author: 'Testo dimostrativo',
    keySignature: 'Re maggiore',
    duration: Duration(minutes: 3),
    tagIds: ['messa', 'offertorio', 'comunita'],
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'Offriamo a te, Signore,\n'
            'la nostra vita e il nostro canto.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Nelle mani tue, come dono,\n'
            'mettiamo tutto ciò che siamo.\n'
            'Insegnaci a condividere,\n'
            'a dare senza contare.',
      ),
    ],
  ),
  Song(
    id: 'santo-santo',
    titles: {'it': 'Santo, Santo, Santo'},
    author: 'Testo dimostrativo',
    keySignature: 'Mi bemolle maggiore',
    duration: Duration(minutes: 2, seconds: 40),
    tagIds: ['messa', 'santo', 'eucaristia'],
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'Santo, Santo, Santo,\n'
            'Signore Dio dell\'universo.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'I cieli e la terra\n'
            'sono pieni della tua gloria.\n'
            'Osanna nell\'alto dei cieli,\n'
            'benedetto colui che viene.',
      ),
    ],
  ),
  Song(
    id: 'pane-di-vita',
    titles: {'it': 'Pane di vita'},
    author: 'Testo dimostrativo',
    keySignature: 'Sol maggiore',
    duration: Duration(minutes: 4),
    tagIds: ['messa', 'comunione', 'eucaristia'],
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'Pane di vita, presenza d\'amore,\n'
            'dono che unisce il cielo alla terra.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Chi mangia di questo pane\n'
            'vivrà per sempre in te.\n'
            'In ogni volto che incontriamo\n'
            'sei tu che ci vieni incontro.',
      ),
    ],
  ),
  Song(
    id: 'agnello-di-dio',
    titles: {'it': 'Agnello di Dio'},
    author: 'Testo dimostrativo',
    keySignature: 'Do maggiore',
    duration: Duration(minutes: 1, seconds: 40),
    tagIds: ['messa', 'comunione', 'eucaristia'],
    sections: [
      SongSection(
        kind: SectionKind.response,
        text: 'Agnello di Dio, che togli i peccati del mondo,\n'
            'abbi pietà di noi.',
      ),
      SongSection(
        kind: SectionKind.response,
        text: 'Agnello di Dio, che togli i peccati del mondo,\n'
            'donaci la pace.',
      ),
    ],
  ),
  Song(
    id: 'restiamo-con-te',
    titles: {'it': 'Restiamo con te'},
    author: 'Testo dimostrativo',
    keySignature: 'La minore',
    duration: Duration(minutes: 3, seconds: 50),
    tagIds: [
      'messa',
      'comunione',
      'adorazione',
      'adorazione-momento',
      'eucaristia',
    ],
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'Restiamo con te, Signore,\n'
            'quando la sera scende sul cuore.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Il tuo silenzio ci parla\n'
            'più di mille parole.\n'
            'Riscaldaci con la tua presenza,\n'
            'apri i nostri occhi.',
      ),
    ],
  ),
  Song(
    id: 'ti-ringraziamo',
    titles: {'it': 'Ti ringraziamo, Signore'},
    author: 'Testo dimostrativo',
    keySignature: 'Re maggiore',
    duration: Duration(minutes: 3, seconds: 20),
    tagIds: ['messa', 'ringraziamento', 'preghiera', 'gioia'],
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'Ti ringraziamo, Signore,\n'
            'per ogni dono che riceviamo.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Per la vita, per gli amici,\n'
            'per il pane condiviso.\n'
            'Rendici testimoni di gioia,\n'
            'costruttori di pace.',
      ),
    ],
  ),
  Song(
    id: 'andate-in-pace',
    titles: {'it': 'Andate in pace'},
    author: 'Testo dimostrativo',
    keySignature: 'Sol maggiore',
    duration: Duration(minutes: 2, seconds: 50),
    tagIds: ['messa', 'congedo', 'pace'],
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'Andate in pace, portate l\'amore;\n'
            'il Signore cammina con voi.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Con il cuore colmo di gioia,\n'
            'torniamo alle nostre case.\n'
            'La sua benedizione ci accompagni\n'
            'ogni giorno del nostro cammino.',
      ),
    ],
  ),
  Song(
    id: 'vieni-spirito-santo',
    titles: {'it': 'Vieni, Spirito Santo'},
    author: 'Testo dimostrativo',
    keySignature: 'Mi minore',
    duration: Duration(minutes: 3, seconds: 40),
    tagIds: ['preghiera', 'apertura', 'adorazione', 'spirito-santo'],
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'Vieni, Spirito Santo,\n'
            'accendi il fuoco nel nostro cuore.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Dono di luce e di consiglio,\n'
            'forza dei piccoli e dei poveri.\n'
            'Insegnaci a pregare,\n'
            'a riconoscerti nei fratelli.',
      ),
    ],
  ),
  Song(
    id: 'padre-nostro',
    titles: {'it': 'Padre nostro'},
    author: 'Tradizionale',
    keySignature: 'Fa maggiore',
    duration: Duration(minutes: 2, seconds: 30),
    tagIds: ['preghiera', 'apertura', 'ascolto'],
    sections: [
      SongSection(
        kind: SectionKind.verse,
        text: 'Padre nostro che sei nei cieli,\n'
            'sia santificato il tuo nome,\n'
            'venga il tuo regno,\n'
            'sia fatta la tua volontà\n'
            'come in cielo così in terra.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Dacci oggi il nostro pane quotidiano,\n'
            'e rimetti a noi i nostri debiti\n'
            'come noi li rimettiamo ai nostri debitori,\n'
            'e non ci indurre in tentazione,\n'
            'ma liberaci dal male.',
      ),
    ],
  ),
  Song(
    id: 'ave-maria',
    titles: {'it': 'Ave Maria'},
    author: 'Tradizionale',
    keySignature: 'Do maggiore',
    duration: Duration(minutes: 2, seconds: 10),
    tagIds: ['preghiera', 'mariano', 'ascolto'],
    sections: [
      SongSection(
        kind: SectionKind.verse,
        text: 'Ave, Maria, piena di grazia,\n'
            'il Signore è con te.\n'
            'Tu sei benedetta fra le donne\n'
            'e benedetto è il frutto del tuo seno, Gesù.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Santa Maria, Madre di Dio,\n'
            'prega per noi peccatori,\n'
            'adesso e nell\'ora della nostra morte.\n'
            'Amen.',
      ),
    ],
  ),
  Song(
    id: 'salve-regina',
    titles: {'it': 'Salve, Regina'},
    author: 'Tradizionale',
    keySignature: 'La minore',
    duration: Duration(minutes: 2),
    tagIds: [
      'preghiera',
      'conclusione',
      'mariano',
      'reposizione',
    ],
    sections: [
      SongSection(
        kind: SectionKind.verse,
        text: 'Salve, Regina, madre di misericordia,\n'
            'vita, dolcezza e speranza nostra, salve.\n'
            'A te ricorriamo, esuli figli di Eva;\n'
            'a te sospiriamo, gementi e piangenti\n'
            'in questa valle di lacrime.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Orsù dunque, avvocata nostra,\n'
            'rivolgi a noi gli occhi tuoi misericordiosi.\n'
            'E mostraci, dopo questo esilio, Gesù,\n'
            'il frutto benedetto del tuo seno.\n'
            'O clemente, o pia, o dolce Vergine Maria.',
      ),
    ],
  ),
  Song(
    id: 'o-croce-fedele',
    titles: {'it': 'O Croce fedele'},
    author: 'Testo dimostrativo',
    keySignature: 'Mi minore',
    duration: Duration(minutes: 3, seconds: 30),
    tagIds: ['via-crucis', 'introduzione', 'conclusione', 'croce'],
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'O Croce fedele, albero di vita,\n'
            'ci hai mostrato l\'amore più grande.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Ti contempliamo, Signore,\n'
            'mentre sali verso il Golgota.\n'
            'Insegnaci a portare con te\n'
            'il peso di ogni giorno.',
      ),
    ],
  ),
  Song(
    id: 'via-crucis-stazione-1',
    titles: {'it': 'Stazione I - Gesù condannato'},
    author: 'Testo dimostrativo',
    keySignature: 'Re minore',
    duration: Duration(minutes: 3),
    tagIds: ['via-crucis', 'stazione', 'croce', 'penitenza'],
    sections: [
      SongSection(
        kind: SectionKind.response,
        text: 'Adoriamo te, Cristo, e ti benediciamo,\n'
            'perché con la tua Santa Croce\n'
            'hai redento il mondo.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Pilato lo consegna alla croce;\n'
            'egli accoglie il peso per noi.\n'
            'Insegnaci a portare il nostro,\n'
            'senza fuggire.',
      ),
    ],
  ),
  Song(
    id: 'via-crucis-stazione-8',
    titles: {'it': 'Stazione VIII - Le donne di Gerusalemme'},
    author: 'Testo dimostrativo',
    keySignature: 'Sol minore',
    duration: Duration(minutes: 3, seconds: 10),
    tagIds: ['via-crucis', 'stazione', 'croce'],
    sections: [
      SongSection(
        kind: SectionKind.response,
        text: 'Adoriamo te, Cristo, e ti benediciamo,\n'
            'perché con la tua Santa Croce\n'
            'hai redento il mondo.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Le donne di Gerusalemme piangono;\n'
            'tu le inviti a guardare oltre.\n'
            'Dona lacrime che sanno cambiare\n'
            'il nostro cuore.',
      ),
    ],
  ),
  Song(
    id: 'via-crucis-stazione-14',
    titles: {'it': 'Stazione XIV - Gesù deposto nel sepolcro'},
    author: 'Testo dimostrativo',
    keySignature: 'Do minore',
    duration: Duration(minutes: 3, seconds: 40),
    tagIds: ['via-crucis', 'stazione', 'croce', 'speranza'],
    sections: [
      SongSection(
        kind: SectionKind.response,
        text: 'Adoriamo te, Cristo, e ti benediciamo,\n'
            'perché con la tua Santa Croce\n'
            'hai redento il mondo.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Deposto dalla croce,\n'
            'affidato alle braccia della madre.\n'
            'Nel silenzio del sabato,\n'
            'la speranza attende la luce.',
      ),
    ],
  ),
  Song(
    id: 'adoriamo-te-signore',
    titles: {'it': 'Adoriamo te, Signore'},
    author: 'Testo dimostrativo',
    keySignature: 'Mi bemolle maggiore',
    duration: Duration(minutes: 3, seconds: 20),
    tagIds: ['adorazione', 'esposizione', 'eucaristia'],
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'Adoriamo te, Signore,\n'
            'pane vivo disceso dal cielo.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Davanti a te ci inginocchiamo,\n'
            'cuore aperto e mani vuote.\n'
            'Nel silenzio della tua presenza\n'
            'troviamo la pace.',
      ),
    ],
  ),
  Song(
    id: 'nel-silenzio',
    titles: {'it': 'Nel silenzio'},
    author: 'Testo dimostrativo',
    keySignature: 'La minore',
    duration: Duration(minutes: 3),
    tagIds: ['adorazione', 'adorazione-momento', 'silenzio', 'ascolto'],
    sections: [
      SongSection(
        kind: SectionKind.verse,
        text: 'Nel silenzio ascoltiamo la tua voce,\n'
            'più dolce del vento leggero.\n'
            'Nel silenzio ci parli al cuore,\n'
            'e la paura svanisce.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Resta con noi, Signore,\n'
            'quando le parole finiscono.\n'
            'Il tuo amore ci basta,\n'
            'la tua presenza ci sostiene.',
      ),
    ],
  ),
  Song(
    id: 'ti-benediciamo',
    titles: {'it': 'Ti benediciamo'},
    author: 'Testo dimostrativo',
    keySignature: 'Sol maggiore',
    duration: Duration(minutes: 3, seconds: 30),
    tagIds: ['adorazione', 'benedizione', 'eucaristia'],
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'Ti benediciamo, Signore,\n'
            'fonte di ogni santità.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'In questo pane e in questo vino\n'
            'ci doni la tua presenza.\n'
            'Fa\' di noi un solo corpo,\n'
            'un popolo di fratelli.',
      ),
    ],
  ),
  Song(
    id: 'magnificat',
    titles: {'it': 'Magnificat'},
    author: 'Tradizionale',
    keySignature: 'Fa maggiore',
    duration: Duration(minutes: 3, seconds: 50),
    tagIds: ['preghiera', 'gioia', 'mariano', 'ringraziamento'],
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'L\'anima mia magnifica il Signore\n'
            'e il mio spirito esulta in Dio, mio salvatore.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Ha guardato l\'umiltà della sua serva:\n'
            'd\'ora in poi tutte le generazioni mi chiameranno beata.\n'
            'Grandi cose ha fatto in me l\'Onnipotente\n'
            'e Santo è il suo nome.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Ha rovesciato i potenti dai troni,\n'
            'ha innalzato gli umili.\n'
            'Ha ricolmato di beni gli affamati,\n'
            'ha rimandato i ricchi a mani vuote.',
      ),
    ],
  ),
  Song(
    id: 'nulla-ci-separi',
    titles: {'it': 'Nulla ci separi'},
    author: 'Testo dimostrativo',
    keySignature: 'Si minore',
    duration: Duration(minutes: 3, seconds: 40),
    tagIds: ['preghiera', 'ascolto', 'speranza'],
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'Nulla ci separi dal tuo amore,\n'
            'né la prova né il dolore.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'La tua parola è lampada ai nostri passi,\n'
            'luce sul nostro cammino.\n'
            'Quando il dubbio ci assale,\n'
            'tu ci tieni per mano.',
      ),
    ],
  ),
  Song(
    id: 'per-tutti-i-popoli',
    titles: {'it': 'Per tutti i popoli'},
    author: 'Testo dimostrativo',
    keySignature: 'Do maggiore',
    duration: Duration(minutes: 3, seconds: 20),
    tagIds: ['preghiera', 'intercessione', 'pace', 'organo'],
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'Per tutti i popoli, Signore,\n'
            'dona la pace e la giustizia.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Per chi soffre e chi è solo,\n'
            'per chi cerca una casa e un pane.\n'
            'Per chi governa e chi serve,\n'
            'perché regni la fraternità.',
      ),
    ],
  ),
  Song(
    id: 'grazie-signore',
    titles: {'it': 'Grazie, Signore'},
    author: 'Testo dimostrativo',
    keySignature: 'Re maggiore',
    duration: Duration(minutes: 2, seconds: 50),
    tagIds: ['preghiera', 'ringraziamento', 'comunita', 'gioia'],
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'Grazie, Signore, per il tuo amore,\n'
            'grazie per ogni giorno insieme.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Per le mani che si stringono,\n'
            'per le voci che cantano,\n'
            'per il coraggio di chi spera,\n'
            'grazie, Signore.',
      ),
    ],
  ),
];

// ---------------------------------------------------------------------------
// Themed repertoire.
//
// Copyright policy:
//  * [SongLicense.publicDomain] songs carry the full text (traditional prayers
//    and Latin chants).
//  * [SongLicense.copyrighted] songs are metadata only: title, metadata, one
//    or two pointers (YouTube / sheet music). The user adds their own copy
//    (canzoniere, PDF autorizzato). No lyrics are bundled and no theme is
//    implied by a lyric excerpt.
// ---------------------------------------------------------------------------

const List<Song> kThemedSongs = [
  // Taizé — Jacques Berthier, © Ateliers et Presses de Taizé. Metadata only.
  Song(
    id: 'taize-ubi-caritas',
    titles: {'it': 'Ubi caritas et amor'},
    author: 'Jacques Berthier · © Ateliers et Presses de Taizé',
    keySignature: 'Mi minore',
    duration: Duration(minutes: 3),
    tagIds: [
      'messa', 'comunione', 'pace', 'preghiera', 'taize', 'corale',
      'chitarra', 'organo',
    ],
    youtubeId: 'z9zvDBPkgOk',
    sheetUrl: 'https://www.taize.fr/en/learning-the-songs',
    license: SongLicense.copyrighted,
    sourceNote:
        'Canzone di Taizé, protetta da copyright (testo e musica). Inserisci '
        'il testo dal tuo canzoniere autorizzato; lo spartito è scaricabile '
        'dal sito di Taizé.',
  ),
  Song(
    id: 'taize-veni-sancte-spiritus',
    titles: {'it': 'Veni Sancte Spiritus'},
    author: 'Jacques Berthier · © Ateliers et Presses de Taizé',
    keySignature: 'Fa minore',
    duration: Duration(minutes: 3),
    tagIds: [
      'preghiera', 'intercessione', 'spirito-santo', 'taize', 'corale',
      'chitarra', 'organo',
    ],
    youtubeId: 'Z1fR4SV55qg',
    sheetUrl: 'https://www.taize.fr/en/learning-the-songs',
    license: SongLicense.copyrighted,
    sourceNote: 'Testo protetto: inseriscilo dal tuo canzoniere autorizzato.',
  ),
  Song(
    id: 'taize-laudate-dominum',
    titles: {'it': 'Laudate Dominum'},
    author: 'Jacques Berthier · © Ateliers et Presses de Taizé',
    keySignature: 'Sol maggiore',
    duration: Duration(minutes: 2, seconds: 30),
    tagIds: [
      'messa', 'ingresso', 'apertura', 'gioia', 'preghiera', 'taize',
      'corale', 'chitarra',
    ],
    sheetUrl: 'https://www.taize.fr/en/learning-the-songs',
    license: SongLicense.copyrighted,
    sourceNote: 'Testo protetto: inseriscilo dal tuo canzoniere autorizzato.',
  ),
  Song(
    id: 'taize-laudate-omnes-gentes',
    titles: {'it': 'Laudate omnes gentes'},
    author: 'Jacques Berthier · © Ateliers et Presses de Taizé',
    keySignature: 'Do maggiore',
    duration: Duration(minutes: 2, seconds: 30),
    tagIds: [
      'messa', 'apertura', 'comunita', 'gioia', 'preghiera', 'taize',
      'corale', 'chitarra',
    ],
    sheetUrl: 'https://www.taize.fr/en/learning-the-songs',
    license: SongLicense.copyrighted,
    sourceNote: 'Testo protetto: inseriscilo dal tuo canzoniere autorizzato.',
  ),
  Song(
    id: 'taize-wait-for-the-lord',
    titles: {'it': 'Wait for the Lord • Restate qui'},
    author: 'Jacques Berthier · © Ateliers et Presses de Taizé',
    keySignature: 'Si bemolle maggiore',
    duration: Duration(minutes: 3),
    tagIds: [
      'adorazione', 'silenzio', 'ascolto', 'speranza', 'preghiera', 'taize',
      'corale',
    ],
    sheetUrl: 'https://www.taize.fr/en/learning-the-songs',
    license: SongLicense.copyrighted,
    sourceNote: 'Testo protetto: inseriscilo dal tuo canzoniere autorizzato.',
  ),
  Song(
    id: 'taize-restate-qui',
    titles: {'it': 'Restate qui • Stay with me'},
    author: 'Jacques Berthier · © Ateliers et Presses de Taizé',
    keySignature: 'Mi minore',
    duration: Duration(minutes: 3),
    tagIds: [
      'adorazione', 'adorazione-momento', 'fiducia', 'messa', 'preghiera',
      'taize', 'corale',
    ],
    sheetUrl: 'https://www.taize.fr/en/learning-the-songs',
    license: SongLicense.copyrighted,
    sourceNote: 'Testo protetto: inseriscilo dal tuo canzoniere autorizzato.',
  ),
  Song(
    id: 'taize-nada-te-turbe',
    titles: {'it': 'Nada te turbe'},
    author: 'Jacques Berthier · © Ateliers et Presses de Taizé',
    keySignature: 'La minore',
    duration: Duration(minutes: 3),
    tagIds: ['preghiera', 'ascolto', 'fiducia', 'pace', 'taize', 'corale'],
    sheetUrl: 'https://www.taize.fr/en/learning-the-songs',
    license: SongLicense.copyrighted,
    sourceNote:
        '© Ateliers et Presses de Taizé — metadati only.',
  ),

  // Lourdes — canti tradizionali (testi di pubblico dominio).
  Song(
    id: 'lourdes-ave-maria',
    titles: {'it': 'Ave Maria di Lourdes'},
    author: 'Tradizionale (Lourdes)',
    keySignature: 'Fa maggiore',
    duration: Duration(minutes: 2, seconds: 30),
    tagIds: ['preghiera', 'ascolto', 'mariano', 'lourdes', 'corale', 'organo'],
    license: SongLicense.publicDomain,
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'Ave, ave, ave Maria,\n'
            'Ave, ave, ave Maria!',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Nella grotta di Massabielle\n'
            'Bernadette ti vide, Maria:\n'
            'fonte di grazia e di vita,\n'
            'preghiamo sempre insieme a te.',
      ),
    ],
  ),
  Song(
    id: 'lourdes-immacolata-maria',
    titles: {'it': 'Immacolata Maria • Immaculate Mary'},
    author: 'Tradizionale (Lourdes)',
    keySignature: 'Sol maggiore',
    duration: Duration(minutes: 3),
    tagIds: ['preghiera', 'mariano', 'spirito-santo', 'lourdes', 'corale'],
    license: SongLicense.publicDomain,
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'Ave, o Immacolata Maria,\n'
            'il nostro canto sale a te.\n'
            'Dal profondo del cuore,\n'
            'preghiamo sempre per te.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Vergine umile e piena di grazia,\n'
            'ascolta il canto di chi prende il cuore:\n'
            'dove manca l\'amore, guidaci\n'
            'fino alla fonte della vita.',
      ),
    ],
  ),
  Song(
    id: 'lourdes-madonna-di-lourdes',
    titles: {'it': 'La Madonna di Lourdes'},
    author: 'Tradizionale (Lourdes)',
    keySignature: 'Do maggiore',
    duration: Duration(minutes: 3),
    tagIds: ['preghiera', 'mariano', 'conclusione', 'lourdes', 'corale'],
    license: SongLicense.publicDomain,
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'Sia lodata Maria,\n'
            'dolce madre di Lourdes,\n'
            'che ai camminatori dona\n'
            'la speranza e la fede.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Alza lo sguardo alla grotta,\n'
            'Bernadette ti accompagna:\n'
            'fonte di vita e di preghiera,\n'
            'Maria cammina accanto a noi.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Dove l\'acqua sgorga puro,\n'
            'dove il cuore ritrova la luce,\n'
            'chi prega con te, Maria,\n'
            'non cammina fuori strada.',
      ),
    ],
  ),

  // Gregoriano e repertorio latino — testi di pubblico dominio.
  Song(
    id: 'panis-angelicus',
    titles: {'it': 'Panis angelicus'},
    author: 'Testo: Tommaso d\'Aquino · Musica: César Franck',
    keySignature: 'Re maggiore',
    duration: Duration(minutes: 3, seconds: 30),
    tagIds: [
      'messa', 'comunione', 'eucaristia', 'gregorian', 'corale', 'organo',
      'pianoforte',
    ],
    license: SongLicense.publicDomain,
    sections: [
      SongSection(
        kind: SectionKind.verse,
        text: 'Panis angelicus\n'
            'fit panis hominum;\n'
            'dat panis caelicus\n'
            'figuris terminum:\n'
            'O res mirabilis!\n'
            'Manducat Dominum\n'
            'pauper, pauper servus et humilis.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Te, trina Deitas\n'
            'unaque, poscimus:\n'
            'sic nos tu visita,\n'
            'sicut te colimus;\n'
            'per tuas semitas\n'
            'duc nos quo tendimus,\n'
            'ad lucem quam incolimus.',
      ),
    ],
  ),
  Song(
    id: 'adoro-te-devote',
    titles: {'it': 'Adoro te devote'},
    author: 'Testo: Tommaso d\'Aquino',
    keySignature: 'La minore',
    duration: Duration(minutes: 3),
    tagIds: ['adorazione', 'benedizione', 'eucaristia', 'gregorian', 'organo'],
    license: SongLicense.publicDomain,
    sections: [
      SongSection(
        kind: SectionKind.verse,
        text: 'Adoro te devote, latens Deitas,\n'
            'quae sub his figuris vere latitas:\n'
            'tibi se cor meum totum subiicit,\n'
            'quia te contemplans totum deficit.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Visus, tactus, gustus in te fallitur,\n'
            'sed auditus solo tuto creditur:\n'
            'credo quidquid dixit Dei Filius,\n'
            'nihil veritati verbo verius.',
      ),
    ],
  ),
  Song(
    id: 'tantum-ergo',
    titles: {'it': 'Tantum ergo Sacramentum'},
    author: 'Testo: Tommaso d\'Aquino',
    keySignature: 'Mi bemolle maggiore',
    duration: Duration(minutes: 2, seconds: 30),
    tagIds: [
      'adorazione', 'benedizione', 'reposizione', 'eucaristia', 'gregorian',
      'corale', 'organo',
    ],
    license: SongLicense.publicDomain,
    sections: [
      SongSection(
        kind: SectionKind.verse,
        text: 'Tantum ergo Sacramentum\n'
            'veneremur cernui:\n'
            'et antiquum documentum\n'
            'novo cedat ritui:\n'
            'praestet fides supplementum\n'
            'sensuum defectui.',
      ),
      SongSection(
        kind: SectionKind.chorus,
        text: 'Genitori, Genitoque\n'
            'laus et jubilatio,\n'
            'salus, honor, virtus quoque\n'
            'sit et benedictio:\n'
            'procedenti ab utroque\n'
            'compar sit laudatio. Amen.',
      ),
    ],
  ),
  Song(
    id: 'veni-creator',
    titles: {'it': 'Veni, Creator Spiritus'},
    author: 'Tradizionale latino',
    keySignature: 'Re minore',
    duration: Duration(minutes: 3),
    tagIds: [
      'preghiera', 'apertura', 'spirito-santo', 'gregorian', 'corale',
      'organo',
    ],
    license: SongLicense.publicDomain,
    sections: [
      SongSection(
        kind: SectionKind.verse,
        text: 'Veni, Creator Spiritus,\n'
            'mentes tuorum visita,\n'
            'imple superna gratia,\n'
            'quae tu creasti pectora.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Qui diceris Paraclitus,\n'
            'altissimi donum Dei,\n'
            'fons vivus, ignis, caritas,\n'
            'et spiritalis unctio.',
      ),
    ],
  ),
  Song(
    id: 'attende-domine',
    titles: {'it': 'Attende, Domine'},
    author: 'Tradizionale latino (quaresma)',
    keySignature: 'Mi minore',
    duration: Duration(minutes: 3),
    tagIds: [
      'messa', 'atto-penitenziale', 'penitenza', 'gregorian', 'corale',
      'organo',
    ],
    license: SongLicense.publicDomain,
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'Attende, Domine, et miserere,\n'
            'quia peccavimus tibi.',
      ),
    ],
  ),
  Song(
    id: 'santo-xviii',
    titles: {'it': 'Sanctus XVIII • Santo'},
    author: 'Canto gregoriano (Kyriale)',
    keySignature: 'Do minore',
    duration: Duration(minutes: 2),
    tagIds: ['messa', 'santo', 'eucaristia', 'gregorian', 'corale', 'organo'],
    license: SongLicense.publicDomain,
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'Sanctus, Sanctus, Sanctus\n'
            'Dominus Deus Sabaoth.\n'
            'Pleni sunt caeli et terra gloria tua.\n'
            'Osanna in excelsis.',
      ),
      SongSection(
        kind: SectionKind.verse,
        text: 'Benedictus qui venit\n'
            'in nomine Domini.\n'
            'Osanna in excelsis.',
      ),
    ],
  ),
  Song(
    id: 'adeste-fideles',
    titles: {'it': 'Adeste fideles (Venite fedeli)'},
    author: 'Tradizionale',
    keySignature: 'Sol maggiore',
    duration: Duration(minutes: 3, seconds: 30),
    tagIds: [
      'messa', 'ingresso', 'conclusione', 'gioia', 'gregorian', 'corale',
      'organo',
    ],
    license: SongLicense.publicDomain,
    sections: [
      SongSection(
        kind: SectionKind.chorus,
        text: 'Adeste fideles, laeti, triumphantes,\n'
            'venite, venite in Bethlehem.\n'
            'Natum videte Regem Angelorum.\n'
            'Venite adoremus, venite adoremus,\n'
            'venite adoremus Dominum.',
      ),
    ],
  ),
  Song(
    id: 'alleluia-gregoriano',
    titles: {'it': 'Alleluia (versetto celebrativo)'},
    author: 'Canto gregoriano',
    keySignature: 'Re minore',
    duration: Duration(minutes: 1, seconds: 30),
    tagIds: [
      'messa', 'versetto-alleluia', 'gioia', 'gregorian', 'corale', 'organo',
    ],
    license: SongLicense.publicDomain,
    sections: [
      SongSection(
        kind: SectionKind.response,
        text: 'Alleluia, alleluia, alleluia.',
      ),
    ],
  ),

  // Contemporaneo con chitarra — Gen Rosso / Gen Verde
  // (© repertorio dei Focolari, protetto). Metadata only.
  Song(
    id: 'moderno-segni-del-tuo-amore',
    titles: {'it': 'Segni del tuo amore'},
    author: 'Gen Rosso / Gen Verde · © Ed. Focolare',
    keySignature: 'Sol maggiore',
    duration: Duration(minutes: 4),
    tagIds: [
      'messa', 'offertorio', 'comunita', 'preghiera', 'contemporaneo',
      'chitarra',
    ],
    sheetUrl: 'https://www.genverde.it/en/music/songs/liturgical/',
    license: SongLicense.copyrighted,
    sourceNote:
        'Repertorio Gen Rosso / Gen Verde, protetto da copyright. Inserisci il '
        'testo dal canzoniere autorizzato.',
  ),
  Song(
    id: 'moderno-dove-tu-sei',
    titles: {'it': 'Dove tu sei'},
    author: 'Gen Rosso · © Ed. Focolare',
    keySignature: 'Mi maggiore',
    duration: Duration(minutes: 4),
    tagIds: [
      'preghiera', 'ascolto', 'fiducia', 'contemporaneo', 'chitarra',
      'pianoforte',
    ],
    youtubeId: 'MxObjsQpoG4',
    license: SongLicense.copyrighted,
    sourceNote: 'Testo protetto: inseriscilo dal tuo canzoniere autorizzato.',
  ),
  Song(
    id: 'moderno-insieme-e-piu-bello',
    titles: {'it': 'Insieme è più bello'},
    author: 'Gen Verde / Gen Rosso · © Ed. Focolare',
    keySignature: 'Re maggiore',
    duration: Duration(minutes: 4),
    tagIds: [
      'messa', 'ingresso', 'comunita', 'gioia', 'preghiera', 'contemporaneo',
      'chitarra',
    ],
    license: SongLicense.copyrighted,
    sourceNote: 'Testo protetto: inseriscilo dal tuo canzoniere autorizzato.',
  ),
  Song(
    id: 'moderno-pace-sia-pace-a-voi',
    titles: {'it': 'Pace sia, pace a voi'},
    author: 'Gen Rosso e Gen Verde · © Ed. Focolare',
    keySignature: 'Do maggiore',
    duration: Duration(minutes: 3, seconds: 30),
    tagIds: [
      'messa', 'congedo', 'pace', 'preghiera', 'contemporaneo', 'chitarra',
    ],
    license: SongLicense.copyrighted,
    sourceNote: 'Testo protetto: inseriscilo dal tuo canzoniere autorizzato.',
  ),
];

/// Full catalogue: demo songs + themed/repertoire songs.
final List<Song> kSongs = [...kDemoSongs, ...kThemedSongs];

final Map<String, Song> kSongsById = {
  for (final song in kSongs) song.id: song,
};

/// Ready-made themed setlists ("messe già pronte").
const List<SetlistTemplate> kSetlistTemplates = [
  SetlistTemplate(
    id: 'tpl-preghiera-taize',
    titles: {
      'it': 'Preghiera di Taizé',
      'en': 'Taizé Prayer',
    },
    descriptions: {
      'it': 'Canti ripetuti di Taizé per un tempo di preghiera contemplativa.',
      'en': 'Repeated Taizé chants for a time of contemplative prayer.',
    },
    functionId: 'preghiera',
    entries: [
      TemplateEntry(momentId: 'apertura', songId: 'taize-laudate-dominum'),
      TemplateEntry(momentId: 'apertura', songId: 'taize-laudate-omnes-gentes'),
      TemplateEntry(momentId: 'ascolto', songId: 'taize-wait-for-the-lord'),
      TemplateEntry(momentId: 'ascolto', songId: 'taize-restate-qui'),
      TemplateEntry(momentId: 'intercessione', songId: 'taize-veni-sancte-spiritus'),
      TemplateEntry(momentId: 'intercessione', songId: 'taize-nada-te-turbe'),
      TemplateEntry(momentId: 'conclusione', songId: 'taize-ubi-caritas'),
    ],
  ),
  SetlistTemplate(
    id: 'tpl-preghiera-lourdes',
    titles: {
      'it': 'Preghiera mariana di Lourdes',
      'en': 'Lourdes Marian Prayer',
    },
    descriptions: {
      'it': 'Canti tradizionali di Lourdes per una devozione alla Madonna.',
      'en': 'Traditional Lourdes hymns for a Marian devotion.',
    },
    functionId: 'preghiera',
    entries: [
      TemplateEntry(momentId: 'apertura', songId: 'lourdes-ave-maria'),
      TemplateEntry(momentId: 'ascolto', songId: 'lourdes-immacolata-maria'),
      TemplateEntry(momentId: 'ascolto', songId: 'ave-maria'),
      TemplateEntry(momentId: 'intercessione', songId: 'lourdes-madonna-di-lourdes'),
      TemplateEntry(momentId: 'conclusione', songId: 'salve-regina'),
    ],
  ),
  SetlistTemplate(
    id: 'tpl-messa-gregoriana',
    titles: {
      'it': 'Messa in canto gregoriano',
      'en': 'Gregorian Chant Mass',
    },
    descriptions: {
      'it': 'Parti fisse in latino: canto gregoriano e repertorio classico.',
      'en': 'Fixed parts in Latin: Gregorian chant and classical repertoire.',
    },
    functionId: 'messa',
    entries: [
      TemplateEntry(momentId: 'ingresso', songId: 'adeste-fideles'),
      TemplateEntry(momentId: 'atto-penitenziale', songId: 'attende-domine'),
      TemplateEntry(momentId: 'santo', songId: 'santo-xviii'),
      TemplateEntry(momentId: 'comunione', songId: 'panis-angelicus'),
    ],
  ),
  SetlistTemplate(
    id: 'tpl-messa-scaletta-taize',
    titles: {
      'it': 'Messa di Taizé',
      'en': 'Taizé Mass',
    },
    descriptions: {
      'it': 'La Messa con i canti ripetuti di Taizé nei momenti fissi.',
      'en': 'Mass with Taizé repetitive chants in the fixed parts.',
    },
    functionId: 'messa',
    entries: [
      TemplateEntry(momentId: 'ingresso', songId: 'taize-laudate-dominum'),
      TemplateEntry(momentId: 'atto-penitenziale', songId: 'taize-restate-qui'),
      TemplateEntry(
        momentId: 'versetto-alleluia',
        songId: 'taize-laudate-omnes-gentes',
      ),
      TemplateEntry(momentId: 'comunione', songId: 'taize-ubi-caritas'),
    ],
  ),
  SetlistTemplate(
    id: 'preghiera-contemporanea',
    titles: {
      'it': 'Preghiera con la chitarra',
      'en': 'Contemporary Guitar Prayer',
    },
    descriptions: {
      'it': 'Repertorio contemporaneo (Gen Rosso / Gen Verde) per un incontro di preghiera.',
      'en': 'Contemporary repertoire (Gen Rosso / Gen Verde) for a prayer meeting.',
    },
    functionId: 'preghiera',
    entries: [
      TemplateEntry(momentId: 'apertura', songId: 'moderno-insieme-e-piu-bello'),
      TemplateEntry(momentId: 'ascolto', songId: 'moderno-dove-tu-sei'),
      TemplateEntry(momentId: 'intercessione', songId: 'moderno-segni-del-tuo-amore'),
      TemplateEntry(momentId: 'conclusione', songId: 'moderno-pace-sia-pace-a-voi'),
    ],
  ),
];
