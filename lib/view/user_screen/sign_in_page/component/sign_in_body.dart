import 'package:dental_booking_app/view/user_screen/sign_in_page/bloc/auth_cubit.dart';
import 'package:dental_booking_app/view/user_screen/sign_in_page/component/sign_in_field.dart';
import 'package:dental_booking_app/view/user_screen/sign_in_page/forget_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SignInBody extends StatefulWidget{

  SignInBody({super.key, });

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {

  final accountCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    accountCtrl.addListener(_checkFormValid);
    passwordCtrl.addListener(_checkFormValid);
  }

  @override
  void dispose() {
    accountCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  void _checkFormValid(){
    bool isValid = accountCtrl.text.isNotEmpty && passwordCtrl.text.isNotEmpty;

    setState(() {
      _canSubmit = isValid;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left:10, right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          color: Colors.white),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 30),
            child: Center(
              child: Text("Đăng nhập", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
            ),
          ),
          SignInField(title: "Tài khoản", obscureText: 0, textEditingController: accountCtrl,),
          const SizedBox(height: 20,),
          SignInField(title: "Mật khẩu", obscureText: 1, textEditingController: passwordCtrl,),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: TextButton(
                onPressed: () {
                  final authCubit = context.read<AuthCubit>();
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: authCubit,
                        child: ForgetPasswordPage(),
                      )
                  ));
                },
                style: TextButton.styleFrom(
                    foregroundColor: Colors.orange,
                    padding: EdgeInsets.zero,
                    minimumSize: Size(100, 30),
                    maximumSize: Size(200, 100),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap
                ),
                child: Text('Quên mật khẩu?', style: TextStyle(fontSize: 15, color: Colors.blue, ))
            ),
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(top: 0,),
            child: ElevatedButton(
                onPressed: () async{
                  if(_canSubmit){
                    context.read<AuthCubit>().signIn(accountCtrl.text.trim(), passwordCtrl.text.trim());
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Bạn chưa nhập đủ thông tin đăng nhập'), backgroundColor: Colors.blue.shade300,)
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    )
                ),
                child:Text("Đăng nhập", style: TextStyle(fontSize: 16),)
            )
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20.0,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Bạn đăng ký tài khoản chưa?",
                  style: TextStyle(fontSize: 15),),
                TextButton(
                  onPressed:() => registerClick(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.orange,
                    padding: EdgeInsets.only(left: 3),
                  ),
                  child: Text("Đăng ký ngay", style: TextStyle(fontSize: 15)),),
              ],
            )
          ),
        ],
      ),
    );
  }

  void registerClick(BuildContext context) {
    context.read<AuthCubit>().requestSignUp();
  }
}