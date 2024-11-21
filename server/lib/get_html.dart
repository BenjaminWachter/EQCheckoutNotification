import 'package:http/http.dart' as http;
import 'package:server/get_pass.dart';

Future<String> getHtml() async {
  final Iterable<String> loginInfo = await getEmailAndPassword();
  final Map<String, String> formData = <String, String>{
    'email': loginInfo.first,
    'password': loginInfo.last,
  };
  final response = await http.post(
    Uri.https(
      'wwufilmtv.eqcheckout.com',
      '/user/login',
    ),
    headers: <String, String>{
      'email': loginInfo.first,
      'password': loginInfo.last,
    },
  );
  print(response.body);
  return response.body;
  // ignore: dead_code
  if (response.statusCode == 200) {
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
