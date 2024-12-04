import 'package:http/http.dart' as http;
import 'package:server/get_pass.dart';

Future<Map<String, String>> getHtml() async {
  final Iterable<String> loginInfo = await getEmailAndPassword();
  final response = await http.post(
    Uri.https(
      'wwufilmtv.eqcheckout.com',
      '/user/login',
    ),
    body: <String, String>{
      'email': loginInfo.first,
      'password': loginInfo.last,
    },
  );
  if (response.statusCode == 302) {
    final dashboardResponse = await http.get(
      Uri.https(
        'wwufilmtv.eqcheckout.com',
        '/dashboard',
      ),
      headers: <String, String>{'cookie': response.headers['set-cookie'] ?? ''},
    );
    return {
      'body': dashboardResponse.body,
      'cookie': response.headers['set-cookie'] ?? '',
    };
  } else {
    throw Exception('Failed to log in');
  }
}
