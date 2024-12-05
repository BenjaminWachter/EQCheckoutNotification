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
    final allDays = checkoutBlock.querySelectorAll('.day');
    final checkoutList = [for (int i = 1; i < allDays.length; i += 2) allDays[i]];
    final namesCheckingOut = checkoutBlock.querySelectorAll('.name');
    final csvFile = File('checkout_log.csv');
    List<List<dynamic>> csvData = [];

    if (csvFile.existsSync()) {
      final csvString = csvFile.readAsStringSync();
      csvData = CsvToListConverter().convert(csvString);
    }
    for (final checkout in checkoutList) {
      print(checkout.innerHtml);
      final dayElement = checkout.innerHtml;
      print(checkout.parent?.nextElementSibling?.outerHtml);
    }

    for (final nameElement in namesCheckingOut) {
      final name = nameElement.text.trim();
      final dayElement = nameElement.parent?.querySelector('.day');
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
  }
  return 'Failed to load the webpage.';
}

void main() async {
  final response = await htmlParse();
  // print(response);
}
