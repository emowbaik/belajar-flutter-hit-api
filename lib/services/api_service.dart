import 'package:belajar_flutter_hit_api/models/consultation.dart';
import 'package:http/http.dart' as http;
import 'package:belajar_flutter_hit_api/models/consultation_response.dart';
import 'dart:convert';

import 'package:intl/intl.dart';

class ApiService {
  final String baseUrl = "https://user.ahay.my.id/consultations";

  Future<List<Consultation>> getConsultations() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final result = ConsultationResponse.fromJson(json);

      return result.data;
    } else {
      throw Exception('Failed to load Data');
    }
  }

    Future<void> createConsultations(
      String name,
      DateTime date,
      String poli,
      String complaint,
    ) async {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "date": date.toIso8601String(),
          "poli": poli,
          "complaint": complaint,
        }),
      );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create data');
    }
  }

  Future<void> updateConsultation(
    int id,
    String name,
    DateTime date,
    String poli,
    String complaint,
  ) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "date": DateFormat("yyyy-MM-dd").format(date),
        "poli": poli,
        "complaint": complaint,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update data');
    }
  }

  Future<void> deleteConsultation(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete data');
    }
  }
}