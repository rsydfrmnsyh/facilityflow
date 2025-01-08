import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/inspection_model.dart';

class InspectionService {
  static const String baseUrl = 'http://localhost/api/inspections.php';
  static String message = '';

  static Future<List<Inspection>> readInspection() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((ins) => Inspection.fromJson(ins)).toList();
    } else {
      throw Exception('Failed to load data for Inspection');
    }
  }

  static Future<Inspection> readInspectionById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Inspection.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load details for Inspection');
    }
  }

  static Future<String> createInspection(Inspection inspection) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(inspection.toJson()),
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    try {
      final responseBody = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        message = responseBody['message'] ?? "Inspection successfully added";
      } else {
        throw Exception("Failed to create inspection: ${response.body}");
      }
    } catch (e) {
      throw Exception("Invalid JSON response: $e");
    }
    return message;
  }

  static Future<String> deleteInspection(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
    );

    try {
      final responseBody = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        message = responseBody['message'] ?? "Inspection successfully deleted";
      }
    } catch (e) {
      throw Exception("Invalid JSON response: $e");
    }
    return message;
  }
}
