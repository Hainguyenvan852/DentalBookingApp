import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../data/model/user_model.dart';
import '../../../../data/repository/gallery_repository.dart';
import '../../../../data/repository/user_repository.dart';
import '../../../../logic/user_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final GalleryRepository repo;
  late final FirebaseAuth _auth;
  late final UserRepository _userRepo;
  late Future<UserModel?> futureUser;
  late UserModel user;
  bool _canSubmit = false;
  bool _hydrated = false;

  final _phoneCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  final _phoneKey = GlobalKey<FormFieldState>();
  final _nameKey = GlobalKey<FormFieldState>();
  final _addressKey = GlobalKey<FormFieldState>();
  final _dateKey = GlobalKey<FormFieldState>();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _dateCtrl.dispose();
    _addressCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _userRepo = UserRepository();
    futureUser = _userRepo.getUser(_auth.currentUser!.uid);
  }

  void _hydrateOnce(UserModel u) {
    if (_hydrated) return;
    _phoneCtrl.text   = u.phone;
    _addressCtrl.text = u.address ?? '';
    _dateCtrl.text    = u.dob!= null ? DateFormat('dd/MM/yyyy').format(u.dob!) : '';
    _nameCtrl.text = u.fullName;
    _emailCtrl.text = u.email;
    _hydrated = true;
    user = u;
  }

  void _validateOnly(GlobalKey<FormFieldState> key) {
    key.currentState?.validate();
    _recomputeCanSubmit();
  }

  void _recomputeCanSubmit() {
    final phoneHasError = _phoneKey.currentState?.hasError ?? true;

    bool phoneOk, addressOk, nameOk;

    if (phoneHasError || _phoneCtrl.text.isEmpty) {
      phoneOk = false;
    } else {
      phoneOk = true;
    }

    if (_nameCtrl.text.isEmpty) {
      nameOk = false;
    } else {
      nameOk = true;
    }

    if (_addressCtrl.text.isEmpty) {
      addressOk = false;
    } else {
      addressOk = true;
    }

    final isValid = phoneOk && addressOk && nameOk && hasChange();

    if (_canSubmit != isValid) {
      setState(() => _canSubmit = isValid);
    }
  }

  bool hasChange(){
    if(_nameCtrl.text != user.fullName){
      return true;
    }
    else if(_emailCtrl.text != user.email){
      return true;
    }
    else if(_phoneCtrl.text != user.phone){
      return true;
    }
    else if(_addressCtrl.text != user.address){
      return true;
    }
    else if(user.dob == null){
      if(_dateCtrl.text != ''){
        return true;
      }
      else {
        return false;
      }
    }
    else if(user.dob != null){
      if(_dateCtrl.text != DateFormat('dd/MM/yyyy').format(user.dob!)){
        return true;
      }
      else {
        return false;
      }
    }
    else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Cập nhật hồ sơ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),),
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new_rounded, size: 19,)),
      ),
      body: SafeArea(
          child: BlocBuilder<UserCubit, UserState>(
              builder: (context, state){
                if(state.loading){
                  return Center(child: CircularProgressIndicator(color: Colors.blue,));
                }
                if(state.error != null){
                  return Center(child: Text('Error: ${state.error.toString()}'),);
                }

                _hydrateOnce(state.user!);

                return Column(
                    children: [
                      const SizedBox(height: 10,),
                      PictureAndName(user: state.user!,),
                      const SizedBox(height: 30,),
                      UserNameField(nameCtrl: _nameCtrl, onChanged: (_) {_validateOnly(_nameKey); }, nameKey: _nameKey,),
                      const SizedBox(height: 5,),
                      PhoneField(phoneCtrl: _phoneCtrl, phoneKey: _phoneKey, onChanged: (_) { _validateOnly(_phoneKey);},),
                      const SizedBox(height: 5,),
                      EmailField(emailCtrl: _emailCtrl,),
                      const SizedBox(height: 5,),
                      AddressField(addressCtrl: _addressCtrl, addressKey: _addressKey, onChanged: (_) {_validateOnly(_addressKey); },),
                      const SizedBox(height: 5,),
                      BirthOfDateField(dobCtrl: _dateCtrl, onChanged: () {_validateOnly(_dateKey); }, dobKey: _dateKey,),
                      const SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ElevatedButton(
                          onPressed: _canSubmit ? () async {
                            final details = _dateCtrl.text.split('/');
                            final updatedDate = DateTime(int.parse(details[2]), int.parse(details[1]), int.parse(details[0]));

                            final updatedUser = user.copyWith(address: _addressCtrl.text, fullName: _nameCtrl.text, phone: _phoneCtrl.text, dob: updatedDate);
                            context.read<UserCubit>().updateUser(context, updatedUser);
                          } : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: Size(double.infinity, 45),
                            maximumSize: Size(double.infinity, 100),
                          ),
                          child: const Text('Cập nhật', style: TextStyle(color: Colors.white, fontSize: 16),),
                        ),
                      )
                    ]
                );
              }
          )
      ),
    );
  }
}


