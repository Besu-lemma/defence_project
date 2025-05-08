// // lib/services/gemini_service.dart
// import 'package:google_generative_ai/google_generative_ai.dart';

// class GeminiService {
//   static const String _apiKey = "AIzaSyBNRytdMFGl1SMX0SUK-IFx3217tpVTLP4";
//   late final GenerativeModel _model;

//   GeminiService() {
//     _model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: _apiKey);
//   }

//   Future<String> sendMessage(String message) async {
//     try {
//       final content = [Content.text(message)];
//       final response = await _model.generateContent(content);
//       return response.text ?? "No response from AI";
//     } catch (e) {
//       return "Error: ${e.toString()}";
//     }
//   }
// }

