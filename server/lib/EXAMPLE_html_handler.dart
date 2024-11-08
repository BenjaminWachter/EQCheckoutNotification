import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart';
import 'package:universal_html/parsing.dart';

class HTMLHandler {
  // cache containing fetched data using fetchListFromHtml
  static List<List<String>> _data = List.empty();
  //static bool _usingTest = false;

  // ignore_for_file: type_annotate_public_apis
  //note print has limits. If you want to see the whole csv use IO to write out to a file.
  static List<List<String>> get data => _data;

  static late String year;

  // empty data
  static void empty() {
    _data = List.empty();
  }

  //Need to call this to instantiate getHtml() data!
  //Call this in main.dart or before any multiple tests involving live HTML
  // returns data from html getting/parsing as a list of list of strings

  //Purpose: To grab the raw HTML document from
  //"flutter pub add http" if you are missing the package from your environment.
  //Note ios and android need permissions if developing for that.
  static Future<String> fetchHtml() async {
    final currentTime = DateTime.now();
    if (currentTime.month > 0 && currentTime.month < 7) {
      year = currentTime.year.toString();
    } else {
      year = (currentTime.year + 1).toString();
    }

    final String quarter = 'f$year';
    final Map<String, String> queryParams = <String, String>{
      'strm': quarter,
      'submit': 'Search',
    };
    final response = await http.get(
      Uri.https(
        'classopen.wallawalla.edu',
        '/classopenps.php',
        queryParams,
      ),
    );
    return response.body;
  }

  //Test var is strictly for unit testing
  // html parsing
  //FIX: Parsing Code ignores first class entry
  static Future<List<List<String>>> listFromHtml() async {
    List<List<String>> data = List.empty();
    var document = '';
    document = await fetchHtml();
    final htmlDoc = parseHtmlDocument(
      document.replaceAll(RegExp(r'(<br \/>|<br>)+'), '/'),
    );
    final classTable = htmlDoc.getElementById('resulttable');

    if (classTable == null) {
      throw Exception('Class Table is empty.');
    }
    final evenRows = classTable.getElementsByClassName('evenrow');
    final oddRows = classTable.getElementsByClassName('oddrow');
    final allRows = evenRows + oddRows;
    data = List.generate(
      allRows.length,
      (i) => List<String>.filled(30, '', growable: false),
      growable: false,
    );
    for (int x = 0; x < allRows.length; x++) {
      final nodes = allRows[x].childNodes;
      //CRSE_OFFER_NBR, default=1, don't know what this is for and doesn't seem to be used.
      data[x][0] = '1';
      //CAMPUS, =CP   CP
      data[x][1] = nodes[38].text?.trim() ?? '';
      //ACAD_YEAR, =2024    2024
      data[x][2] = year;
      //ACAD_ORG,     BIOL
      try {
        data[x][3] = _subjDept[nodes[2].text!]?.trim();
      } catch (e) {
        throw Exception('Subject "${nodes[2].text!}" not found!');
      }
      //WWU_ACAD_ORG_DESCR,   Biology
      data[x][4] = _deptFullname[data[x][3]] ?? data[x][3];
      //CLASS_NBR,    1536
      data[x][5] = nodes[0].text?.trim() ?? '';
      //WWU_GS,   GS or space
      if (nodes[16].text == 'GS') {
        data[x][6] = 'GS';
      } else {
        data[x][6] = '';
      }
      //SUBJECT
      data[x][7] = nodes[2].text?.trim() ?? '';
      //WWU_SUM1
      data[x][8] = nodes[4].text?.trim() ?? '';
      //WWU_AUT
      data[x][9] = nodes[6].text?.trim() ?? '';
      //WWU_WTR
      data[x][10] = nodes[8].text?.trim() ?? '';
      //WWU_SPR
      data[x][11] = nodes[10].text?.trim() ?? '';
      //WWU_SUM2
      data[x][12] = nodes[12].text?.trim() ?? '';
      //CLASS_SECTION
      data[x][13] = nodes[14].text?.trim() ?? '';
      //DESCR
      data[x][14] = nodes[20].text?.trim() ?? '';
      //WWU_UNITS
      data[x][15] = nodes[18].text?.trim() ?? '';
      //ENRL_STAT
      data[x][16] = nodes[22].text?.trim() ?? '';
      //ENRL_TOT
      data[x][17] = nodes[24].text?.trim() ?? '';
      //ENRL_CAP
      data[x][18] = nodes[26].text?.trim() ?? ''; //good up to here
      //WAIT_TOT
      data[x][19] =
          nodes[28].text?.trim().replaceAll(' in wait list', '') ?? '';
      //FEE_AMT
      data[x][20] = nodes[30].text?.trim().replaceAll('\$', '') ?? '';
      //WWU_MTG_PAT_COMB
      data[x][21] = nodes[32].text?.trim() ?? '';
      //WWU_ROOM -- sometimes is only a line break
      data[x][22] =
          nodes[34].text?.trim().replaceFirst(RegExp(r'^/$'), '') ?? '';
      //WWU_INSTR_NAME
      data[x][23] = nodes[36].text?.trim() ?? '';
      //DESCRLONG
      data[x][24] = nodes[44].text?.trim() ?? '';
      //INSTRUCTION_MODE
      data[x][25] = 'P';
      if (data[x][22] == 'ONLINE') {
        data[x][25] = 'O';
      }
      //SCHEDULE_PRINT we don't use it, so for yeah I will leave it blank.
      data[x][26] = '';
      //VIDEO_LINK
      if (nodes[40].hasChildNodes()) {
        data[x][27] =
            (nodes[40] as TableCellElement).children[0].attributes['href'] ??
                '';
      } else {
        data[x][27] = '';
      }
      //CONSENT,  I=Instructor consent required, D=Department consent required, N=No consent needed
      if (nodes[42].text == null || nodes[42].text == '') {
        data[x][28] = 'N';
      } else {
        if (nodes[42].text!.contains('Instructor')) {
          data[x][28] = 'I';
        } else {
          data[x][28] = 'D';
        }
      }
      //CONSENT_DESCR
      data[x][29] = nodes[42].text?.trim() ?? '';
    }
    return data;
  }

