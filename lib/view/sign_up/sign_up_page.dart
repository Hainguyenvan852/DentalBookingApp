import 'package:dental_booking_app/view/sign_in/bloc/auth_cubit.dart';
import 'package:dental_booking_app/view/sign_in/bloc/auth_state.dart';
import 'package:dental_booking_app/view/sign_up/component/address_field.dart';
import 'package:dental_booking_app/view/sign_up/component/branch_selection_field.dart';
import 'package:dental_booking_app/view/sign_up/component/date_field.dart';
import 'package:dental_booking_app/view/sign_up/component/email_field.dart';
import 'package:dental_booking_app/view/sign_up/component/name_field.dart';
import 'package:dental_booking_app/view/sign_up/component/password_field.dart';
import 'package:dental_booking_app/view/sign_up/component/phone_number_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget{

  const SignUpPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return SignUpPageState();
  }
}

class SignUpPageState extends State<SignUpPage> {

  bool _canSubmit = false;
  bool _branchSelected = false;
  String? selectedBranch;

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  final _nameKey = GlobalKey<FormFieldState>();
  final _phoneKey = GlobalKey<FormFieldState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();

  void _validateOnly(GlobalKey<FormFieldState> key) {
    key.currentState?.validate();
    _recomputeCanSubmit();
  }

  void _recomputeCanSubmit() {
    final nameHasError = _nameKey.currentState?.hasError ?? true;
    final phoneHasError = _phoneKey.currentState?.hasError ?? true;
    final emailHasError = _emailKey.currentState?.hasError ?? true;
    final passwordHasError = _passwordKey.currentState?.hasError ?? true;
    bool nameOk, phoneOk, emailOk, passwordOk;
    if (nameHasError && _nameCtrl.text.isEmpty) {
      nameOk = false;
    } else {
      nameOk = true;
    }
    if (phoneHasError && _phoneCtrl.text.isEmpty) {
      phoneOk = false;
    } else {
      phoneOk = true;
    }
    if (emailHasError && _emailCtrl.text.isEmpty) {
      emailOk = false;
    } else {
      emailOk = true;
    }
    if (passwordHasError && _passwordCtrl.text.isEmpty) {
      passwordOk = false;
    } else {
      passwordOk = true;
    }

    final isValid = nameOk && phoneOk && emailOk && passwordOk &&
        _branchSelected;

    if (_canSubmit != isValid) {
      setState(() => _canSubmit = isValid);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => context.read<AuthCubit>().requestSignIn(),
            icon: Icon(Icons.arrow_back_ios_new, size: 20,)
        ),
        toolbarHeight: 70,
        centerTitle: true,
        title: Text("Đăng ký",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.7, color: Colors.grey)),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (p, c) => c is AuthUnauthenticated || c is AuthNeedsEmailVerify,
        listener: (context, state) {
          if (state is AuthUnauthenticated && state.message != null){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message!))
            );
          }
        },
        builder: (context, state) {
          final loading = state is AuthLoading;
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        NameField(
                            nameCtrl: _nameCtrl,
                            nameKey: _nameKey,
                            onChanged: (v) {
                              _validateOnly(_nameKey);
                            }
                        ),
                        PhoneNumberField(
                            phoneCtrl: _phoneCtrl,
                            phoneKey: _phoneKey,
                            onChanged: (v) {
                              _validateOnly(_phoneKey);
                            }
                        ),
                        EmailField(
                          emailCtrl: _emailCtrl,
                          emailKey: _emailKey,
                          onChanged: (v) {
                            _validateOnly(_emailKey);
                          },
                        ),
                        AddressField(addressCtrl: _addressCtrl,),
                        PasswordField(
                          passwordCtrl: _passwordCtrl,
                          passwordKey: _passwordKey,
                          onChanged: (v) {
                            _validateOnly(_passwordKey);
                          },
                        ),
                        DatePickerField(dateController: _dateCtrl,),
                        BranchSelectionField(
                          value: selectedBranch,
                          onChanged: (v) {
                            setState(() {
                              selectedBranch = v;
                            });
                            _branchSelected = true;
                            _recomputeCanSubmit();
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 40),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                            onPressed: !_canSubmit ? null : () async{
                              context.read<AuthCubit>().signUp(_emailCtrl.text.trim(),  _passwordCtrl.text.trim(),  _nameCtrl.text.trim(),  _phoneCtrl.text.trim(), _dateCtrl.text.trim(),  _addressCtrl.text.trim(), );
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                                backgroundColor: Colors.lightBlue,
                                foregroundColor: Colors.white
                            ),
                            child: Text("Đăng ký", style: TextStyle(fontSize: 20,),)
                        ),
                      )
                  ),
                ],
              ),
              // if(loading)
              //   Positioned.fill(
              //       child: IgnorePointer(
              //         ignoring: true,
              //         child: Container(
              //           color: Colors.black12,
              //           alignment: Alignment.center,
              //           child: const CircularProgressIndicator(
              //             color: Colors.lightBlueAccent,
              //           ),
              //         ),
              //       )
              //   )
            ],
          );
        },
      ),
    );
  }
}



