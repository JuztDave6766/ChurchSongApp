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
    seasonIds: ['quaresima'],
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

/// Ready-made setlists built from the repertoire imported from the user's
/// songbooks. They only reference ids present in
/// `assets/data/personal_songs.json`; a test keeps the two in sync.
const List<SetlistTemplate> kSetlistTemplates = [
  SetlistTemplate(
    id: 'tpl-messa-domenicale',
    titles: {
      'it': 'Messa domenicale',
      'en': 'Sunday Mass',
    },
    descriptions: {
      'it': 'Una scaletta completa per la Messa domenicale, dal canto d\'ingresso al congedo.',
      'en': 'A complete Sunday Mass setlist, from the entrance song to the dismissal.',
    },
    functionId: 'messa',
    entries: [
      TemplateEntry(momentId: 'ingresso', songId: 'ps_cantiamo-te'),
      TemplateEntry(momentId: 'atto-penitenziale', songId: 'ps_signore-pieta'),
      TemplateEntry(momentId: 'gloria', songId: 'ps_gloria'),
      TemplateEntry(momentId: 'versetto-alleluia', songId: 'ps_alleluia-irlandese'),
      TemplateEntry(momentId: 'offertorio', songId: 'ps_accogli-i-nostri-doni'),
      TemplateEntry(momentId: 'santo', songId: 'ps_santo'),
      TemplateEntry(momentId: 'comunione', songId: 'ps_agnello-di-dio'),
      TemplateEntry(momentId: 'congedo', songId: 'ps_io-saro-con-te'),
    ],
  ),
  SetlistTemplate(
    id: 'tpl-messa-avvento',
    titles: {
      'it': 'Messa in Avvento',
      'en': 'Advent Mass',
    },
    descriptions: {
      'it': 'Canti del canzoniere per il tempo di Avvento, con Emmanuel alla comunione.',
      'en': 'Repertoire songs for Advent, with Emmanuel at communion.',
    },
    functionId: 'messa',
    entries: [
      TemplateEntry(momentId: 'ingresso', songId: 'ps_camminiamo-incontro-al-signore'),
      TemplateEntry(momentId: 'atto-penitenziale', songId: 'ps_signore-pieta-2'),
      TemplateEntry(momentId: 'versetto-alleluia', songId: 'ps_alleluia-passeranno-i-cieli'),
      TemplateEntry(momentId: 'offertorio', songId: 'ps_accogli-nella-tua-bonta'),
      TemplateEntry(momentId: 'santo', songId: 'ps_santo-osanna'),
      TemplateEntry(momentId: 'comunione', songId: 'ps_emmanuel'),
      TemplateEntry(momentId: 'congedo', songId: 'ps_noi-arcobaleno-di-dio'),
    ],
  ),
  SetlistTemplate(
    id: 'tpl-adorazione',
    titles: {
      'it': 'Adorazione eucaristica',
      'en': 'Eucharistic Adoration',
    },
    descriptions: {
      'it': 'Esposizione, adorazione, silenzio e benedizione con i canti eucaristici.',
      'en': 'Exposition, adoration, silence and blessing with the Eucharistic songs.',
    },
    functionId: 'adorazione',
    entries: [
      TemplateEntry(momentId: 'esposizione', songId: 'ps_adoriamo-il-sacramento'),
      TemplateEntry(momentId: 'adorazione-momento', songId: 'ps_adoro-te'),
      TemplateEntry(momentId: 'silenzio', songId: 'ps_anima-christi'),
      TemplateEntry(momentId: 'benedizione', songId: 'ps_tantum-ergo'),
    ],
  ),
  SetlistTemplate(
    id: 'tpl-via-crucis',
    titles: {
      'it': 'Via Crucis',
      'en': 'Stations of the Cross',
    },
    descriptions: {
      'it': 'Introduzione, stazioni e conclusione con i canti della croce.',
      'en': 'Introduction, stations and conclusion with the songs of the Cross.',
    },
    functionId: 'via-crucis',
    entries: [
      TemplateEntry(momentId: 'introduzione', songId: 'ps_canto-della-via-crucis'),
      TemplateEntry(momentId: 'stazione', songId: 'ps_signore-dolce-volto'),
      TemplateEntry(momentId: 'stazione', songId: 'ps_ti-saluto-croce-santa'),
      TemplateEntry(momentId: 'stazione', songId: 'ps_crocifisso-mio-signor'),
      TemplateEntry(momentId: 'conclusione', songId: 'ps_salve-regina'),
    ],
  ),
  SetlistTemplate(
    id: 'tpl-preghiera-mariana',
    titles: {
      'it': 'Preghiera mariana',
      'en': 'Marian Prayer',
    },
    descriptions: {
      'it': 'Un incontro di preghiera con i canti mariani del canzoniere.',
      'en': 'A prayer meeting with the Marian songs of the repertoire.',
    },
    functionId: 'preghiera',
    entries: [
      TemplateEntry(momentId: 'apertura', songId: 'ps_cantiamo-te'),
      TemplateEntry(momentId: 'ascolto', songId: 'ps_padre-nostro'),
      TemplateEntry(momentId: 'intercessione', songId: 'ps_ave-maria-verbum-panis'),
      TemplateEntry(momentId: 'conclusione', songId: 'ps_salve-regina'),
    ],
  ),
];
