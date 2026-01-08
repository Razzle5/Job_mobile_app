import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:get/get.dart'; 
import 'package:job_app/features/user_dashboard/controllers/job_seeker_controller.dart';

class CustomColors { 
  static const Color darkAccent = Color(0xFF1976D2);
  static const Color lightAccent = Color(0xFF64B5F6);
}
class AccessoryWidgets {
  static void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}


class JobSeekerDataCollection extends StatefulWidget {
  const JobSeekerDataCollection(
    {Key? key}) : super(key: key);

  @override
  State<JobSeekerDataCollection> createState() => _JobSeekerDataCollectionState();
}

class _JobSeekerDataCollectionState extends State<JobSeekerDataCollection> {

  final _key = GlobalKey<FormState>();
  

  final TextEditingController _firstNameController = TextEditingController(); // Name
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController(); // DOB (String)
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(); // BARU
  final TextEditingController _domicileController = TextEditingController(); // BARU
  final TextEditingController _addressController = TextEditingController(); // BARU
  final List<String> educationOptions = [
      'SD',
      'SMP',
      'SMA/SMK',
      'Diploma (D1/D2/D3)',
      'Sarjana (S1)',
      'Magister (S2)',
      'Doktor (S3)',
    ];
    
    String? selectedEducation;

  PlatformFile? file;
  bool isLoading = false;
  DateTime? dob; 
  

  @override
  void dispose() {
    // Pastikan semua controller di-dispose
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _domicileController.dispose();
    _addressController.dispose();
    super.dispose();
  }
  
  // Fungsi untuk Pindah Halaman Setelah Sukses
  void nextPage() {
     Get.offAll(() => const Text("Home Screen Placeholder")); // Ganti dengan Home Screen Anda
  }

