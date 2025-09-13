import 'package:dental_booking_app/otp_verify_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget{

  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage>{

  final _nameKey = GlobalKey<FormFieldState>();
  final _phoneKey = GlobalKey<FormFieldState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  bool isValid = false;

  void checkFormValid(){
    final nameValid = _nameKey.currentState?.validate() ?? false;
    final phoneValid = _phoneKey.currentState?.validate() ?? false;
    final emailValid = _emailKey.currentState?.validate() ?? false;
    final pwValid = _passwordKey.currentState?.validate() ?? false;

    setState(() {
      isValid = nameValid && phoneValid && emailValid && pwValid;
    });
  }

  @override
  void initState() {
    super.initState();

    _nameCtrl.addListener(checkFormValid);
    _phoneCtrl.addListener(checkFormValid);
    _emailCtrl.addListener(checkFormValid);
    _passwordCtrl.addListener(checkFormValid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 70,
            title: Text("Đăng ký",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            shape: RoundedRectangleBorder(side: BorderSide(width: 0.7, color: Colors.grey))
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  TextFieldBox(title: 'Họ và tên', icon: Icons.person, hintText: "Nhập tên", important: true, isPhone: false, obscure: false, controller: _nameCtrl, formkey: _nameKey,),
                  TextFieldBox(title: 'Số điện thoại', icon: Icons.phone, hintText: "Nhập số điện thoại", important: true, isPhone: true, obscure: false, controller: _phoneCtrl, formkey: _phoneKey,),
                  TextFieldBox(title: 'Email', icon: Icons.email, hintText: "Nhập email", important: true, isPhone: false, obscure: false, controller: _emailCtrl, formkey: _emailKey,),
                  TextFieldBox(title: 'Địa chỉ', icon: Icons.home, hintText: "Nhập địa chỉ", important: false, isPhone: false, obscure: false, controller: TextEditingController(), formkey: GlobalKey<FormFieldState>(),),
                  TextFieldBox(title: 'Mật khẩu', icon: Icons.password, hintText: "Nhập mật khẩu", important: true, isPhone: false, obscure: true, controller: _passwordCtrl, formkey: _passwordKey,),
                  SelectBranchField(title: "Chi nhánh"),
                  DatePickerField(title: "Ngày sinh")
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 40),
                child: RegisterButton(isValid: isValid,)
            ),
          ],
        ),
    );
  }
}


class RegisterButton extends StatefulWidget {

  bool isValid;

  WidgetStatesController controller = WidgetStatesController();

  RegisterButton({super.key, required this.isValid,});

  @override
  State<StatefulWidget> createState() {
    return _RegisterButtonState();
  }
}

class _RegisterButtonState extends State<RegisterButton>{

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
          onPressed: (){
            widget.isValid ? () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => OtpVerifyPage(email: "09777132",))
              );
            } : null;
          },
          statesController: widget.controller,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
            backgroundColor: widget.isValid ? Colors.lightBlue : Colors.grey,
            foregroundColor: Colors.white
          ),
          child: Text("Đăng ký", style: TextStyle(fontSize: 20),)
      ),
    );
  }
}

class TextFieldBox extends StatefulWidget{

  final String title, hintText;
  final IconData icon;
  final bool important, isPhone, obscure;
  final TextEditingController controller;
  final GlobalKey<FormFieldState> formkey;

  const TextFieldBox({super.key, required this.title, required this.icon, required this.hintText, required this.important, required this.isPhone, required this.obscure, required this.controller, required this.formkey, });

  @override
  State<StatefulWidget> createState() {
    return TextFieldBoxState();
  }
}

