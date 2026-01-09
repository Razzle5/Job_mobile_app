class JobseekerModel {
  final int id;
  final String first_name;
  final String last_name;
  final String birth_date;
  final String phone_number;
  final String email;
  final String domicile;
  final String full_address;
  final String current_education;

  JobseekerModel({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.birth_date,
    required this.phone_number,
    required this.email,
    required this.domicile,
    required this.full_address,
    required this.current_education,
  });

  factory JobseekerModel.fromJson(Map<String, dynamic> json) {
    return JobseekerModel(
      id: json['id'] as int,
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      birth_date: json['birth_date'] as String,
      phone_number: json['phone_number'] as String,
      email: json['email'] as String,
      domicile: json['domicile'] as String,
      full_address: json['full_address'] as String,
      current_education: json['current_education'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'first_name': first_name,
      'last_name': last_name,
      'birth_date': birth_date,
      'phone_number': phone_number,
      'email': email,
      'domicile': domicile,
      'full_address': full_address,
      'current_education': current_education,
    };
  }
}
