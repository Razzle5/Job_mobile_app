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

  factory JobModel.fromJson(Map<String,dynamic>json){
    final companyData = json['company'] as Map<String, dynamic>?;

    return JobModel(
      id : json['id'] as int,
      companyId: json['company_id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      salary: json['salary'] as String,
      type: json['type'] as String,

      companyName: companyData?['brand_name'] ?? 'N/A', 
      companyLogo: 'Iconsax.facebook',
    );
  }
}