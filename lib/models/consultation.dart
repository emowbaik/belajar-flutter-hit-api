class Consultation {
  final int id;
  final String name;
  final DateTime date;
  final String poli;
  final String complaint;
  final int queueNumber;

  Consultation({
    required this.id,
    required this.name,
    required this.date,
    required this.poli,
    required this.complaint,
    required this.queueNumber,
  });

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      date: DateTime.parse(json['date']),
      poli: json['poli'] ?? '',
      complaint: json['complaint'] ?? '',
      queueNumber: json['queue_number'] ?? 0,
    );
  }
}