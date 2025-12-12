import 'package:dental_booking_app/data/model/dentist_model.dart';
import 'package:dental_booking_app/data/model/user_model.dart';
import 'package:dental_booking_app/data/repository/user_repository.dart';
import 'package:dental_booking_app/view/doctor_screen/screens/user_info_screen.dart';
import 'package:dental_booking_app/view/user_screen/sign_in_page/bloc/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../data/repository/dentist_repository.dart';
import 'change_password_screen.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SettingsScreen(),
  ));
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final _auth = FirebaseAuth.instance;
  final _dentistsRepo = DentistRepository();
  final _userRepo = UserRepository();
  late final Future<dynamic> dentistFuture;


  @override
  void initState() {
    super.initState();
    dentistFuture =  _fetchDentistData();
  }

  Future<dynamic> _fetchDentistData() async {
    final user = await _userRepo.getUser(_auth.currentUser!.uid);

    if (user == null || user.clinicId == null || user.staffId == null) {
      throw Exception("Không tìm thấy thông tin người dùng");
    }

    return await _dentistsRepo.getById(user.staffId!, user.clinicId!);
  }

  @override
  Widget build(BuildContext context) {
    final Color bgGrey = const Color(0xFFF5F7FA);
    final Color iconBlueBg = const Color(0xFFE3F2FD);
    final Color iconBlue = const Color(0xFF2196F3);
    final Color logoutBg = const Color(0xFFFFEBEE);
    final Color logoutRed = const Color(0xFFD32F2F);

    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder(
          future: dentistFuture,
          builder: (context, snap){
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.waveDots(
                  color: Colors.blue,
                  size: 35,
                ),
              );
            }

            if (snap.error != null || !snap.hasData) {
              return Center(child: Text('Error ${snap.error.toString()}'));
            }

            final dentist = snap.data;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: dentist!.sex ? AssetImage('assets/images/men_doctor.png') : AssetImage('assets/images/women_doctor.png'),
                        backgroundColor: Colors.blue.shade300,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dentist.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Bác sĩ nha khoa',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Tài khoản',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.person,
                        text: 'Thông tin cá nhân',
                        iconColor: iconBlue,
                        iconBgColor: iconBlueBg,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(dentist: dentist))),
                      ),
                      Center(child: const Divider(height: 0.5, indent: 0,)),
                      _buildMenuItem(
                        icon: Icons.lock,
                        text: 'Thay đổi mật khẩu',
                        iconColor: iconBlue,
                        iconBgColor: iconBlueBg,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen())),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    onTap: () => context.read<AuthCubit>().signOut(),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: logoutBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: logoutRed, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Đăng xuất',
                            style: TextStyle(
                              color: logoutRed,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          }
      )
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required Color iconColor,
    required Color iconBgColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
    );
  }
}
