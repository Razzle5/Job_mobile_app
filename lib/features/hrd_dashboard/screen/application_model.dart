class ApplicationModel {
  final int id;
  final String jobTitle;
  final String jobSeekerName;
  final String status;

  ApplicationModel({
    required this.id,
    required this.jobTitle,
    required this.jobSeekerName,
    required this.status,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'],
      jobTitle: json['job']['title'] ?? 'Tanpa Judul',
      jobSeekerName: json['job_seeker']['first_name'] ?? 'Tanpa Nama',
      status: json['status'] ?? 'pending',
    );
  }
}
