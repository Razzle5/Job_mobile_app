import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/data/repositories/auth_repository_hrd.dart';
import 'package:job_app/features/authentications/screen/welcome_screen.dart';

class HrdProfileScreen extends StatefulWidget {
  const HrdProfileScreen({super.key});

  static const String id = '/hrd_profile';

  @override
  State<HrdProfileScreen> createState() => _HrdProfileScreenState();
}

class _HrdProfileScreenState extends State<HrdProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _legalName = TextEditingController();
  final _brandName = TextEditingController();
  final _employCount = TextEditingController();
  final _industry = TextEditingController();
  final _address = TextEditingController();

  final AuthRepository _authRepo = AuthRepository();
  bool _loading = false;
  Map<String, dynamic>? _company;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    final res = await _authRepo.getHrdProfile();
    if (res['success'] == true && res['data'] != null) {
      final data = res['data'];
      final company = data['company'];
      _company = company != null ? Map<String, dynamic>.from(company) : null;
      if (_company != null) {
        _legalName.text = _company!['legal_name'] ?? '';
        _brandName.text = _company!['brand_name'] ?? '';
        _employCount.text = (_company!['employ_count'] ?? '').toString();
        _industry.text = _company!['industry'] ?? '';
        _address.text = _company!['address'] ?? '';
      }
    }
    setState(() {
      _isEditing = _company == null;
      _loading = false;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final payload = {
      'legal_name': _legalName.text.trim(),
      'brand_name': _brandName.text.trim(),
      'employ_count': int.tryParse(_employCount.text) ?? 0,
      'industry': _industry.text.trim(),
      'address': _address.text.trim(),
    };

    final res = await _authRepo.updateHrdProfile(payload);
    setState(() => _loading = false);

    if (res['success'] == true) {
      // Save company_id to local storage if present
      final data = res['data'] ?? {};
      final company = data['company'];
      final user = data['user'];
      if (user != null) {
        await _authRepo.saveUserData({
          'email': user['email'] ?? '',
          'name': user['name'] ?? '',
          'company_id':
              user['company_id'] ?? (company != null ? company['id'] : 0),
        });
      }

      // update local company and show read-only view
      setState(() {
        _company =
            company != null ? Map<String, dynamic>.from(company) : _company;
        _isEditing = false;
      });

      Get.snackbar('Sukses', 'Profile perusahaan disimpan',
          backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar('Gagal', res['message'] ?? 'Gagal menyimpan profile',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> _logout() async {
    // Confirm logout
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _loading = true);
    await _authRepo.logout();
    setState(() => _loading = false);

    Get.offAllNamed(WelcomeScreen.id);
    Get.snackbar(
      'Logout',
      'Anda telah logout',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  void dispose() {
    _legalName.dispose();
    _brandName.dispose();
    _employCount.dispose();
    _industry.dispose();
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Perusahaan')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: _isEditing
                  ? SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _legalName,
                              decoration: const InputDecoration(
                                  labelText: 'Legal Name'),
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Wajib diisi' : null,
                            ),
                            TextFormField(
                              controller: _brandName,
                              decoration: const InputDecoration(
                                  labelText: 'Brand Name'),
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Wajib diisi' : null,
                            ),
                            TextFormField(
                              controller: _employCount,
                              decoration: const InputDecoration(
                                  labelText: 'Jumlah Karyawan'),
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              controller: _industry,
                              decoration:
                                  const InputDecoration(labelText: 'Industri'),
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Wajib diisi' : null,
                            ),
                            TextFormField(
                              controller: _address,
                              decoration:
                                  const InputDecoration(labelText: 'Alamat'),
                              maxLines: 3,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Wajib diisi' : null,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _submit,
                              child: const Text('Simpan Profil'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: const Text('Legal Name'),
                          subtitle: Text(_company?['legal_name'] ?? '-'),
                        ),
                        ListTile(
                          title: const Text('Brand Name'),
                          subtitle: Text(_company?['brand_name'] ?? '-'),
                        ),
                        ListTile(
                          title: const Text('Jumlah Karyawan'),
                          subtitle: Text('${_company?['employ_count'] ?? '-'}'),
                        ),
                        ListTile(
                          title: const Text('Industri'),
                          subtitle: Text(_company?['industry'] ?? '-'),
                        ),
                        ListTile(
                          title: const Text('Alamat'),
                          subtitle: Text(_company?['address'] ?? '-'),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _isEditing = true;
                                });
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: _logout,
                              icon: const Icon(Icons.logout),
                              label: const Text('Logout'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
            ),
    );
  }
}
