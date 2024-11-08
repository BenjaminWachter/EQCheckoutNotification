import 'package:http/http.dart' as http;

Future<String> getHtml() async {
  final Map<String, String> queryParams = <String, String>{
    'strm': 'f2024',
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
