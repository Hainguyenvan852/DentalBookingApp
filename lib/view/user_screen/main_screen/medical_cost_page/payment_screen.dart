import 'package:dental_booking_app/data/model/installment_schedule_model.dart';
import 'package:dental_booking_app/data/model/invoice_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatefulWidget {
  final InstallmentSchedule item;
  final Invoice invoice;
  const PaymentScreen({super.key, required this.item, required this.invoice});

  @override
  State<PaymentScreen> createState() =>
      _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  String _selectedPaymentMethod = 'visa';

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19,), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildServiceInfoCard(item: widget.invoice),
            const SizedBox(height: 24),

            _buildCurrentInstallmentCard(),
            const SizedBox(height: 24),

            _buildPaymentMethodSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomPayButton(),
    );
  }

  Widget _buildServiceInfoCard({required Invoice item}) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blue.shade50,
              child: const Icon(Icons.medical_services_outlined, color: Colors.blue, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCurrentInstallmentCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade500),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thanh toán đợt ${widget.item.installmentNumber}',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue),
          ),
          const SizedBox(height: 16),
          const Text(
            'SỐ TIỀN ĐỢT NÀY',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            formatCurrency(widget.item.amountDue.toDouble()),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chọn phương thức thanh toán',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          color: Colors.white,
          child: Column(
            children: [
              _buildPaymentOption(
                value: 'visa',
                logo: Icons.credit_card,
                logoColor: Colors.blue[800],
                title: 'Visa **** 1234',
                subtitle: 'Thẻ mặc định',
              ),
              const Divider(height: 1, indent: 16, endIndent: 16),
              _buildPaymentOption(
                value: 'momo',
                logo: Icons.account_balance_wallet,
                logoColor: Colors.pink,
                title: 'Ví MoMo',
                subtitle: 'Ví điện tử',
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Card(
          color: Colors.white,
          child: ListTile(
            leading: Icon(Icons.add_circle_outline, color: Colors.blue[700]),
            title: Text(
              'Thêm thẻ/ví mới',
              style: TextStyle(
                  color: Colors.blue[700], fontWeight: FontWeight.w500),
            ),
            onTap: () {
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required String value,
    required IconData logo,
    Color? logoColor,
    required String title,
    required String subtitle,
  }) {
    return RadioListTile<String>(
      value: value,
      groupValue: _selectedPaymentMethod,
      onChanged: (newValue) {
        setState(() {
          _selectedPaymentMethod = newValue!;
        });
      },
      secondary: Icon(logo, color: logoColor, size: 30),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      activeColor: const Color(0xFF00A79D),
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  Widget _buildBottomPayButton() {

    void _onPaidSuccess() {
      Navigator.pop(context, true);
    }

    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {

        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00A79D),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Thanh toán',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}