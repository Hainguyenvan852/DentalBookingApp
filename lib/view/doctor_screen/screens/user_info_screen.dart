import 'package:dental_booking_app/data/model/dentist_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.dentist});
  final Dentist dentist;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final _phoneCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();



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
    _nameCtrl.text = widget.dentist.name;
    _emailCtrl.text = widget.dentist.email;
    _phoneCtrl.text = widget.dentist.phone;
    _addressCtrl.text = widget.dentist.address;
    _dateCtrl.text = DateFormat('dd/MM/yyyy').format(widget.dentist.dob);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Thông tin cá nhân', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back),),
      ),
      body: SafeArea(
          child: Column(
              children: [
                const SizedBox(height: 10,),
                _pictureAndName(),
                const SizedBox(height: 30,),
                _userNameField(),
                const SizedBox(height: 5,),
                _phoneField(),
                const SizedBox(height: 5,),
                _emailField(),
                const SizedBox(height: 5,),
                _addressField(),
                const SizedBox(height: 5,),
                _birthOfDateField(),
              ]
          )
      )
    );
  }

  Widget _pictureAndName() {
    return widget.dentist.sex ?
    Column(
      children: [
        Image.asset(
          'assets/images/men_doctor.png',
          height: 140,
          width: 140,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 12,),
      ],
    ) :
    Column(
      children: [
        Image.asset(
          'assets/images/women_doctor.png',
          height: 140,
          width: 140,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 12,),
      ],
    );
  }

  Widget _userNameField(){
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
              readOnly: true,
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: 'Họ Và Tên',
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _phoneField(){
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
              readOnly: true,
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Số điện thoại',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emailField() {
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
              controller: _emailCtrl,
              decoration: InputDecoration(
                  labelText: 'Email',
                  border: InputBorder.none
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _addressField(){
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
              readOnly: true,
              controller: _addressCtrl,
              decoration: InputDecoration(
                  labelText: 'Địa chỉ',
                  border: InputBorder.none
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _birthOfDateField() {
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
            child: const Icon(
              Icons.person_outline, size: 24, color: Colors.blue,),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextFormField(
              readOnly: true,
              controller: _dateCtrl,
              decoration: InputDecoration(
                  labelText: 'Ngày sinh',
                  border: InputBorder.none
              ),
            ),
          )
        ],
      ),
    );
  }
}


