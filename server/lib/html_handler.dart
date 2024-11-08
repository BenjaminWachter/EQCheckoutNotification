import 'package:html/parser.dart' show parse;
import 'package:server/get_html.dart';

Future<String> getHtmlBulletin() async {

  // Extract elements with class="desc"
  final checkoutBlock = parse(getHtml()).getElementById('schedule');

  if (checkoutBlock != null) {
    return checkoutBlock.outerHtml;
  }
  return 'Failed to load the webpage.';
}
