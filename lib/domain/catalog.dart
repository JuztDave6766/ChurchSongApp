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

const List<Song> kSongs = [
  Song(
    id: 'cantiamo-al-signore',
    titles: {'it': 'Cantiamo al Signore'},
    author: 'Testo dimostrativo',
    keySignature: 'Re maggiore',
    duration: Duration(minutes: 3, seconds: 40),
    tagIds: ['messa', 'ingresso', 'gioia', 'comunita'],
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
    tagIds: ['messa', 'gloria', 'gioia'],
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
    tagIds: ['preghiera', 'intercessione', 'pace'],
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

final Map<String, Song> kSongsById = {
  for (final song in kSongs) song.id: song,
};
