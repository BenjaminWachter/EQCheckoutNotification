import 'dart:io';

Future<Iterable<String>> getEmailAndPassword() async {
  final file = File('password.config');
  final lines = await file.readAsLines();

  if (lines.length < 2) {
    throw Exception('Invalid config file');
  }

  final email = lines[0];
  final password = lines[1];

  return [email, password];
}
