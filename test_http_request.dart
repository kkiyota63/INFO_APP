import 'dart:convert';
import 'dart:io';

void main() async {
  var url = 'https://kadaiinfo.com/rss/nO0soVtCP7jDPK41E79T';
  var httpClient = HttpClient();
  try {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      var responseBody = await response.transform(Utf8Decoder()).join();
      print('Success: $responseBody');
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching data: $e');
  }
}
