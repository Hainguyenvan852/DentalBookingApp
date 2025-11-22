import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../data/model/payment_model.dart';
import '../../../../data/repository/payment_repository.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  late final PaymentRepository _paymentRepo;

  @override
  void initState() {
    super.initState();
    _paymentRepo = PaymentRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Lịch sử thanh toán', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
        centerTitle: true,
        shape: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new_rounded, size: 19,)),
      ),
      body: SafeArea(
          child: FutureBuilder(
              future: _paymentRepo.getAll('fjG3DhpLVtMKXE0eP27w0O3SbYB2'),
              builder: (context, snap){
                if(snap.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if(snap.hasError){
                  return Center(child: Text('Error: ${snap.error}'),);
                }
                if(snap.data == null){
                  return const Center(
                    child: Text('Bạn chưa có giao dịch nào'),
                  );
                }
                return TransactionList(payments: snap.data!,);
              }
          )
      ),
    );
  }
}

class TransactionList extends StatelessWidget {
  const TransactionList({super.key, required this.payments});
  final List<Payment> payments;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (_, index) {
          return TransactionItem(payment: payments[index],);
        },
        separatorBuilder: (_, index) {
          return const SizedBox(height: 6,);
        },
        itemCount: payments.length
    );
  }
}

class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key, required this.payment});
  final Payment payment;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(left: 8,),
              child: Text(DateFormat('dd/MM/yyyy').format(payment.createdAt), style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),)),
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade700,
              ),
              child: payment.method == 'banking' ? Icon(CupertinoIcons.creditcard, color: Colors.white, size: 20,) : Icon(Icons.money, color: Colors.white, size: 20,),
            ),
            title: Text(_methodFormat(payment.method), style: TextStyle(fontSize: 13),),
            subtitle: Text(payment.description, style: TextStyle(fontSize: 13, color: Colors.grey),),
            trailing: Text(currency.format(payment.amount), style: TextStyle(fontSize: 13, )),
            minTileHeight: 65,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
          )
        ],
      ),
    );
  }
}

String _methodFormat(String pm){
  if(pm ==  'banking'){
    return 'Chuyển khoản';
  } else{
    return 'Tiền mặt';
  }
}


