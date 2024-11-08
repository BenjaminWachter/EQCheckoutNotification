import 'package:html/parser.dart' show parse;
import 'package:server/get_html.dart';

Future<String> htmlParse() async {

  // Extract elements with class="desc"
  final checkoutBlock = parse(getHtml()).getElementById('schedule');

  if (checkoutBlock != null) {
    //paarsing the html
    // returns csv data
    return checkoutBlock.outerHtml;
  }
  return 'Failed to load the webpage.';
}
