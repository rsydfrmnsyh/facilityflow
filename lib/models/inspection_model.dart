class Inspection {
  int? id;
  String inspector;
  DateTime date;  // Change to DateTime
  String facility;
  String status;
  String details;

  Inspection({
    this.id,
    required this.inspector,
    required this.date,
    required this.facility,
    required this.status,
    required this.details
  });

  factory Inspection.fromJson(Map<String, dynamic> json) {
    return Inspection(
      id: json['id'] is String ? int.tryParse(json['id']) : json['id'],
      inspector: json['inspector'],
      date: DateTime.parse(json['date']), 
      facility: json['facility'],
      status: json['status'],
      details: json['details'],
    );
  }

  get notes => null;

  Map<String, dynamic> toJson() {
    return {
      'inspector': inspector,
      'date': date.toIso8601String(),
      'facility': facility,
      'status': status,
      'details': details,
    };
  }
}
