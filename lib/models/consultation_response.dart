import 'consultation.dart';

class ConsultationResponse {
  final bool success;
  final String message;
  final List<Consultation> data;

  ConsultationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ConsultationResponse.fromJson(Map<String, dynamic> json){
    return ConsultationResponse(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List)
            .map((e) => Consultation.fromJson(e))
            .toList(),
    );
  }
}