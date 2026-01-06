import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/features/hrd_dashboard/controller/hrd_addjob_controller.dart';

class AddJobScreen extends StatelessWidget {
  static const String id = '/add_job';

  const AddJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddJobController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Tambah Lowongan'),
        backgroundColor: Colors.purple[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card Container
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title Input
                          _buildLabel('Judul Pekerjaan', Icons.work),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller.titleController,
                            decoration: _inputDecoration(
                                'e.g. Senior Flutter Developer'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Judul wajib diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Description Input
                          _buildLabel('Deskripsi Pekerjaan', Icons.description),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller.descriptionController,
                            maxLines: 6,
                            decoration: _inputDecoration(
                              'Jelaskan tugas, tanggung jawab, dan kualifikasi...',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Deskripsi wajib diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Location Input
                          _buildLabel('Lokasi', Icons.location_on),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller.locationController,
                            decoration:
                                _inputDecoration('e.g. Jakarta, Remote'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Lokasi wajib diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Salary Input
                          _buildLabel('Gaji', Icons.attach_money),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller.salaryController,
                            decoration: _inputDecoration(
                                'e.g. Rp 10.000.000 - 15.000.000'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Gaji wajib diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Job Type Selection
                          _buildLabel('Tipe Pekerjaan', Icons.access_time),
                          const SizedBox(height: 12),
                          Obx(() => Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  'Full-time',
                                  'Part-time',
                                  'Contract',
                                  'Internship'
                                ]
                                    .map((type) => _buildTypeChip(
                                          type,
                                          controller.selectedType.value == type,
                                          () => controller.selectedType.value =
                                              type,
                                        ))
                                    .toList(),
                              )),
                          const SizedBox(height: 20),

                          // Info Box
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue[200]!),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline,
                                    color: Colors.blue[700]),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Lowongan ini akan ditambahkan ke perusahaan Anda',
                                    style: TextStyle(
                                      color: Colors.blue[900],
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: controller.submitJob,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Posting Lowongan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
    );
  }

  Widget _buildLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[700]),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.purple[600]!, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildTypeChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple[600] : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
