// FILE: features/jobseeker/screen/jobseeker_profile_screen.dart

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:job_app/data/repositories/auth_repository_jobseeker.dart';
import 'package:job_app/features/authentications/screen/welcome_screen.dart';
import 'package:job_app/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomColors {
  static const Color darkAccent = Color(0xFF1976D2);
  static const Color lightAccent = Color(0xFF64B5F6);
}

class JobseekerProfileScreen extends StatefulWidget {
  const JobseekerProfileScreen({super.key});
  static const String id = '/job-seeker_profile';

  @override
  State<JobseekerProfileScreen> createState() => _JobseekerProfileScreenState();
}

class _JobseekerProfileScreenState extends State<JobseekerProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthRepositoryJobSeeker _authRepo = AuthRepositoryJobSeeker();

  // Text Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _domicileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // State
  bool _loading = true;
  bool _isEditing = false;
  bool _hasProfile = false;
  DateTime? _selectedDate;
  String? _selectedEducation;
  PlatformFile? _cvFile;

  final List<String> educationOptions = [
    'SD',
    'SMP',
    'SMA/SMK',
    'Diploma (D1/D2/D3)',
    'Sarjana (S1)',
    'Magister (S2)',
    'Doktor (S3)',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _domicileController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);

    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.tBaseUrl}/api/job-seeker/profile'),
         headers: { 'Authorization': 'Bearer ${await _authRepo.getToken()}',
        'Accept': 'application/json', 
        'Content-Type': 'application/json', 
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final profile = body['data'];

        _firstNameController.text = profile['first_name'] ?? '';
        _lastNameController.text = profile['last_name'] ?? '';
        _emailController.text = profile['email'] ?? '';
        _phoneController.text = profile['phone_number'] ?? '';
        _dobController.text = profile['birth_date'] ?? '';
        _domicileController.text = profile['domicile'] ?? '';
        _addressController.text = profile['full_address'] ?? '';
        _selectedEducation = profile['current_education'];

        setState(() {
          _hasProfile = false;
          _isEditing = true;
        });
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
      setState(() {
        _hasProfile = false;
        _isEditing = false;
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _pickDate() async {
    FocusScope.of(context).unfocus();

    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 18 * 365)),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        _dobController.text = DateFormat('yyyy-MM-dd').format(date);
      });
    }
  }

  Future<void> _pickCV() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() {
          _cvFile = result.files.first;
        });

        Get.snackbar(
          'File Dipilih',
          'CV: ${_cvFile!.name}',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
      Get.snackbar(
        'Error',
        'Gagal memilih file',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedEducation == null) {
      Get.snackbar(
        'Gagal',
        'Pilih pendidikan terakhir',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!_hasProfile && _cvFile == null) {
      Get.snackbar(
        'Gagal',
        'Upload CV/Resume terlebih dahulu',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _loading = true);

    try {
      // Data profil
      final profileData = {
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'birth_date': _dobController.text,
        'phone_number': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'domicile': _domicileController.text.trim(),
        'full_address': _addressController.text.trim(),
        'current_education': _selectedEducation!,
      };

      debugPrint('Profile Data: $profileData');
      debugPrint('CV File: ${_cvFile?.name}');

      // Kirim ke backend API (pakai multipart request karena ada file)
    final uri = Uri.parse('${ApiConstants.tBaseUrl}/api/job-seeker/profile');




      final request = http.MultipartRequest(
        _hasProfile ? 'PUT' : 'POST',
        uri,
      );


      // Tambahkan header auth kalau perlu
      final token = await _authRepo.getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Tambahkan field
      request.fields.addAll(profileData);

      // Tambahkan file CV kalau ada
      if (_cvFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('cv', _cvFile!.path!));
      }

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      debugPrint('Response: $respStr');

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _hasProfile = true;
          _isEditing = false;
          _loading = false;
        });

        Get.snackbar(
          'Sukses',
          'Profil berhasil disimpan',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        debugPrint('Status Code: ${response.statusCode}'); 
        debugPrint('Response Body: $respStr');
        throw Exception('Failed to save profile: $respStr');
      }
    } catch (e) {
      debugPrint('Error saving profile: $e');
      setState(() => _loading = false);

      Get.snackbar(
        'Error',
        'Gagal menyimpan profil',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
              style: GoogleFonts.nunitoSans(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _authRepo.logout();

      Get.offAllNamed(WelcomeScreen.id);

      Get.snackbar(
        'Logout',
        'Berhasil logout',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Logout error: $e');
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
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                setState(() => _isEditing = true);
              },
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _isEditing
              ? _buildEditForm()
              : _buildProfileView(),
    );
  }

  // ==================== EDIT/CREATE FORM ====================
  Widget _buildEditForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _hasProfile ? 'Edit Profil' : 'Lengkapi Profil Anda',
              style: GoogleFonts.nunitoSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: CustomColors.darkAccent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _hasProfile
                  ? 'Update informasi profil Anda'
                  : 'Silakan isi data diri untuk melanjutkan',
              style: GoogleFonts.nunitoSans(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // First Name
            _buildTextField(
              controller: _firstNameController,
              icon: Ionicons.person_outline,
              hintText: 'Nama Depan',
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            // Last Name
            _buildTextField(
              controller: _lastNameController,
              icon: Ionicons.person_outline,
              hintText: 'Nama Belakang',
            ),
            const SizedBox(height: 16),

            // Email
            _buildTextField(
              controller: _emailController,
              icon: Ionicons.mail_outline,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) => (value == null || !value.contains('@'))
                  ? 'Email tidak valid'
                  : null,
            ),
            const SizedBox(height: 16),

            // Phone
            _buildTextField(
              controller: _phoneController,
              icon: Ionicons.phone_portrait_outline,
              hintText: 'Nomor Telepon',
              keyboardType: TextInputType.phone,
              validator: (value) => (value == null || value.length < 10)
                  ? 'Nomor tidak valid'
                  : null,
            ),
            const SizedBox(height: 16),

            // Date of Birth
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _dobController,
                    icon: Ionicons.calendar_outline,
                    hintText: 'Tanggal Lahir',
                    readOnly: true,
                    validator: (value) =>
                        (value == null || value.isEmpty) ? 'Wajib diisi' : null,
                  ),
                ),
                IconButton(
                  onPressed: _pickDate,
                  icon:
                      Icon(Ionicons.calendar, color: CustomColors.lightAccent),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Domicile
            _buildTextField(
              controller: _domicileController,
              icon: Ionicons.home_outline,
              hintText: 'Domisili (Kota)',
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            // Address
            _buildTextField(
              controller: _addressController,
              icon: Ionicons.location_outline,
              hintText: 'Alamat Lengkap',
              maxLines: 3,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),

            // Education Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(30),
              ),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Ionicons.school_outline,
                    color: CustomColors.lightAccent,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
                hint: Text(
                  'Pilih Pendidikan Terakhir',
                  style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w600,
                    color: Colors.black38,
                  ),
                ),
                value: _selectedEducation,
                isExpanded: true,
                validator: (value) => value == null ? 'Wajib dipilih' : null,
                items: educationOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: GoogleFonts.nunitoSans()),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() => _selectedEducation = newValue);
                },
              ),
            ),
            const SizedBox(height: 24),

            // Upload CV
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'CV/Resume',
                  style: GoogleFonts.nunitoSans(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _pickCV,
                  icon:
                      Icon(_cvFile == null ? Icons.upload : Icons.check_circle),
                  label: Text(
                    _cvFile == null ? 'UPLOAD' : _cvFile!.name,
                    style: GoogleFonts.nunitoSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _cvFile == null
                        ? CustomColors.darkAccent
                        : Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                if (_hasProfile)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => _isEditing = false);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey[400]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: GoogleFonts.nunitoSans(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                if (_hasProfile) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.darkAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Simpan Profil',
                      style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==================== PROFILE VIEW (READ-ONLY) ====================
  Widget _buildProfileView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
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
                CircleAvatar(
                  radius: 60,
                  backgroundColor: CustomColors.lightAccent,
                  child: Text(
                    '${_firstNameController.text.isNotEmpty ? _firstNameController.text[0] : 'U'}${_lastNameController.text.isNotEmpty ? _lastNameController.text[0] : ''}',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${_firstNameController.text} ${_lastNameController.text}',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _selectedEducation ?? 'Pendidikan',
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

          // Body
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Informasi Kontak', Ionicons.call_outline),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Ionicons.mail_outline,
                  label: 'Email',
                  value: _emailController.text,
                ),
                const SizedBox(height: 10),
                _buildInfoCard(
                  icon: Ionicons.phone_portrait_outline,
                  label: 'Nomor Telepon',
                  value: _phoneController.text,
                ),
                const SizedBox(height: 24),

                _buildSectionTitle(
                    'Informasi Pribadi', Ionicons.person_outline),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Ionicons.calendar_outline,
                  label: 'Tanggal Lahir',
                  value: _formatDate(_dobController.text),
                ),
                const SizedBox(height: 10),
                _buildInfoCard(
                  icon: Ionicons.home_outline,
                  label: 'Domisili',
                  value: _domicileController.text,
                ),
                const SizedBox(height: 10),
                _buildInfoCard(
                  icon: Ionicons.location_outline,
                  label: 'Alamat',
                  value: _addressController.text,
                  maxLines: 3,
                ),
                const SizedBox(height: 24),

                // Action Buttons
                ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout),
                  label: Text(
                    'Logout',
                    style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size(double.infinity, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== HELPER WIDGETS ====================

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      validator: validator,
      keyboardType: keyboardType,
      style: GoogleFonts.nunitoSans(),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        prefixIcon: Icon(icon, color: CustomColors.lightAccent),
        hintText: hintText,
        hintStyle: GoogleFonts.nunitoSans(
          fontWeight: FontWeight.w600,
          color: Colors.black38,
        ),
        fillColor: Colors.black12,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
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

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'Tanggal tidak tersedia';

    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      debugPrint('Format date error: $e');
      return dateString; // fallback ke string asli
    }
  }
}
