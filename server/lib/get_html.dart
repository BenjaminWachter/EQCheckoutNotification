import 'package:http/http.dart' as http;
import 'package:server/get_pass.dart';

Future<String> getHtml() async {
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
    return dashboardResponse.body;
  } else {
    throw Exception('Failed to log in');
  }
}

void main() async {
  final response = await getHtml();
  print(response);
}
