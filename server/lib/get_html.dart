import 'package:http/http.dart' as http;
import 'package:server/get_pass.dart';

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

  return response.body;
}
