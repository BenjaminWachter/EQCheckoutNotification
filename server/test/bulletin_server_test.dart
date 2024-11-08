import 'package:server/get_html_bulletin.dart';
import 'package:test/test.dart';

void main() {
  test('ClassOpen Reachable', () async {
    final String response = await getHtmlBulletin('CPTR', 450);
    expect(
      response.isNotEmpty,
      true,
      reason: 'Did not receive anything from ClassOpen',
    );
  });
}
