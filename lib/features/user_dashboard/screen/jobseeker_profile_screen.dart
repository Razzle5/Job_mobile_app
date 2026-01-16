// FILE: features/jobseeker/screen/jobseeker_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:get/get.dart';
import 'package:job_app/data/repositories/auth_repository_jobseeker.dart';
import 'package:job_app/features/authentications/screen/welcome_screen.dart';

class CustomColors {
  static const Color darkAccent = Color(0xFF1976D2);
  static const Color lightAccent = Color(0xFF64B5F6);
}

class JobseekerProfileScreen extends StatefulWidget {
  const JobseekerProfileScreen({super.key});
  static const String id = '/jobseeker_profile';

  @override
  State<JobseekerProfileScreen> createState() => _JobseekerProfileScreenState();
}

class _JobseekerProfileScreenState extends State<JobseekerProfileScreen> {
  final AuthRepositoryJobSeeker _authRepo = AuthRepositoryJobSeeker();
  
  bool _loading = true;
  bool _hasError = false;
  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _loading = true;
      _hasError = false;
    });

    try {
      // Ambil data user dari SharedPreferences
      final userData = await _authRepo.getUserData();
      
      // TODO: Nanti panggil API untuk get full profile
      // final result = await JobseekerRepository().getProfile();
      
      // Sementara pakai data dari SharedPreferences
      setState(() {
        _profileData = {
          'firstName': 'John',
          'lastName': 'Doe',
          'email': userData['email'] ?? 'user@example.com',
          'phone': '081234567890',
          'dob': '1995-05-15',
          'domicile': 'Jakarta',
          'address': 'Jl. Sudirman No. 123, Jakarta Pusat',
          'education': 'Sarjana (S1)',
          'cvFileName': 'CV_John_Doe.pdf',
        };
        _loading = false;
      });
    } catch (e) {
      debugPrint('Error loading profile: $e');
      setState(() {
        _hasError = true;
        _loading = false;
      });
    }
  }

  Future<void> _logout() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: Text(
          'Logout',
          style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar?',
          style: GoogleFonts.nunitoSans(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Batal', style: GoogleFonts.nunitoSans()),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'Ya, Logout',
              style: GoogleFonts.nunitoSans(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _loading = true);
    
    try {
      await _authRepo.logout();
      
      Get.offAllNamed(WelcomeScreen.id);
      
      Get.snackbar(
        'Logout',
        'Anda telah berhasil logout',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Logout error: $e');
      Get.snackbar(
        'Error',
        'Gagal logout',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Profil Saya',
          style: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: CustomColors.darkAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Get.snackbar(
                'Edit Profile',
                'Fitur edit profile akan segera hadir',
                backgroundColor: Colors.orange,
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? _buildErrorState()
              : RefreshIndicator(
                  onRefresh: _loadProfile,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: _buildProfileContent(),
                  ),
                ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Gagal memuat profil',
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadProfile,
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    if (_profileData == null) {
      return const Center(child: Text('Data tidak tersedia'));
    }

    return Column(
      children: [
        // ================= HEADER SECTION =================
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: CustomColors.darkAccent,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Avatar
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: CustomColors.lightAccent,
                  child: Text(
                    '${_profileData!['firstName']![0]}${_profileData!['lastName']!.isNotEmpty ? _profileData!['lastName']![0] : ''}',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Name
              Text(
                '${_profileData!['firstName']} ${_profileData!['lastName']}',
                style: GoogleFonts.nunitoSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              // Education
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _profileData!['education']!,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ================= BODY SECTION =================
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Information
              _buildSectionTitle('Informasi Kontak', Ionicons.call_outline),
              const SizedBox(height: 12),
              _buildInfoCard(
                icon: Ionicons.mail_outline,
                label: 'Email',
                value: _profileData!['email']!,
              ),
              const SizedBox(height: 10),
              _buildInfoCard(
                icon: Ionicons.phone_portrait_outline,
                label: 'Nomor Telepon',
                value: _profileData!['phone']!,
              ),
              const SizedBox(height: 24),

              // Personal Information
              _buildSectionTitle('Informasi Pribadi', Ionicons.person_outline),
              const SizedBox(height: 12),
              _buildInfoCard(
                icon: Ionicons.calendar_outline,
                label: 'Tanggal Lahir',
                value: _formatDate(_profileData!['dob']!),
              ),
              const SizedBox(height: 10),
              _buildInfoCard(
                icon: Ionicons.home_outline,
                label: 'Domisili',
                value: _profileData!['domicile']!,
              ),
              const SizedBox(height: 10),
              _buildInfoCard(
                icon: Ionicons.location_outline,
                label: 'Alamat Lengkap',
                value: _profileData!['address']!,
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              _buildInfoCard(
                icon: Ionicons.school_outline,
                label: 'Pendidikan Terakhir',
                value: _profileData!['education']!,
              ),
              const SizedBox(height: 24),

              // CV/Resume
              _buildSectionTitle('CV / Resume', Ionicons.document_text_outline),
              const SizedBox(height: 12),
              if (_profileData!['cvFileName'] != null)
                _buildCVCard(
                  fileName: _profileData!['cvFileName']!,
                  onView: () {
                    Get.snackbar(
                      'CV',
                      'Membuka ${_profileData!['cvFileName']}',
                      backgroundColor: Colors.blue,
                      colorText: Colors.white,
                    );
                  },
                  onDownload: () {
                    Get.snackbar(
                      'Download',
                      'Mengunduh ${_profileData!['cvFileName']}',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  },
                )
              else
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.orange[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'CV belum diupload',
                          style: GoogleFonts.nunitoSans(
                            color: Colors.orange[900],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.snackbar(
                          'Edit',
                          'Fitur edit profile akan segera hadir',
                          backgroundColor: Colors.orange,
                          colorText: Colors.white,
                        );
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: Text(
                        'Edit Profile',
                        style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.darkAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: Text(
                        'Logout',
                        style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: CustomColors.darkAccent, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.nunitoSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CustomColors.lightAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: CustomColors.darkAccent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCVCard({
    required String fileName,
    required VoidCallback onView,
    required VoidCallback onDownload,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CustomColors.lightAccent.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Ionicons.document_text, color: Colors.red[700], size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'PDF Document',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onView,
            icon: const Icon(Ionicons.eye_outline),
            color: CustomColors.darkAccent,
            tooltip: 'Lihat',
          ),
          IconButton(
            onPressed: onDownload,
            icon: const Icon(Ionicons.download_outline),
            color: Colors.green,
            tooltip: 'Download',
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}