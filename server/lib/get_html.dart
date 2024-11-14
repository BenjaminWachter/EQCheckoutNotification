import 'package:http/http.dart' as http;
import 'package:server/get_pass.dart';
import 'package:html/parser.dart' show parse;


Future<String> getHtml() async {
  final Iterable<String> loginInfo = await getEmailAndPassword();
  final Map<String, String> queryParams = <String, String>{
    'email': loginInfo.first,
    'submit': loginInfo.last,
  };
  final response = await http.get(
    Uri.https(
      'wwufilmtv.eqcheckout.com',
      '/dashboard',
      queryParams,
    ),
  );

  return response.getElementById('schedule');
}
void main() async {
  final response = await getHtml();
  print(response);
}
