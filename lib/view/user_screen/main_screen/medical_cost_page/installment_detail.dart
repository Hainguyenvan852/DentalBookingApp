import 'package:dental_booking_app/data/model/installment_schedule_model.dart';
import 'package:dental_booking_app/data/repository/installment_schedule_repository.dart';
import 'package:dental_booking_app/data/repository/invoice_repository.dart';
import 'package:dental_booking_app/logic/installment_schedule_cubit.dart';
import 'package:dental_booking_app/logic/invoice_cubit.dart';
import 'package:dental_booking_app/view/user_screen/main_screen/medical_cost_page/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';
import '../../../../data/model/invoice_model.dart';



class InstallmentDetail extends StatefulWidget {
  const InstallmentDetail({super.key, required this.invoice});
  final Invoice invoice;
  @override
  State<InstallmentDetail> createState() => _InstallmentDetailState();
}

class _InstallmentDetailState extends State<InstallmentDetail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin trả góp',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ListView(
              children: [
                const SizedBox(height: 20),
                paymentInfo(context),
                const SizedBox(height: 15),
                installmentCard(context: context, invoice: widget.invoice),
                const SizedBox(height: 16),
                HistoryAndIncomingSchedule()
              ],
            ),
          )
      ),
    );
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  const MeasureSize({super.key, required this.onChange, required Widget child})
      : super(child: child);
  final ValueChanged<Size> onChange;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMeasureSize(onChange);

  @override
  void updateRenderObject(BuildContext context, covariant _RenderMeasureSize ro) {
    ro.onChange = onChange;
  }
}

class _RenderMeasureSize extends RenderProxyBox {
  _RenderMeasureSize(this.onChange);
  ValueChanged<Size> onChange;
  Size _oldSize = Size.zero;

  @override
  void performLayout() {
    super.performLayout();
    if (child != null) {
      final newSize = child!.size;
      if (_oldSize != newSize) {
        _oldSize = newSize;
        WidgetsBinding.instance.addPostFrameCallback((_) => onChange(newSize));
      }
    }
  }
}

class HistoryAndIncomingSchedule extends StatefulWidget {
  const HistoryAndIncomingSchedule({super.key});
  @override
  State<HistoryAndIncomingSchedule> createState() =>
      _HistoryAndIncomingScheduleState();
}