  Future<void> submitData() async {
    if (!_key.currentState!.validate()) return;
    
    // 1. Validasi CV/File
    if(file == null){
      AccessoryWidgets.showSnackBar("Tambahkan CV/Resume", context);
      return;
    }

    setState(() { isLoading = true; });

    // 2. Kumpulkan semua data
    final controller = Get.put(JobSeekerController());
      final success = await controller.submit(
        data: {
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'birth_date': _dateController.text,
          'phone_number': _phoneController.text,
          'email': _emailController.text,
          'domicile': _domicileController.text,
          'full_address': _addressController.text,
          'current_education': selectedEducation!,
        },
        cv: file!,
      );
    
    setState(() { isLoading = false; });
    
    if (success) {
      AccessoryWidgets.showSnackBar("Data berhasil disimpan", context);
      nextPage();
    } else {
      AccessoryWidgets.showSnackBar("Gagal menyimpan data", context);
    }
  }


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    // Hapus Provider.of, karena kita menggunakan GetX atau StatefulWidget
    // final authProvider = Provider.of<AuthProvider>(context); 
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: mediaQuery.width * .05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: mediaQuery.height * .025),
              SizedBox(
                height: mediaQuery.height * .35, // Ukuran disesuaikan
                width: mediaQuery.width * .35,
                child: Image.asset("assets/images/form.jpg",fit: BoxFit.cover,), 
              ),
              SizedBox(height: mediaQuery.height * .03),
              
              // Judul & Deskripsi
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Hampir Selesai!",
                    style: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: mediaQuery.width * .06)),
              ),
              Align(
                 alignment: Alignment.centerLeft,
                 child: Text(
                  "Tambahkan detail data diri untuk melanjutkan.",
                  style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w600,
                      color: CustomColors.darkAccent),
              ),),
              SizedBox(height: mediaQuery.height * .03),

              Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 1. NAMA DEPAN (FIRST NAME)
                      _buildTextField(
                        controller: _firstNameController,
                        icon: Ionicons.person_outline,
                        hintText: "Nama Depan",
                        keyboardType: TextInputType.name,
                        validator: (value) => (value!.isEmpty || value.length < 2) ? "Nama depan tidak valid" : null,
                      ),
                      SizedBox(height: 16),
                      

                      // 2. NAMA BELAKANG (LAST NAME)
                      _buildTextField(
                        controller: _lastNameController,
                        icon: Ionicons.accessibility_outline,
                        hintText: "Nama Belakang (Opsional)",
                        keyboardType: TextInputType.name,
                        // lastName bisa kosong, jadi validasi lebih ringan
                        validator: (value) => null, 
                      ),
                      SizedBox(height: 16),

                      // 3. EMAIL
                      _buildTextField(
                        controller: _emailController,
                        icon: Ionicons.mail_outline,
                        hintText: "Email",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => (value!.isEmpty || !value.contains('@')) ? "Email tidak valid" : null,
                      ),
                      SizedBox(height: 16),
                      
                      // 4. DOB & KALENDER
                      SizedBox(
                        height: mediaQuery.height*.09,
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _dateController,
                                icon: Ionicons.calendar_outline,
                                hintText: "Tanggal Lahir (DOB)",
                                keyboardType: TextInputType.datetime,
                                // DOB tidak boleh diisi manual, hanya lewat DatePicker
                                readOnly: true, 
                                validator: (value) {
                                  if(dob == null){
                                    return "Pilih tanggal lahir";
                                  }
                                  // Validasi Usia 18+
                                  if(DateTime.now().difference(dob!).inDays < 18*365){
                                      return "Minimal usia 18 tahun";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            // Button Date Picker
                            IconButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus(); // Tutup keyboard
                                dob = await showDatePicker(
                                  context: context, 
                                  initialDate: DateTime(2000, 1, 1), 
                                  firstDate: DateTime(1950, 1, 1), 
                                  lastDate: DateTime.now().subtract(const Duration(days: 18 * 365)), // Hanya bisa memilih usia 18+
                                );
                                if(dob!=null){
                                  // Update Controller dengan format yang diinginkan (Misalnya YYYY-MM-DD untuk API)
                                  _dateController.text = DateFormat('yyyy-MM-dd').format(dob!); 
                                }
                              }, 
                              icon: Icon(Ionicons.calendar_outline, color: CustomColors.lightAccent),
                            )
                          ],
                        )
                      ),
                      
                      // 5. NOMOR TELEPON
                      _buildTextField(
                        controller: _phoneController,
                        icon: Ionicons.phone_portrait_outline,
                        hintText: "Nomor Telepon",
                        keyboardType: TextInputType.phone,
                        validator: (value) => (value!.isEmpty || value.length < 10) ? "Nomor telepon tidak valid" : null,
                      ),
                      SizedBox(height: 16),
                      
                      // 6. DOMISILI
                      _buildTextField(
                        controller: _domicileController,
                        icon: Ionicons.home_outline,
                        hintText: "Domisili (Kota)",
                        keyboardType: TextInputType.text,
                        validator: (value) => value!.isEmpty ? "Domisili wajib diisi" : null,
                      ),
                      SizedBox(height: 16),
                      
                      // 7. ALAMAT LENGKAP
                      _buildTextField(
                        controller: _addressController,
                        icon: Ionicons.location_outline,
                        hintText: "Alamat Lengkap",
                        keyboardType: TextInputType.multiline,
                        maxLines: 3, // Izinkan lebih dari 1 baris
                        validator: (value) => value!.isEmpty ? "Alamat wajib diisi" : null,
                      ),
                      SizedBox(height: 16),

                      // 8. PENDIDIKAN SAAT INI 
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: InputBorder.none, // Hapus border default
                            prefixIcon: Icon(
                              Ionicons.school_outline,
                              color: CustomColors.lightAccent,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          hint: Text("Pilih Pendidikan Terakhir", style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.w600, color: Colors.black38),
                          ),
                          value: selectedEducation,
                          isExpanded: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Pendidikan wajib dipilih";
                            }
                            return null;
                          },
                          items: educationOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: GoogleFonts.nunitoSans()),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedEducation = newValue;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      // 9. UPLOAD CV/RESUME
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Tambahkan CV/Resume",style: GoogleFonts.nunitoSans(color: Colors.black,fontWeight: FontWeight.w600),),
                          SizedBox(width: mediaQuery.width*.05,),
                          ElevatedButton(onPressed: ()async{
                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf','doc','docx'],
                            );

                            if (result != null) {
                                setState(() {
                                  file = result.files.first;
                                });
                                AccessoryWidgets.showSnackBar("File dipilih: ${file?.name}", context);

                            } else {
                              AccessoryWidgets.showSnackBar("Seleksi file dibatalkan", context);
                            }
                          }, child: Text(file == null ? "UPLOAD" : "GANTI FILE",style: GoogleFonts.nunitoSans(color: Colors.white,fontWeight: FontWeight.w600),),style: ButtonStyle(backgroundColor: WidgetStateProperty.all(CustomColors.darkAccent)),)
                        ],
                      ),
                      SizedBox(height: mediaQuery.height * .05),

                      // 10. SUBMIT BUTTON
                      ElevatedButton(
                        onPressed: isLoading ? null : submitData, // Disable tombol saat loading
                        style: ButtonStyle(
                            padding: WidgetStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: mediaQuery.width * .035,
                                    vertical: mediaQuery.height * .015)),
                            backgroundColor: WidgetStateProperty.all(
                                CustomColors.darkAccent)),
                        child: isLoading
                            ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            )
                            : Text(
                              "Simpan Data",
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: mediaQuery.width * .03),
                            ))
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper Widget untuk membuat TextFormField yang seragam
  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      validator: validator,
      style: GoogleFonts.nunitoSans(),
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        prefixIcon: Icon(
          icon,
          color: CustomColors.lightAccent,
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w600, color: Colors.black38),
        fillColor: Colors.black12,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
    );
  }
}