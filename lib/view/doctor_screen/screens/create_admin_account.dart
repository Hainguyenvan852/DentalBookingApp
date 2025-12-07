import 'package:flutter/material.dart';

class AddAdminScreen extends StatefulWidget {
  const AddAdminScreen({super.key});

  @override
  State<AddAdminScreen> createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends State<AddAdminScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đang xử lý tạo tài khoản...'),
          backgroundColor: Colors.green,
        ),
      );
      
      print("Họ tên: ${_nameController.text}");
      print("SĐT: ${_phoneController.text}");
      print("Email: ${_emailController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), 
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 19),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Thêm tài khoản Admin",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Họ tên"),
              _buildTextField(
                controller: _nameController,
                hintText: "Nhập họ và tên",
                validator: (value) {
                  if (value == null || value.isEmpty) return "Vui lòng nhập họ tên";
                  return null;
                },
              ),

              _buildLabel("Số điện thoại"),
              _buildTextField(
                controller: _phoneController,
                hintText: "Nhập số điện thoại",
                inputType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Vui lòng nhập số điện thoại";

                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return "Số điện thoại phải đủ 10 số";
                  }
                  return null;
                },
              ),

              _buildLabel("Email"),
              _buildTextField(
                controller: _emailController,
                hintText: "Nhập email",
                inputType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Vui lòng nhập email";
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value)) {
                    return "Email không hợp lệ";
                  }
                  return null;
                },
              ),

              _buildLabel("Mật khẩu"),
              _buildTextField(
                controller: _passController,
                hintText: "Nhập mật khẩu",
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Vui lòng nhập mật khẩu";
                  if (value.length < 8) return "Mật khẩu phải có ít nhất 8 ký tự";
                  return null;
                },
              ),

              _buildLabel("Xác nhận mật khẩu"),
              _buildTextField(
                controller: _confirmPassController,
                hintText: "Nhập lại mật khẩu",
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Vui lòng xác nhận mật khẩu";
                  if (value != _passController.text) return "Mật khẩu không trùng khớp";
                  return null;
                },
              ),

              _buildLabel("Ngày sinh"),
              _buildTextField(
                controller: _dobController,
                hintText: "DD/MM/YYYY",
                validator: (value) {
                  if (value == null || value.isEmpty) return "Vui lòng nhập ngày sinh";
                  return null;
                },
                suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
              ),

              _buildLabel("Vai trò"),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  initialValue: "Admin",
                  readOnly: true,
                  style: const TextStyle(color: Colors.grey),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              _buildLabel("Địa chỉ"),
              _buildTextField(
                controller: _addressController,
                hintText: "Nhập địa chỉ",
                validator: (value) {
                  if (value == null || value.isEmpty) return "Vui lòng nhập địa chỉ";
                  return null;
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Tạo tài khoản",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
    bool isPassword = false,
    TextInputType inputType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: inputType,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}