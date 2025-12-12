import 'package:dental_booking_app/logic/user_cubit.dart';
import 'package:dental_booking_app/view/user_screen/main_screen/chat_bot/chatbot_screen.dart';
import 'package:dental_booking_app/view/user_screen/main_screen/doctor_info_page/doctor_list_screen.dart';
import 'package:dental_booking_app/view/user_screen/main_screen/gallery_page/gallery_screen.dart';
import 'package:dental_booking_app/view/user_screen/main_screen/medical_cost_page/payment_history_screen.dart';
import 'package:dental_booking_app/view/user_screen/main_screen/personal_page/profile_screen.dart';
import 'package:dental_booking_app/view/user_screen/main_screen/product_catalog_page/order_history_screen.dart';
import 'package:dental_booking_app/view/user_screen/main_screen/support_page/support_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/repository/user_repository.dart';
import '../medical_cost_page/installment_payment.dart';
import '../my_appointment_page/my_appointment_page.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  late final FirebaseAuth _auth;
  final _userRepo = UserRepository();

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => _userRepo,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => UserCubit(_userRepo)..loadUserInfo(_auth.currentUser!.uid)
          )
        ],
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: SafeArea(
            child: ListView(
              children: [
                SizedBox(height: 20,),
                PictureAndName(auth: _auth,),
                SizedBox(height: 30,),
                Builder(
                  builder: (context) {
                    return FeatureBox(featureName: 'Cập Nhật Hồ Sơ', featureIcon: Icons.person_outline,
                        onPressed: () {
                          final userCubit = context.read<UserCubit>();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: userCubit,
                                child: const ProfilePage(),
                              ),
                            ),
                          );
                        }
                    );
                  }
                ),
                FeatureBox(featureName: 'Lịch Hẹn Của Tôi', featureIcon: Icons.calendar_month,
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyAppointmentPage())),
                ),
                FeatureBox(featureName: 'Lịch Sử Thanh Toán', featureIcon: Icons.money_rounded,
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentHistoryPage())),
                ),
                FeatureBox(featureName: 'Lịch Sử Mua Hàng', featureIcon: Icons.receipt_long,
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryScreen())),
                ),
                FeatureBox(featureName: 'Lịch Trả Góp', featureIcon: Icons.payment,
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InstallmentPayment())),
                ),
                FeatureBox(featureName: 'Ảnh Điều Trị Và Bệnh Án', featureIcon: Icons.image_outlined,
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GalleryPage())),
                ),
                FeatureBox(featureName: 'Nhân Viên Tư Vấn Chatbot', featureIcon: Icons.support_agent_outlined,
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen())),
                ),
                FeatureBox(featureName: 'Thông Tin Bác Sĩ', featureIcon: Icons.assignment_ind,
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DoctorListScreen())),
                ),
                FeatureBox(featureName: 'Liên Hệ Và Trợ Giúp', featureIcon: Icons.help_outline,
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpAndSupportScreen())),
                ),
                SizedBox(height: 40,),
                SignOutButton(
                    onPressed: (){
                      _auth.signOut();
                    }
                ),
                SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PictureAndName extends StatelessWidget {
  const PictureAndName({super.key, required this.auth});
  final FirebaseAuth auth;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state){
        if(state.loading){
          return Center(child: CircularProgressIndicator(color: Colors.blue,));
        }
        if(state.error != null){
          return Center(child: Text('Error: ${state.error.toString()}'),);
        }

        return Column(
          children: [
            Image.asset(
              'assets/images/user-picture2.png',
              height: 140,
              width: 140,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 12,),
            Text(state.user!.fullName!, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 21),)
          ],
        );
      }
    );
  }
}

class FeatureBox extends StatelessWidget {
  const FeatureBox({super.key, required this.featureName, required this.featureIcon, required this.onPressed});
  final String featureName;
  final IconData featureIcon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.blue.shade50
            ),
            child: Icon(featureIcon, size: 24, color: Colors.blue,),
          ),
          SizedBox(
            width: 220,
            child: Text(featureName, style: TextStyle(fontSize: 16, ),),
          ),
          IconButton(
            onPressed: () => onPressed(),
            icon: Icon(Icons.arrow_forward_ios_rounded, size: 16,),
            style: IconButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero
            ),
          )
        ],
      ),
    );
  }
}

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10,),
        padding: EdgeInsets.symmetric(vertical: 13,),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.red.shade100,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.red, size: 22,),
            SizedBox(width: 20,),
            Text('Đăng xuất', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red),),
          ],
        ),
      ),
    );
  }
}
