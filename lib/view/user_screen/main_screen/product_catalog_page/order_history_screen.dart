import 'package:dental_booking_app/data/model/order_model.dart';
import 'package:dental_booking_app/data/repository/order_repository.dart';
import 'package:dental_booking_app/firebase_options.dart';
import 'package:dental_booking_app/view/user_screen/main_screen/product_catalog_page/detail_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OrderHistoryScreen(),
  ));
}

enum OrderStatus { all, pending, shipping, delivered, cancelled }

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  OrderStatus _selectedFilter = OrderStatus.all;
  late final Future<List<OrderModel>> orderFuture;
  List<OrderModel> _allOrders = [];
  final orderRepo = OrderRepository();

  List<OrderModel> get _filteredOrders {
    if (_selectedFilter == OrderStatus.all) {
      return _allOrders;
    }
    return _allOrders.where((order) => _textToStatus(order.status) == _selectedFilter).toList();
  }

  final currency = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
    decimalDigits: 0,
  );

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.all: return 'Tất cả';
      case OrderStatus.pending: return 'Chờ xử lý';
      case OrderStatus.shipping: return 'Đang giao';
      case OrderStatus.delivered: return 'Đã giao';
      case OrderStatus.cancelled: return 'Đã hủy';
    }
  }

  OrderStatus? _textToStatus(String status) {
    switch (status) {
      case 'all': return OrderStatus.all;
      case 'pending': return OrderStatus.pending;
      case 'shipping': return OrderStatus.shipping;
      case 'delivered': return OrderStatus.delivered;
      case 'Đã hủy': return OrderStatus.cancelled;
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending: return Colors.orange.shade100;
      case OrderStatus.shipping: return Colors.blue.shade100;
      case OrderStatus.delivered: return Colors.green.shade100;
      case OrderStatus.cancelled: return Colors.red.shade100;
      default: return Colors.grey;
    }
  }
  
  Color _getStatusTextColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending: return Colors.orange.shade800;
      case OrderStatus.shipping: return Colors.blue.shade800;
      case OrderStatus.delivered: return Colors.green.shade800;
      case OrderStatus.cancelled: return Colors.red.shade800;
      default: return Colors.black;
    }
  }

  @override
  void initState() {
    orderFuture =  orderRepo.getAll();
    orderFuture.then((orders){
      _allOrders = orders;
      setState(() {
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context), 
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 19,)
        ),
        centerTitle: true,
        title: const Text(
          'Lịch sử đơn hàng',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
        ),
      ),
      body: FutureBuilder(
        future: orderFuture, 
        builder: (context, snap){
          if(snap.connectionState == ConnectionState.waiting){
            return Center(
              child: LoadingAnimationWidget.waveDots(color: Colors.blue.shade300, size: 30),
            );
          }
          return Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: OrderStatus.values.map((status) {
                      final isSelected = _selectedFilter == status;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFilter = status;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.blue : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _getStatusText(status),
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black54,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
          
              Expanded(
                child: _filteredOrders.isEmpty
                    ? const Center(child: Text("Không tìm thấy đơn hàng nào"))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = _filteredOrders[index];
                          return _buildOrderCard(order);
                        },
                      ),
              ),
            ],
          );
        }
      )
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailScreen(order: order))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Đơn hàng #DH${order.id.substring(0, 5)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(_textToStatus(order.status)!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(_textToStatus(order.status)!),
                        style: TextStyle(
                          fontSize: 12,
                          color: _getStatusTextColor(_textToStatus(order.status)!),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, color: Colors.grey, size: 25),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Ngày đặt: ${DateFormat('dd/MM/yyyy').format(order.invoice.createdAt)}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            
            const SizedBox(height: 12),
            
            LayoutBuilder(
              builder: (context, constraints) {
                final boxWidth = constraints.constrainWidth();
                const dashWidth = 6.0;
                final dashCount = (boxWidth / (2 * dashWidth)).floor();
                return Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  direction: Axis.horizontal,
                  children: List.generate(dashCount, (_) {
                    return SizedBox(
                      width: dashWidth,
                      height: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.grey.shade300),
                      ),
                    );
                  }),
                );
              },
            ),
            
            const SizedBox(height: 12),

            RichText(
              text: TextSpan(
                text: 'Tổng tiền: ',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                children: [
                  TextSpan(
                    text: currency.format(order.invoice.totalAmount),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
  
    );
  }
}

