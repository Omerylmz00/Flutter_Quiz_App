import 'dart:convert';

import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey =
      'AIzaSyD-OK8erE3PVc4bbHoSLenP7TXawKrJEEw'; // Buraya kendi API key’ini koy

  Future<List<Map<String, dynamic>>> fetchQuizQuestions() async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text":
                    "Flutter hakkında 5 tane çoktan seçmeli soru üret. Her soru 1 doğru ve 3 yanlış şık içersin. Sadece şu JSON formatında ver: [{\"text\": \"Soru\", \"answers\": [\"doğru\", \"yanlış1\", \"yanlış2\", \"yanlış3\"]}]"
              }
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final rawText = data['candidates'][0]['content']['parts'][0]['text'];

      // Kod bloğu temizleme işlemi burada:
      final cleaned =
          rawText.replaceAll('```json', '').replaceAll('```', '').trim();

      return List<Map<String, dynamic>>.from(jsonDecode(cleaned));
    } else {
      print("HATA ${response.statusCode}");
      print("Cevap: ${response.body}");
      throw Exception('Gemini API hatası: ${response.statusCode}');
    }
  }
}



//AIzaSyBjP3yc8pMeXK9IBMnBpH0Q2GZWVYx3kGw