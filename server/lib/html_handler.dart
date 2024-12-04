import 'package:html/parser.dart' show parse;
import 'package:server/get_html.dart';
    import 'dart:io';
    import 'package:csv/csv.dart';

Future<String?> htmlParse() async {

  // Extract elements with class="desc"
  final tuple = await getHtml();
  final htmlString = tuple['body'];
  // ignore: unused_local_variable
  final cookie = tuple['cookie'];
  final document = parse(htmlString);
  final checkoutBlock = document.getElementById('schedule');

  if (checkoutBlock != null) {
    // parse checkout block for names checking out and are not in a csv file
    final checkoutList = checkoutBlock.querySelectorAll('.day.');
    final namesCheckingOut = checkoutBlock.querySelectorAll('.name');
    final csvFile = File('checkout_log.csv');
    List<List<dynamic>> csvData = [];

    if (csvFile.existsSync()) {
      final csvString = csvFile.readAsStringSync();
      csvData = CsvToListConverter().convert(csvString);
    }
    for (final checkout in checkoutList) {
      print(checkout.className.trim());
      if (checkout.className.trim() == 'day today '){
        final dayElement = DateTime.now().day.toString();
      } else {
      // final dayElement = nameElement.parent?.querySelector('.day');
      }

    for (var nameElement in namesCheckingOut) {
      final name = nameElement.text.trim();
      final dayElement = nameElement.parent?.querySelector('.day');
      print(dayElement);
      final timeCheckedOut = dayElement?.text.trim() ?? 'Unknown';

      bool nameExists = csvData.any((row) => row.contains(name));
      if (!nameExists) {
        csvData.add([name, timeCheckedOut, DateTime.now().toString()]);
      }
    }

    final csvString = const ListToCsvConverter().convert(csvData);
    csvFile.writeAsStringSync(csvString);

    // returns csv data
    return checkoutBlock.outerHtml;
  }}
  return 'Failed to load the webpage.';
}

void main() async {
  final response = await htmlParse();
  print(response);
}
