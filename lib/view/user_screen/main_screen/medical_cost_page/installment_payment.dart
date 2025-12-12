import 'package:dental_booking_app/data/model/invoice_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../data/repository/installment_schedule_repository.dart';
import '../../../../data/repository/invoice_repository.dart';
import '../../../../logic/installment_schedule_cubit.dart';
import '../../../../logic/invoice_cubit.dart';
import 'installment_detail.dart';

class InstallmentPayment extends StatefulWidget {
  const InstallmentPayment({super.key});

  @override
  State<InstallmentPayment> createState() => _InstallmentPaymentState();
}

class _InstallmentPaymentState extends State<InstallmentPayment> with SingleTickerProviderStateMixin{
  final currency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0);

  final invoiceRepo = InvoiceRepository();
  final instalmentRepo = InstallmentScheduleRepository();

  late final TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán trả góp', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back),),
      ),
      backgroundColor: Colors.grey.shade100,
      body: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (_) => invoiceRepo),
          RepositoryProvider(create: (_) => instalmentRepo),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => InvoiceCubit(invoiceRepo)..loadAll(),),
            BlocProvider(create: (_) => InstallmentScheduleCubit(instalmentRepo),),
          ],
          child: SafeArea(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  StatusTabBar(),
                  const SizedBox(height: 16),
                  const Expanded(
                    child: TabBarView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        PayingList(),
                        CompletedList()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StatusTabBar extends StatelessWidget {
  const StatusTabBar({super.key});
  final Color selected = const Color(0xFF1E88E5);
  final Color unselected = const Color(0xFF9AA3AE);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: const Color(0xFFEAECEF)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 2,
                height: double.infinity,
                color: Colors.grey.shade100,
              ),
            ),
          ),
          TabBar(
            splashBorderRadius: BorderRadius.circular(24),
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: const EdgeInsets.symmetric(horizontal: 18),
            labelColor: selected,
            unselectedLabelColor: unselected,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            indicator: UnderlineTabIndicator(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(width: 2.5, color: Color(0xFF1E88E5)),
              insets: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            ),
            tabs: const [
              Tab(text: 'Đang trả góp'),
              Tab(text: 'Đã hoàn tất'),
            ],
          ),
        ],
      ),
    );
  }
}

class PayingList extends StatelessWidget {
  const PayingList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceCubit, InvoiceState>(
        builder: (context, state){
          if(state.loading){
            return Center(
              child: CircularProgressIndicator(color: Colors.blue,),
            );
          }
          if(state.error != null){
            return Text(state.error.toString());
          }

          final invoiceList = state.invoices.where((i) => i.paymentType == 'installment' && i.amountPaid != i.totalAmount).toList();

          if(invoiceList.isEmpty){
            return Center(
              child: Text('Hiện không có gói trả góp nào'),
            );
          }
          return ListView.separated(
              itemBuilder: (context, i){
                return PayingItem(invoice: invoiceList[i],);
              },
              separatorBuilder:(context, i){
                return const SizedBox(height: 10,);
              },
              itemCount: invoiceList.length
          );
        }
    );
  }
}

class PayingItem extends StatelessWidget {
  const PayingItem({super.key, required this.invoice});
  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0);

    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(15)
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8)
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.medical_services_outlined, size: 20,color: Colors.blue,),
                const SizedBox(width: 10,),
                Text(invoice.description, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Text('Đã trả:  ', style: TextStyle(fontSize: 14, color: Colors.grey,),),
                Text('${currency.format(invoice.amountPaid)} / ${currency.format(invoice.totalAmount)}', style: TextStyle(fontWeight: FontWeight.w500),)
              ],
            ),
            const SizedBox(height: 10,),
            LinearPercentIndicator(
              progressColor: Colors.blue,
              width: 250,
              lineHeight: 12,
              barRadius: Radius.circular(5),
              backgroundColor: Colors.blue.shade50,
              fillColor: Colors.white,
              percent: invoice.amountPaid/invoice.totalAmount,
              padding: EdgeInsets.only(right: 10),
              trailing: Text('${(invoice.amountPaid / invoice.totalAmount * 100).round()} %', style: TextStyle(fontWeight: FontWeight.w500),),
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Icon(Icons.calendar_month_rounded, size: 20,color: Colors.blue,),
                const SizedBox(width: 10,),
                Text('Xem chi tiết', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                Expanded(child: const SizedBox()),
                IconButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => MultiRepositoryProvider(
                        providers: [
                          RepositoryProvider.value(value: context.read<InvoiceRepository>()),
                          RepositoryProvider.value(value: context.read<InstallmentScheduleRepository>()),
                        ],
                        child: MultiBlocProvider(
                          providers: [
                            BlocProvider.value(value: context.read<InvoiceCubit>()..select(invoice)),
                            BlocProvider.value(value: context.read<InstallmentScheduleCubit>()..loadAll(invoice.id!)),
                          ],
                          child: InstallmentDetail(invoice: invoice,)
                        ),
                      ),
                    ));
                  }, 
                  icon: Icon(Icons.arrow_forward_ios_rounded, size: 19, color: Colors.blue,)
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CompletedList extends StatelessWidget {
  const CompletedList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceCubit, InvoiceState>(
        builder: (context, state){
          if(state.loading){
            return Center(
              child: CircularProgressIndicator(color: Colors.blue,),
            );
          }
          if(state.error != null){
            return Text(state.error.toString());
          }

          final invoiceList = state.invoices.where((i) => i.paymentType == 'completed' && i.amountPaid == i.totalAmount).toList();

          if(invoiceList.isEmpty){
            return Center(
              child: Text('Chưa có giao dịch nào hoàn tất', style: TextStyle(fontSize: 15),),
            );
          }
          return ListView.separated(
              itemBuilder: (context, i){
                return CompletedItem(invoice: invoiceList[i],);
              },
              separatorBuilder:(context, i){
                return const SizedBox(height: 10,);
              },
              itemCount: invoiceList.length
          );
        }
    );
  }
}

class CompletedItem extends StatelessWidget {
  final Invoice invoice;
  const CompletedItem({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0);
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(15)
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8)
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.medical_services_outlined, size: 20,color: Colors.blue,),
                const SizedBox(width: 10,),
                Text('Gói niềng răng thẩm mỹ', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Text('Đã trả:  ', style: TextStyle(fontSize: 14, color: Colors.grey,),),
                Text('${currency.format(invoice.amountPaid)} / ${currency.format(invoice.totalAmount)}', style: TextStyle(fontWeight: FontWeight.w500),)
              ],
            ),
            const SizedBox(height: 10,),
            LinearPercentIndicator(
              progressColor: Colors.blue,
              width: 250,
              lineHeight: 12,
              barRadius: Radius.circular(5),
              backgroundColor: Colors.blue.shade50,
              fillColor: Colors.white,
              percent: 1,
              padding: EdgeInsets.only(right: 10),
              trailing: Text('100 %', style: TextStyle(fontWeight: FontWeight.w500),),
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Icon(Icons.check_circle_outline, size: 20, color: Colors.green,),
                const SizedBox(width: 10,),
                Text('Đã hoàn thành', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.green),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
