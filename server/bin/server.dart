import 'dart:async';
import 'dart:io';
import 'package:server/html_handler.dart';

Future<void> dataStream() async {
  data = await htmlParse();
}

String data = '';

void main() async {
  //Change path based on hostname
  final host = Platform.localHostname;
  final File file;
  if (host == 'schedule-vm') {
    file = File('/var/www/html/assets/class_data.txt');
  } else {
    file = File('../client/assets/class_data.txt');
  }

  // ignore: unused_local_variable
  var dataFile = await file.writeAsString(data);
  const fiveMin = Duration(minutes: 5);
  Timer.periodic(fiveMin, (timer) async {
    await dataStream();
    dataFile = await file.writeAsString(data);
  });
}
