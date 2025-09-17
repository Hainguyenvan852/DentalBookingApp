import 'package:dental_booking_app/otp_verify_page.dart';
import 'package:dental_booking_app/view/sign_up/component/address_field.dart';
import 'package:dental_booking_app/view/sign_up/component/branch_selection_field.dart';
import 'package:dental_booking_app/view/sign_up/component/date_field.dart';
import 'package:dental_booking_app/view/sign_up/component/email_field.dart';
import 'package:dental_booking_app/view/sign_up/component/log_up_button.dart';
import 'package:dental_booking_app/view/sign_up/component/name_field.dart';
import 'package:dental_booking_app/view/sign_up/component/password_field.dart';
import 'package:dental_booking_app/view/sign_up/component/phone_number_field.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget{

  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {

  bool _canSubmit = false;
  bool _branchSelected = false;
  String? selectedBranch;

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

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
    if (nameHasError) {
      nameOk = false;
    } else {
      nameOk = true;
    }
    if (phoneHasError) {
      phoneOk = false;
    } else {
      phoneOk = true;
    }
    if (emailHasError) {
      emailOk = false;
    } else {
      emailOk = true;
    }
    if (passwordHasError) {
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

    var deviceSize = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        title: Text("Đăng ký",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.7, color: Colors.grey)),
      ),
      body: Column(
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
                AddressField(),
                PasswordField(
                  passwordCtrl: _passwordCtrl,
                  passwordKey: _passwordKey,
                  onChanged: (v) {
                    _validateOnly(_passwordKey);
                  },
                ),
                DatePickerField(),
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
              child: LogUpButton(
                enable: _canSubmit, onPressed: _onPressedLogUp,)
          ),
        ],
      ),
    );
  }

  void _onPressedLogUp(){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => OtpVerifyPage(email: "hainguyenvan852")));
  }
}