class TextFieldBoxState extends State<TextFieldBox>{

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
      child: SizedBox(
        height: 110,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Text(widget.title, style: TextStyle(fontSize: 20,), textAlign: TextAlign.start,),
                  ),
                  Text(widget.important == true ? '*': '',
                    style: TextStyle(fontSize: 20, color: Colors.red, ),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: SizedBox(
                height: 55, // Chỉnh sửa kích thước của Container
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right:15),
                      child: Icon(widget.icon,),
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: TextFormField(
                          key: widget.key,
                          controller: widget.controller,
                          obscureText: widget.obscure,
                          keyboardType: (widget.isPhone == true ? TextInputType.phone : TextInputType.text),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: widget.hintText,
                          ),
                          style: TextStyle(fontSize: 18),
                          validator: (value){
                            if((value == null && widget.important)|| (value!.isEmpty && widget.important)){
                              return "Vui lòng nhập ${widget.title.toLowerCase()}";
                            }
                            if(!RegExp(r'^[A-Za-zÀ-Ỹà-ỹ\s]{2,50}$').hasMatch(value) && widget.title == 'Họ và tên'){
                              return "Họ và tên không hợp lệ";
                            }
                            else if(!RegExp(r'^(?:\+84|0)(?:\d{9})$').hasMatch(value) && widget.title == 'Số điện thoại'){
                              return "Số điện thoại không hợp lệ";
                            }
                            else if(!RegExp(r'^\w+@gmail\.com').hasMatch(value) && widget.title == 'Email'){
                              return "Email không hợp lệ";
                            }
                            else if(!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,16}$').hasMatch(value) && widget.title == 'Mật khẩu'){
                              return "Cần ít nhất 8 kí tự, 1 kí tự đặc biệt, 1 kí tự viết hoa và 1 số";
                            }
                            return null;
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


}

class SelectBranchField extends StatefulWidget{
  final String title;
  const SelectBranchField({super.key, required this.title, });

  @override
  State<StatefulWidget> createState() {
    return SelectBranchFieldState();
  }

}

class SelectBranchFieldState extends State<SelectBranchField>{

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
        child: SizedBox(
          height: 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Text(widget.title, style: TextStyle(fontSize: 20,), textAlign: TextAlign.start,),
                    ),
                    Text('*',
                      style: TextStyle(fontSize: 20, color: Colors.red, ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: SizedBox(
                  height: 55, // Chỉnh sửa kích thước của Container
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right:15),
                        child: Icon(Icons.location_on,),
                      ),
                      Container(
                        height: 30,
                        width: 1,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: DropdownButtonFormField(
                            value: selectedValue,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            decoration: InputDecoration(
                                hintText: "Chọn chi nhánh",
                                border: InputBorder.none
                            ),
                            items: ['Chi nhánh Cầu Giấy', 'Chi nhánh Xuân Thủy', 'Chi nhánh Đống Đa'].map((item){
                              return DropdownMenuItem(
                                  value: item,
                                  child: Text(item, style: TextStyle(fontSize: 18),));
                            }).toList(),
                            onChanged: (value){
                              setState(() {
                                selectedValue = value;
                              });
                            },
                            validator: (value){
                              if(selectedValue == null){
                                return 'Vui lòng chọn chi nhánh';
                              }
                              return null;
                            },
                          )
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
    );
  }
}

class DatePickerField extends StatefulWidget{
  final String title;
  const DatePickerField({super.key, required this.title});

  @override
  State<StatefulWidget> createState() {
    return DatePickerFieldState();
  }
}

class DatePickerFieldState extends State<DatePickerField>{
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    if (selectedDate != null){
        _dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
        child: SizedBox(
          height: 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Text(widget.title, style: TextStyle(fontSize: 20,), textAlign: TextAlign.start,),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: SizedBox(
                  height: 55, // Chỉnh sửa kích thước của Container
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right:15),
                        child: Icon(Icons.date_range,),
                      ),
                      Container(
                        height: 30,
                        width: 1,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: TextFormField(
                              controller: _dateController,
                              readOnly: true,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                hintText: 'Chọn ngày sinh',
                                border: InputBorder.none,
                              ),
                              onTap: (){
                                FocusScope.of(context).requestFocus(FocusNode());
                                _selectDate(context);
                              }
                          )
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}

