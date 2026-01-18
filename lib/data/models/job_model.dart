class JobModel {
  final int id;
  final int companyId;
  final String title;
  final String description;
  final String location;
  final String salary;
  final String type;
  final String companyName;
  final String companyLogo;

  JobModel({
    required this.id,
    required this.companyId,
    required this.title,
    required this.description,
    required this.location,
    required this.salary,
    required this.type,
    required this.companyName,
    required this.companyLogo,
  });

  /// Factory untuk parsing JSON dari API Laravel
  factory JobModel.fromJson(Map<String, dynamic> json) {
    // Ambil relasi company kalau ada
    final companyData = json['company'] as Map<String, dynamic>?;

    return JobModel(
      id: _parseInt(json['id']),
      companyId: _parseInt(json['company_id']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      salary: json['salary']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      companyName: companyData?['brand_name']?.toString() ?? '',
      companyLogo: companyData?['logo']?.toString() ?? '',
    );
  }

  /// Convert ke JSON (misalnya untuk create/update job)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'title': title,
      'description': description,
      'location': location,
      'salary': salary,
      'type': type,
      'company_name': companyName,
      'company_logo': companyLogo,
    };
  }

  // Helper method untuk parsing int dengan aman
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