class PictureAndName extends StatelessWidget {
  const PictureAndName({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/user-picture2.png',
          height: 140,
          width: 140,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 12,),
      ],
    ) ;
  }
}

class UserNameField extends StatefulWidget {
  const UserNameField({super.key, required this.nameCtrl, required this.nameKey, required this.onChanged, });
  final TextEditingController nameCtrl;
  final GlobalKey<FormFieldState> nameKey;
  final ValueChanged<String> onChanged;

  @override
  State<UserNameField> createState() => _UserNameFieldState();
}

class _UserNameFieldState extends State<UserNameField> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 5),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue.shade50
            ),
            child: const Icon(Icons.person_outline, size: 24, color: Colors.blue,),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextFormField(
              readOnly: false,
              key: widget.nameKey,
              controller: widget.nameCtrl,
              decoration: InputDecoration(
                labelText: 'Họ Và Tên',
                border: InputBorder.none,
              ),
              onChanged: (v) {
                widget.onChanged(v);
              },
            ),
          )
        ],
      ),
    );
  }
}

class PhoneField extends StatefulWidget {
  const PhoneField({super.key, required this.phoneCtrl, required this.phoneKey, required this.onChanged,});

  final TextEditingController phoneCtrl;
  final GlobalKey<FormFieldState> phoneKey;
  final ValueChanged<String> onChanged;

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 5),
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue.shade50
            ),
            child: const Icon(Icons.phone_outlined, size: 24, color: Colors.blue,),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              readOnly: false,
              controller: widget.phoneCtrl,
              key: widget.phoneKey,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Số điện thoại',
                border: InputBorder.none,

              ),
              validator: (value){
                if(value == null || value.isEmpty ){
                  return "Vui lòng nhập số điện thoại";
                }
                if(!RegExp(r'^(?:\+84|0)(?:\d{9})$').hasMatch(value)){
                  return "Số điện thoại không hợp lệ";
                }
                return null;
              },
              onChanged: (v){
                widget.onChanged(v);
              },
            ),
          ),

        ],
      ),
    );
  }
}

class EmailField extends StatefulWidget {
  const EmailField({super.key, required this.emailCtrl,});
  final TextEditingController emailCtrl;

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 5),
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue.shade50
            ),
            child: const Icon(Icons.email_outlined, size: 24, color: Colors.blue,),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextFormField(
              readOnly: true,
              keyboardType: TextInputType.emailAddress,
              controller: widget.emailCtrl,
              decoration: InputDecoration(
                  labelText: 'Email',
                  border: InputBorder.none
              ),
              validator: (value){
                if(value == null || value.isEmpty ){
                  return "Vui lòng nhập email";
                }
                if(!RegExp(r'^\w+@gmail\.com').hasMatch(value)){
                  return "Email không hợp lệ";
                }
                return null;
              },
            ),
          )
        ],
      ),
    );
  }
}

class AddressField extends StatefulWidget {
  const AddressField({super.key, required this.addressCtrl, required this.addressKey, required this.onChanged, });
  final TextEditingController addressCtrl;
  final GlobalKey<FormFieldState> addressKey;
  final ValueChanged<String> onChanged;

  @override
  State<AddressField> createState() => _AddressFieldState();
}

class _AddressFieldState extends State<AddressField> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            margin: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue.shade50
            ),
            child: const Icon(Icons.location_on_outlined, size: 24, color: Colors.blue,),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.text,
              readOnly: false,
              controller: widget.addressCtrl,
              decoration: InputDecoration(
                  labelText: 'Địa chỉ',
                  border: InputBorder.none
              ),
              key: widget.addressKey,
              validator: (value){
                if(value == null || value.isEmpty ){
                  return "Vui lòng nhập địa chỉ";
                }
                return null;
              },
              onChanged: (v){
                widget.onChanged(v);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BirthOfDateField extends StatefulWidget {
  const BirthOfDateField({super.key, required this.dobCtrl, required this.dobKey, required this.onChanged,});
  final TextEditingController dobCtrl;
  final GlobalKey<FormFieldState> dobKey;
  final VoidCallback onChanged;

  @override
  State<BirthOfDateField> createState() => _BirthOfDateFieldState();
}

class _BirthOfDateFieldState extends State<BirthOfDateField> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 5),
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue.shade50
            ),
            child: const Icon(Icons.person_outline, size: 24, color: Colors.blue,),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextFormField(
              readOnly: true,
              controller: widget.dobCtrl,
              key: widget.dobKey,
              decoration: InputDecoration(
                  labelText: 'Ngày sinh',
                  border: InputBorder.none
              ),
              onTap: () async {
                final result = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    currentDate: DateTime.now()
                );

                if(result != null){
                  setState(() {
                    widget.dobCtrl.text = DateFormat('dd/MM/yyyy').format(result);
                    widget.onChanged();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