  // maps:
  // Static map is a potential problem in the future
  static const Map _subjDept = {
    'ACCT': 'BUSI',
    'ACDM': 'ACDM',
    'ANTH': 'SOWK',
    'ART': 'ART',
    'AUTO': 'TECH',
    'AVIA': 'TECH',
    'BIOL': 'BIOL',
    'CDEV': 'NDEP',
    'CHPL': 'RELB',
    'CHEM': 'CHEM',
    'CIS': 'BUSI',
    'CMC': 'MUCT',
    'COMM': 'COMM',
    'CORR': 'SOWK',
    'CPTR': 'CPTR',
    'CYBS': 'CPTR',
    'DRMA': 'COMM',
    'DSGN': 'TECH',
    'ECON': 'BUSI',
    'EDAD': 'EDUC',
    'EDCI': 'EDUC',
    'EDFB': 'EDUC',
    'EDUC': 'EDUC',
    'ENGL': 'ENGL',
    'ENGR': 'ENGI',
    'ENVI': 'ENGI',
    'FILM': 'VISA',
    'FINA': 'BUSI',
    'FLTV': 'COMM',
    'FREN': 'ENGL',
    'GBUS': 'BUSI',
    'GDEV': 'CPTR',
    'GEOG': 'HIST',
    'GEOL': 'ACDM',
    'GNRL': 'NDEP',
    'GREK': 'RELB',
    'GRPH': 'TECH',
    'HEBR': 'RELB',
    'HIST': 'HIST',
    'HLTH': 'HLTH',
    'HMNT': 'HIST',
    'HONR': 'HONR',
    'ITLN': 'MDLG',
    'JOUR': 'COMM',
    'LANG': 'ENGL',
    'LAW': 'HIST',
    'MATH': 'MATH',
    'MDEV': 'MATH',
    'MDLG': 'MDLG',
    'MEDU': 'MATH',
    'MGMT': 'BUSI',
    'MKTG': 'BUSI',
    'MUCT': 'MUCT',
    'MUED': 'MUCT',
    'MUHL': 'MUCT',
    'MUPF': 'MUCT',
    'NRSG': 'NRSG',
    'PEAC': 'HLTH',
    'PETH': 'HLTH',
    'PHIL': 'HIST',
    'PHTO': 'TECH',
    'PHYS': 'PHYS',
    'PLSC': 'HIST',
    'PRDN': 'TECH',
    'PREL': 'COMM',
    'PSYC': 'EDUC',
    'RELB': 'RELB',
    'RELH': 'RELB',
    'RELM': 'RELB',
    'RELP': 'RELB',
    'RELT': 'RELB',
    'SCDI': 'BIOL',
    'SERV': 'NDEP',
    'SMTF': 'NDEP',
    'SOCI': 'SOWK',
    'SOWK': 'SOWK',
    'SPAN': 'MDLG',
    'SPCH': 'COMM',
    'SPED': 'EDUC',
    'SPPA': 'COMM',
    'TECH': 'TECH',
    'VIS': 'VISA',
    'VISA': 'VISA',
    'VISD': 'VISA',
    'VISF': 'VISA',
    'WRIT': 'ENGL',
  };

  // Subject code to full department name
  static const Map _deptFullname = {
    'ACCT': 'Business',
    'ACDM': 'Acadeum',
    'ANTH': 'Social Work & Sociology',
    'ART': 'Art',
    'AUTO': 'Technology',
    'AVIA': 'Technology',
    'BIOL': 'Biology',
    'CDEV': 'Non-Departmental',
    'CHPL': 'Chaplaincy',
    'CHEM': 'Chemistry',
    'CIS': 'Business',
    'COMM': 'Communication',
    'CPTR': 'Computer Science',
    'CYBS': 'Computer Science',
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
    'GDEV': 'Computer Science',
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
}
