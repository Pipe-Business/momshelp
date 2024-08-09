import 'dart:convert';

import 'package:http/http.dart' as http;
Future<String> fetchTranslateText(String text, String targetLang) async {
  final apiKey = 'YOUR_API_KEY';
  final url = 'https://translation.googleapis.com/language/translate/v2';

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'q': text,
      'target': targetLang,
      'key': apiKey,
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['data']['translations'][0]['translatedText'];
  } else {
    throw Exception('Failed to translate text');
  }
}