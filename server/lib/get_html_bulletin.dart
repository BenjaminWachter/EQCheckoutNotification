import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

Future<String> getHtmlBulletin(String courseName, int courseNumberOnly) async {
  final response = await http.get(
    Uri.https(
      'wallawalla.smartcatalogiq.com',
      '/en/current/undergraduate-bulletin/courses/${_deptFullname[courseName]}/${(courseNumberOnly / 100).floor() * 100}/$courseNumberOnly',
    ),
  );

  final document = parse(response.body);

  // Extract elements with class="desc"
  final descElements = document.getElementsByClassName('desc');

  if (descElements.isNotEmpty) {
    return descElements[1].outerHtml;
  }
  return 'Failed to load the webpage.';
}

// Subject code to full department name
const Map _deptFullname = {
  'ACCT': 'acct-accounting',
  'ACDM': 'Acadeum',
  'ANTH': 'anth-anthropology',
  'ART': 'art-art',
  'AUTO': 'art-art',
  'AVIA': 'avia-aviation',
  'BIOL': 'biol-biology',
  'CDEV': 'cdev-career-development',
  'CHPL': 'chpl-chaplaincy',
  'CHEM': 'chem-chemistry',
  'CIS': 'cis-computer-info-systems',
  'COMM': 'comm-communications',
  'CPTR': 'cptr-computer-science',
  'CYBS': 'cybs-cybersecurity',
  'DRMA': 'Communication',
  'DSGN': 'Technology',
  'ECON': 'Business',
  'EDAD': 'Education & Psychology',
  'EDCI': 'Education & Psychology',
  'EDFB': 'Education & Psychology',
  'EDUC': 'Education & Psychology',
  'ENGL': 'English & Modern Languages',
  'ENGR': 'Engineering',
  'ENVI': 'Engineering',
  'FINA': 'Business',
  'FLTV': 'Communication',
  'FREN': 'English & Modern Languages',
  'GBUS': 'Business',
  'GDEV': 'gdev-game-development',
  'GEOG': 'History and Philosophy',
  'GNRL': 'Non-Departmental',
  'GREK': 'Theology',
  'GRPH': 'Technology',
  'HIST': 'History and Philosophy',
  'HLTH': 'Health and Physical Education',
  'HMNT': 'History and Philosophy',
  'HONR': 'Honors',
  'ITLN': 'Modern Language',
  'JOUR': 'Communication',
  'LANG': 'English & Modern Languages',
  'LAW': 'History and Philosophy',
  'MATH': 'Mathematics',
  'MDEV': 'Mathematics',
  'MDLG': 'Modern Language',
  'MEDU': 'Mathematics',
  'MGMT': 'Business',
  'MKTG': 'Business',
  'MUCT': 'Music',
  'MUED': 'Music',
  'MUHL': 'Music',
  'MUPF': 'Music',
  'NRSG': 'Nursing',
  'PEAC': 'Health and Physical Education',
  'PETH': 'Health and Physical Education',
  'PHIL': 'History and Philosophy',
  'PHTO': 'Technology',
  'PHYS': 'Physics',
  'PLSC': 'History and Philosophy',
  'PRDN': 'Technology',
  'PREL': 'Communication',
  'PSYC': 'Education & Psychology',
  'RELB': 'Theology',
  'RELH': 'Theology',
  'RELM': 'Theology',
  'RELP': 'Theology',
  'RELT': 'Theology',
  'SCDI': 'Biology',
  'SERV': 'Non-Departmental',
  'SMTF': 'Non-Departmental',
  'SOCI': 'Social Work & Sociology',
  'SOWK': 'Social Work & Sociology',
  'SPAN': 'Modern Language',
  'SPCH': 'Communication',
  'SPED': 'Education & Psychology',
  'SPPA': 'Communication',
  'TECH': 'Technology',
  'VISA': 'Visual Arts',
  'WRIT': 'English & Modern Languages',
};
