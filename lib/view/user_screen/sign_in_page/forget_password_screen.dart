import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/auth_cubit.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {

  final emailCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new_outlined, size: 19,)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            const SizedBox(height: 50,),
            Image.asset('assets/images/reset-password.png', scale: 1.4,),
            const SizedBox(height: 30,),
            const Text('Quên mật khẩu', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            const SizedBox(height: 15,),
            const Text('Nhập địa chỉ email của bạn để lấy lại mật khẩu.', style: TextStyle(fontSize: 17,), textAlign: TextAlign.center,),
            const SizedBox(height: 30,),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 5),
                child: TextField(
                  controller: emailCtrl,
                  autofocus: false,
                  decoration: InputDecoration(
                    icon: Icon(Icons.email_outlined, size: 19,),
                    border: InputBorder.none,
                    hintText: 'Nhập địa chỉ email của bạn...',
                    hintStyle: TextStyle(
                      color: Colors.grey
                    )
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30,),
            Center(
              child: ElevatedButton(
                  onPressed: () async{
                    final result = await context.read<AuthCubit>().sendReset(emailCtrl.text);
                    if(result == 'success'){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Nếu email tồn tại trong hệ thống, chúng tôi đã gửi liên kết đặt lại mật khẩu.'), backgroundColor: Colors.blue.shade300,),
                      );
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Email không đúng định dạng.'), backgroundColor: Colors.blue.shade300,),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.blue.shade400,
                    minimumSize: Size(double.infinity, 45),
                    maximumSize: Size(double.infinity, 100)
                  ),
                  child: Text('Gửi yêu cầu', style: TextStyle(fontSize: 15, color: Colors.white))
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Future<void> openMailApp({BuildContext? context}) async{
//   if (Platform.isAndroid) {
//     final intent = AndroidIntent(
//       action: 'android.intent.action.MAIN',
//       category: 'android.intent.category.APP_EMAIL',
//     );
//
//     try {
//       await intent.launch();
//       return;
//     } catch (e) {
//       try {
//         final gmailIntent = AndroidIntent(
//           action: 'android.intent.action.MAIN',
//           package: 'com.google.android.gm',
//         );
//         await gmailIntent.launch();
//         return;
//       } catch (e2) {
//         if (context != null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Không tìm thấy ứng dụng email.')),
//           );
//         }
//       }
//     }
//   }
// }

// showDialog(
//     context: context,
//     builder: (_) => AlertDialog(
//       title: Center(
//         child: Text('Đã gửi email lấy lại mật khẩu', textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,),
//         )
//       ),
//       content: Image.asset('assets/images/message.png', scale: 1.4,),
//       contentPadding: EdgeInsets.zero,
//       actions: [
//         ElevatedButton(
//           onPressed: (){
//             openMailApp(context: context);
//           },
//           style: ElevatedButton.styleFrom(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10)
//             ),
//             backgroundColor: Colors.blue.shade300,
//             foregroundColor: Colors.white,
//             maximumSize: Size(500, 200),
//             minimumSize: Size(180, 40)
//           ),
//           child: Text('Mở ứng dụng email'),
//         )
//       ],
//       actionsAlignment: MainAxisAlignment.center,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10)
//       ),
//       insetPadding: EdgeInsets.symmetric(vertical: 240, horizontal: 50),
//     )
// );