import 'dart:io';

import 'package:dental_booking_app/data/model/order_model.dart';
import 'package:dental_booking_app/data/repository/payment_repository.dart';
import 'package:dental_booking_app/data/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.order});
  final OrderModel order;

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Chờ xử lý';
      case 'shipping':
        return 'Đang giao';
      case 'delivered':
        return 'Đã giao';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return 'Chờ xử lý';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'all':
        return Colors.orange.shade100;
      case 'pending':
        return Colors.blue.shade100;
      case 'shipping':
        return Colors.green.shade100;
      case 'cancelled':
        return Colors.red.shade100;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = const Color(0xFF2196F3);
    final Color backgroundGrey = const Color(0xFFF5F5F5);
    final Color successGreen = const Color(0xFFE8F5E9);
    final Color textGreen = const Color(0xFF2E7D32);

    final currency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );

    num totalPrice = 0;
    for (var i in order.invoice.lineItems){
      totalPrice += i['unitPrice'] * i['quantity'];
    }

    return Scaffold(
      backgroundColor: backgroundGrey,
      appBar: AppBar(
        backgroundColor: backgroundGrey,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 19),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chi tiết Đơn hàng',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSectionCard(
                    child: Column(
                      children: [
                        _buildRowInfo(
                          'Mã đơn hàng',
                          order.id.substring(0, 7),
                          isCopyable: true,
                        ),
                        const SizedBox(height: 12),
                        _buildRowInfo(
                          'Ngày đặt',
                          DateFormat(
                            'dd/MM/yyyy',
                          ).format(order.invoice.createdAt),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Trạng thái',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: successGreen,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _getStatusText(order.status),
                                style: TextStyle(
                                  color: textGreen,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildSectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sản phẩm đã mua',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return _buildProductItem(
                              item: order.invoice.lineItems[index],
                            );
                          },
                          separatorBuilder: (context, i) {
                            return const Divider(height: 24);
                          },
                          itemCount: order.invoice.lineItems.length,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildSectionCard(
                    child: Column(
                      children: [
                        _buildRowInfo('Tổng tiền hàng', currency.format(totalPrice)),
                        const SizedBox(height: 12),
                        _buildRowInfo('Phí vận chuyển', '25.000đ'),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Divider(
                            color: Colors.grey.shade300,
                            height: 1,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tổng cộng',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              currency.format(order.invoice.totalAmount),
                              style: TextStyle(
                                color: primaryBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildSectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thông tin giao hàng',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.blue,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder(
                                    future: UserRepository().getUser(order.invoice.patientId),
                                    builder: (context, snap){
                                      if(snap.connectionState == ConnectionState.waiting){
                                        return Center(
                                          child: LoadingAnimationWidget.waveDots(color: Colors.blue.shade300, size: 30),
                                        );
                                      }

                                      if(!snap.hasData){
                                        return Center(
                                          child: Text('empty'),
                                        );
                                      }

                                      return Text(
                                        snap.data!.fullName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      );
                                    }
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '(+84) ${order.phoneContact.substring(1)}',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    order.addressDelivery,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.credit_card,
                              color: Colors.blue,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Phương thức thanh toán',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  FutureBuilder(
                                    future: PaymentRepository().getById(order.invoice.paymentId!),
                                    builder: (context, snap){
                                      if(snap.connectionState == ConnectionState.waiting){
                                        return Center(
                                          child: LoadingAnimationWidget.waveDots(color: Colors.blue.shade300, size: 30),
                                        );
                                      }

                                      if(!snap.hasData){
                                        return Center(
                                          child: Text('empty'),
                                        );
                                      }

                                      return snap.data!.method == 'banking' ? 
                                        Text(
                                          'Thanh toán qua ngân hàng',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                          ),
                                        ) : Text(
                                          'Thanh toán sau khi nhận hàng',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                        ),
                                      );
                                    }
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => messageAction(context),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Yêu cầu hỗ trợ',
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildRowInfo(String label, String value, {bool isCopyable = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isCopyable) ...[
              const SizedBox(width: 8),
              const Icon(Icons.copy, size: 16, color: Colors.blue),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildProductItem({required Map<String, dynamic> item}) {
    final currency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );

    return Row(
      children: [
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['nameItem'],
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Số lượng: ${item['quantity']}',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        Text(
          currency.format(item['totalPrice']),
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
      ],
    );
  }
}

void messageAction(BuildContext context) async{
    String url;
    String facebookId ='61584109139069';

      if (Platform.isAndroid) {
        // url = 'fb-messenger://user-thread/$facebookId';
          String message = "Tôi muốn được hỗ trợ";
          url = 'https://m.me/$facebookId?text=${Uri.encodeComponent(message)}';
      } else if (Platform.isIOS) {
        url = 'https://m.me/$facebookId';
      } else {
        print('Unsupported platform');
        return;
      }

      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
}