class _HistoryAndIncomingScheduleState extends State<HistoryAndIncomingSchedule> with TickerProviderStateMixin {
  late final  TabController _tab = TabController(length: 2, vsync: this);


  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  Widget _incoming() => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: incomingPaymentList(),
  );

  Widget _history() => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: installmentHistoryList(),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: TabBar(
              controller: _tab,
              indicatorSize: TabBarIndicatorSize.tab,
              splashBorderRadius: BorderRadius.circular(12),
              dividerColor: Colors.transparent,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey[600],
              labelStyle:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              unselectedLabelStyle:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(width: 2, color: Color(0xFF1E88E5)),
                insets: EdgeInsets.fromLTRB(24, 0, 24, 0),
              ),
              tabs: const [
                Tab(text: 'Lịch sắp tới'),
                Tab(text: 'Lịch sử thanh toán'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

        AnimatedBuilder(
          animation: _tab,
          builder: (context, _) {
            return AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: MeasureSize(
                onChange: (_) {},
                child: IndexedStack(
                  index: _tab.index,
                  children: [
                    if (_tab.index == 0)
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _incoming(),
                      )
                    else
                      const SizedBox.shrink(),

                    if (_tab.index == 1)
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _history(),
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

Widget paymentInfo(BuildContext context) {
  final currency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0);

  return BlocBuilder<InvoiceCubit, InvoiceState>(builder: (context, state) {
    if (state.loading) {
      return const Center(child: CircularProgressIndicator(color: Colors.blue));
    }
    if (state.error != null) {
      return Center(child: Text('Error: ${state.error}'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CircularPercentIndicator(
            progressColor: Colors.blue.shade800,
            backgroundColor: Colors.blue.shade200,
            radius: 90,
            lineWidth: 22,
            percent: state.selected!.amountPaid / state.selected!.totalAmount,
            center: Text(
              '${(state.selected!.amountPaid / state.selected!.totalAmount * 100).round()} %',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 25, color: Colors.blue),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text('Tổng số tiền: ${currency.format(state.selected!.totalAmount)}',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text('Đã thanh toán: ${currency.format(state.selected!.amountPaid)}',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text('Còn lại: ${currency.format(state.selected!.balance)}',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
        ),
      ],
    );
  });
}

Widget installmentCard({required BuildContext context, required Invoice invoice}) {
  Future<void> _goToPayment(InstallmentSchedule item) async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: context.read<InvoiceRepository>()),
            RepositoryProvider.value(value: context.read<InstallmentScheduleRepository>()),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<InvoiceCubit>()),
              BlocProvider.value(value: context.read<InstallmentScheduleCubit>()),
            ],
            child: PaymentScreen(item: item, invoice: invoice,),
          ),
        ),
      ),
    );

    if (ok == true) {
      final invoiceId = invoice.id;
      context.read<InvoiceCubit>().reload(invoiceId);
      context.read<InstallmentScheduleCubit>().loadAll(invoiceId);
    }
  }

  final currency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0);

  return BlocBuilder<InstallmentScheduleCubit, InstallmentScheduleState>(
    builder: (context, state) {
      if (state.loading) {
        return const Center(child: CircularProgressIndicator(color: Colors.blue));
      }
      if (state.error != null) {
        return Center(child: Text('Error: ${state.error}'));
      }

      final nowIn = _installmentNow(state.installmentSchedules);
      if (nowIn == null) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 15, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(Icons.notifications,
                        color: Colors.blue, size: 20)),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(
                            text: 'ĐỢT THANH TOÁN HIỆN TẠI',
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            children: [
                              TextSpan(
                                text:
                                ' (Đợt ${nowIn.installmentNumber}/${state.installmentSchedules.length})',
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                              )
                            ])),
                    const SizedBox(height: 8),
                    Text(
                      currency.format(nowIn.amountDue),
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Hạn chót: ${DateFormat('dd/MM/yyyy').format(nowIn.dueDate)}',
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}

Widget incomingPaymentList() {
  return BlocBuilder<InstallmentScheduleCubit, InstallmentScheduleState>(
    builder: (context, state) {
      if(state.loading){
        return Center(
          child: CircularProgressIndicator(color: Colors.blue,),
        );
      }
      if(state.error != null){
        return Text(state.error.toString());
      }
      final incoming = state.installmentSchedules
          .where((i) => i.status == 'pending')
          .toList();

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListView.separated(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: incoming.length,
          itemBuilder: (_, i) => incomingPaymentItem(incoming[i]),
          separatorBuilder: (_, __) =>
          const Divider(height: 10, color: Colors.grey),
        ),
      );
    },
  );
}

Widget incomingPaymentItem(InstallmentSchedule i) {
  final currency =
  NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0);
  return SizedBox(
    height: 55,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Đợt ${i.installmentNumber}',
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500, color: Colors.blue)),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currency.format(i.amountDue),
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(width: 40),
            Text('(Hạn: ${DateFormat('dd/MM/yyyy').format(i.dueDate)})',
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    ),
  );
}

Widget installmentHistoryList() {
  return BlocBuilder<InstallmentScheduleCubit, InstallmentScheduleState>(
    builder: (context, state) {
      final history = state.installmentSchedules.where((i) => i.status == 'paid').toList();

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListView.separated(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: history.length,
          itemBuilder: (_, i) => installmentHistoryItem(history[i]),
          separatorBuilder: (_, __) =>
          const Divider(height: 10, color: Colors.grey),
        ),
      );
    },
  );
}

Widget installmentHistoryItem(InstallmentSchedule i) {
  final currency =
  NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0);
  return SizedBox(
    height: 80,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Đã thanh toán đợt ${i.installmentNumber}',
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500, color: Colors.blue)),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text('Số tiền: ${currency.format(i.amountDue)}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text('Ngày thanh toán: ${DateFormat('dd/MM/yyyy').format(i.dueDate)}',
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500)),
        ),
      ],
    ),
  );
}

InstallmentSchedule? _installmentNow(List<InstallmentSchedule> l) {
  for (var i in l) {
    if (i.status == 'overdue' || i.status == 'in_time') {
      return i;
    }
  }
  return null;
}