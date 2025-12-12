import 'package:dental_booking_app/data/model/cart_product_model.dart';
import 'package:dental_booking_app/data/repository/cart_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../data/model/invoice_model.dart';
import '../../../../data/model/order_model.dart';
import '../../../../data/model/payment_model.dart';
import '../../../../data/model/user_model.dart';
import '../../../../data/repository/invoice_repository.dart';
import '../../../../data/repository/order_repository.dart';
import '../../../../data/repository/payment_repository.dart';
import '../../../../data/repository/user_repository.dart';
import '../../../../logic/stripe_api_functions.dart';
import 'order_success_screen.dart';


class InvoiceFromCartScreen extends StatefulWidget {
  const InvoiceFromCartScreen({super.key, required this.products, required this.totalAmount});
  final List<CartProduct> products;
  final int totalAmount;

  @override
  State<InvoiceFromCartScreen> createState() => _InvoiceFromCartScreenState();
}

class _InvoiceFromCartScreenState extends State<InvoiceFromCartScreen> {
  int _selectedPaymentMethod = 0;
  int shippingCost = 25000;

  final currency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0);

  final _auth = FirebaseAuth.instance;

  late Future<UserModel?> _userFuture;

  final _userRepo = UserRepository();
  final _invoiceRepo = InvoiceRepository();
  final _paymentRepo = PaymentRepository();
  final _orderRepo = OrderRepository();
  final _cartRepo = CartRepository();

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  final Map<String, List<String>> _hanoiDistricts = {
    'Quận Ba Đình': [
      'Phường Cống Vị', 'Phường Điện Biên', 'Phường Đội Cấn', 'Phường Giảng Võ',
      'Phường Kim Mã', 'Phường Liễu Giai', 'Phường Ngọc Hà', 'Phường Ngọc Khánh',
      'Phường Nguyễn Trung Trực', 'Phường Phúc Xá', 'Phường Quán Thánh', 'Phường Thành Công',
      'Phường Trúc Bạch', 'Phường Vĩnh Phúc'
    ],
    'Quận Hoàn Kiếm': [
      'Phường Chương Dương', 'Phường Cửa Đông', 'Phường Cửa Nam', 'Phường Đồng Xuân',
      'Phường Hàng Bạc', 'Phường Hàng Bài', 'Phường Hàng Bồ', 'Phường Hàng Bông',
      'Phường Hàng Buồm', 'Phường Hàng Đào', 'Phường Hàng Gai', 'Phường Hàng Mã',
      'Phường Hàng Trống', 'Phường Lý Thái Tổ', 'Phường Phan Chu Trinh', 'Phường Phúc Tân',
      'Phường Tràng Tiền', 'Phường Tràng Thi'
    ],
    'Quận Đống Đa': [
      'Phường Cát Linh', 'Phường Hàng Bột', 'Phường Khâm Thiên', 'Phường Khương Thượng',
      'Phường Kim Liên', 'Phường Láng Hạ', 'Phường Láng Thượng', 'Phường Nam Đồng',
      'Phường Ngã Tư Sở', 'Phường Ô Chợ Dừa', 'Phường Phương Liên', 'Phường Phương Mai',
      'Phường Quang Trung', 'Phường Quốc Tử Giám', 'Phường Thịnh Quang', 'Phường Thổ Quan',
      'Phường Trung Liệt', 'Phường Trung Phụng', 'Phường Trung Tự', 'Phường Văn Chương', 'Phường Văn Miếu'
    ],
    'Quận Hai Bà Trưng': [
      'Phường Bạch Đằng', 'Phường Bách Khoa', 'Phường Bạch Mai', 'Phường Cầu Dền',
      'Phường Đống Mác', 'Phường Đồng Nhân', 'Phường Đồng Tâm', 'Phường Lê Đại Hành',
      'Phường Minh Khai', 'Phường Nguyễn Du', 'Phường Phạm Đình Hổ', 'Phường Phố Huế',
      'Phường Quỳnh Lôi', 'Phường Quỳnh Mai', 'Phường Thanh Lương', 'Phường Thanh Nhàn',
      'Phường Trương Định', 'Phường Vĩnh Tuy'
    ],
    'Quận Tây Hồ': [
      'Phường Bưởi', 'Phường Nhật Tân', 'Phường Phú Thượng', 'Phường Quảng An',
      'Phường Thụy Khuê', 'Phường Tứ Liên', 'Phường Xuân La', 'Phường Yên Phụ'
    ],
    'Quận Cầu Giấy': [
      'Phường Dịch Vọng', 'Phường Dịch Vọng Hậu', 'Phường Mai Dịch', 'Phường Nghĩa Đô',
      'Phường Nghĩa Tân', 'Phường Quan Hoa', 'Phường Trung Hòa', 'Phường Yên Hòa'
    ],
    'Quận Thanh Xuân': [
      'Phường Hạ Đình', 'Phường Khương Đình', 'Phường Khương Mai', 'Phường Khương Trung',
      'Phường Kim Giang', 'Phường Nhân Chính', 'Phường Phương Liệt', 'Phường Thanh Xuân Bắc',
      'Phường Thanh Xuân Nam', 'Phường Thanh Xuân Trung', 'Phường Thượng Đình'
    ],
    'Quận Hoàng Mai': [
      'Phường Đại Kim', 'Phường Định Công', 'Phường Giáp Bát', 'Phường Hoàng Liệt',
      'Phường Hoàng Văn Thụ', 'Phường Lĩnh Nam', 'Phường Mai Động', 'Phường Tân Mai',
      'Phường Thanh Trì', 'Phường Thịnh Liệt', 'Phường Trần Phú', 'Phường Tương Mai',
      'Phường Vĩnh Hưng', 'Phường Yên Sở'
    ],
    'Quận Long Biên': [
      'Phường Bồ Đề', 'Phường Cự Khối', 'Phường Đức Giang', 'Phường Gia Thụy',
      'Phường Giang Biên', 'Phường Long Biên', 'Phường Ngọc Lâm', 'Phường Ngọc Thụy',
      'Phường Phúc Đồng', 'Phường Phúc Lợi', 'Phường Sài Đồng', 'Phường Thạch Bàn',
      'Phường Thượng Thanh', 'Phường Việt Hưng'
    ],
    'Quận Nam Từ Liêm': [
      'Phường Cầu Diễn', 'Phường Đại Mỗ', 'Phường Mễ Trì', 'Phường Mỹ Đình 1',
      'Phường Mỹ Đình 2', 'Phường Phú Đô', 'Phường Phương Canh', 'Phường Tây Mỗ',
      'Phường Trung Văn', 'Phường Xuân Phương'
    ],
    'Quận Bắc Từ Liêm': [
      'Phường Cổ Nhuế 1', 'Phường Cổ Nhuế 2', 'Phường Đức Thắng', 'Phường Đông Ngạc',
      'Phường Thụy Phương', 'Phường Liên Mạc', 'Phường Thượng Cát', 'Phường Tây Tựu',
      'Phường Minh Khai', 'Phường Phú Diễn', 'Phường Phúc Diễn', 'Phường Xuân Đỉnh', 'Phường Xuân Tảo'
    ],
    'Quận Hà Đông': [
      'Phường Biên Giang', 'Phường Đồng Mai', 'Phường Yên Nghĩa', 'Phường Dương Nội',
      'Phường Hà Cầu', 'Phường La Khê', 'Phường Mộ Lao', 'Phường Nguyễn Trãi',
      'Phường Phú La', 'Phường Phú Lãm', 'Phường Phú Lương', 'Phường Kiến Hưng',
      'Phường Phúc La', 'Phường Quang Trung', 'Phường Vạn Phúc', 'Phường Văn Quán', 'Phường Yết Kiêu'
    ],
  };

  final String _fixedProvince = 'Hà Nội';
  String? _selectedDistrict;
  String? _selectedWard;

  List<String> get _wards {
    if (_selectedDistrict == null) return [];
    return _hanoiDistricts[_selectedDistrict] ?? [];
  }

  @override
  void initState() {
    _userFuture = _userRepo.getUser(_auth.currentUser!.uid);
    _userFuture.then((user) {
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Không tìm thấy thông tin người dùng'),
            backgroundColor: Colors.blue.shade300,
          ),
        );
      } else{
        _nameCtrl.text = user.fullName!;
        _phoneCtrl.text = user.phone!;
      }
    });
    super.initState();
  }

  @override void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = const Color(0xFF2196F3);
    final Color backgroundGrey = const Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: backgroundGrey,
      appBar: AppBar(
        backgroundColor: backgroundGrey,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Thanh toán Hóa đơn',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: _userFuture,
          builder: (context, snap){
            if(snap.connectionState == ConnectionState.waiting){
              return Center(
                child: LoadingAnimationWidget.waveDots(
                  color: primaryBlue,
                  size: 30,
                ),
              );
            }
            final currentUser = snap.data;
            if(currentUser == null){
              return Center(
                child: Text('Không tìm thấy thông tin người dùng')
              );
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionCard(
                            icon: Icons.receipt_long,
                            title: 'Thông tin hóa đơn',
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index){
                                return _buildInfoRow(widget.products[index].nameProduct, 'SL:${widget.products[index].quantity}');
                              },
                              separatorBuilder: (context, index){
                                return SizedBox(height: 5,);
                              },
                              itemCount: widget.products.length,
                            )
                        ),

                        const SizedBox(height: 16),

                        _buildSectionCard(
                          icon: Icons.local_shipping,
                          title: 'Thông tin người nhận',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTextField(label: 'Tên người nhận', hint: 'Nguyễn Văn A', ctrl: _nameCtrl, readOnly: true),
                              const SizedBox(height: 12),
                              _buildTextField(label: 'Số điện thoại', hint: '09xxxxxxxx', isNumber: true, ctrl: _phoneCtrl),
                              const SizedBox(height: 12),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Tỉnh/Thành phố', style: TextStyle(fontSize: 14, color: Colors.black87)),
                                  const SizedBox(height: 6),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      _fixedProvince,
                                      style: const TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              _buildDropdown(
                                label: 'Quận/Huyện',
                                value: _selectedDistrict,
                                items: _hanoiDistricts.keys.toList(),
                                hint: 'Chọn Quận/Huyện',
                                onChanged: (value) {
                                  setState(() {
                                    _selectedDistrict = value;
                                    _selectedWard = null;
                                  });
                                },
                              ),
                              const SizedBox(height: 12),

                              _buildDropdown(
                                label: 'Phường/Xã',
                                value: _selectedWard,
                                items: _wards,
                                hint: 'Chọn Phường/Xã',
                                onChanged: (value) {
                                  setState(() {
                                    _selectedWard = value;
                                  });
                                },
                                isDisabled: _selectedDistrict == null || _wards.isEmpty,
                              ),
                              const SizedBox(height: 12),

                              _buildTextField(label: 'Địa chỉ cụ thể', hint: 'Số nhà, tên đường', ctrl: _addressCtrl),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        _buildSectionCard(
                          icon: Icons.payments_outlined,
                          title: 'Chi tiết thanh toán',
                          child: Column(
                            children: [
                              _buildInfoRow('Tổng tiền hàng', currency.format(widget.totalAmount)),
                              const SizedBox(height: 12),
                              _buildInfoRow('Tổng phí vận chuyển', currency.format(shippingCost)),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Divider(height: 0.5, thickness: 0.5, color: Colors.grey),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Tổng cộng',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    currency.format(widget.totalAmount+shippingCost),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: primaryBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Chọn phương thức thanh toán',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),

                        _buildPaymentOption(
                          index: 0,
                          icon: Icons.account_balance,
                          title: 'Chuyển khoản ngân hàng',
                          primaryColor: primaryBlue,
                        ),
                        const SizedBox(height: 12),

                        _buildPaymentOption(
                          index: 1,
                          icon: Icons.local_shipping_outlined,
                          title: 'Thanh toán khi nhận hàng',
                          primaryColor: primaryBlue,
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
                      )
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if(_nameCtrl.text.isEmpty || _phoneCtrl.text.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Bạn chưa nhập đủ thông tin'), backgroundColor: Colors.blue.shade300,)
                          );
                        } else if(_selectedDistrict == null || _selectedWard == null || _addressCtrl.text.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Bạn chưa nhập đủ địa chỉ'), backgroundColor: Colors.blue.shade300,)
                          );
                        } else{
                          if(_selectedPaymentMethod == 0) {
                            final paymentPrice = (widget.totalAmount + shippingCost).toString();
                            final address = Address(
                              city: 'Hà Nội',
                              country: 'VN',
                              line1: '${_addressCtrl.text}, ${_selectedWard!}, $_selectedDistrict',
                              line2: '',
                              postalCode: '10000',
                              state: 'Hanoi',
                            );
                            final result = await makePayment(context, paymentPrice, 'vnd', 'Thanh toán đặt hàng', currentUser.fullName!, currentUser.email, _phoneCtrl.text, address);
                            if(result == 'success'){
                              final payment = Payment(
                                  id: 'tmp',
                                  method: 'banking',
                                  createdAt: DateTime.now(),
                                  amount: widget.totalAmount + shippingCost,
                                  userId: _auth.currentUser!.uid,
                                  description: 'Thanh toán đặt hàng'
                              );
                              final resultPay = await _paymentRepo.createNewPayment(payment);

                              if(resultPay == 'error'){
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Lỗi tạo thanh toán'),
                                      backgroundColor: Colors.blue.withOpacity(0.5),
                                    )
                                );
                              } else{
                                final invoice = Invoice(id: 'tmp',
                                    status: 'paid',
                                    amountPaid: widget.totalAmount + shippingCost,
                                    balance: 0,
                                    invoiceType: 'purchase',
                                    createdAt: DateTime.now(),
                                    totalAmount: widget.totalAmount + shippingCost,
                                    patientId: _auth.currentUser!.uid,
                                    paymentId: resultPay,
                                    paymentType: 'pay_now',
                                    description: 'Thanh toán đặt hàng',
                                    lineItems:
                                      widget.products.map((e) => {
                                        'itemId' : e.id,
                                        'nameItem' : e.nameProduct,
                                        'quantity' : e.quantity,
                                        'unitPrice' : e.price,
                                        'totalPrice' : e.price * e.quantity
                                      }).toList()
                                );
                                final resultInvoice = await _invoiceRepo.createNewInvoice(invoice);

                                if(resultInvoice == 'error'){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Lỗi tạo hóa đơn'),
                                        backgroundColor: Colors.blue.withOpacity(0.5),
                                      )
                                  );
                                } else{
                                  final order = OrderModel(
                                      id: 'tmp',
                                      invoice: invoice.copyWith(id: resultInvoice),
                                      addressDelivery: '${_addressCtrl.text}, ${_selectedWard!}, $_selectedDistrict, $_fixedProvince',
                                      phoneContact: _phoneCtrl.text,
                                      status: 'pending',
                                      customerId: _auth.currentUser!.uid
                                  );
                                  final resultOrder = await _orderRepo.createNewOrder(order);
                                  if(resultOrder == 'success'){
                                    for (var p in widget.products) {
                                      final result = await _cartRepo.delete(p.id);
                                      if(result != 'success'){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: const Text('Lỗi tạo xóa sản phẩm'),
                                              backgroundColor: Colors.blue.withOpacity(0.5),
                                            )
                                        );
                                        break;
                                      }
                                    }
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => OrderSuccessScreen(orderId: resultInvoice,)));
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('Lỗi tạo đơn hàng'),
                                          backgroundColor: Colors.blue.withOpacity(0.5),
                                        )
                                    );
                                  }
                                }
                              }
                            } else if(result == 'fail'){
                              if(!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(child: const Text(' Thanh toán không thành công', style: TextStyle(fontSize: 18),)),
                                    backgroundColor: Colors.blue.withOpacity(0.5),
                                  )
                              );
                            }
                          }else{
                            final payment = Payment(
                                id: 'tmp',
                                method: 'pay_later',
                                createdAt: DateTime.now(),
                                amount: widget.totalAmount + shippingCost,
                                userId: _auth.currentUser!.uid,
                                description: 'Thanh toán đặt hàng'
                            );
                            final resultPay = await _paymentRepo.createNewPayment(payment);

                            if(resultPay == 'error'){
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Lỗi tạo thanh toán'),
                                    backgroundColor: Colors.blue.withOpacity(0.5),
                                  )
                              );
                            } else{
                              final invoice = Invoice(
                                  id: 'tmp',
                                  status: 'non_pay',
                                  amountPaid: 0,
                                  balance: 0,
                                  invoiceType: 'purchase',
                                  createdAt: DateTime.now(),
                                  totalAmount: widget.totalAmount + shippingCost,
                                  patientId: _auth.currentUser!.uid,
                                  paymentId: resultPay,
                                  paymentType: 'pay_later',
                                  description: 'Thanh toán đặt hàng',
                                  lineItems:
                                    widget.products.map((e) => {
                                      'itemId' : e.id,
                                      'nameItem' : e.nameProduct,
                                      'quantity' : e.quantity,
                                      'unitPrice' : e.price,
                                      'totalPrice' : e.quantity * e.price
                                    }).toList()
                              );
                              final resultInvoice = await _invoiceRepo.createNewInvoice(invoice);

                              if(resultInvoice == 'error'){
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Lỗi tạo hóa đơn'),
                                      backgroundColor: Colors.blue.withOpacity(0.5),
                                    )
                                );
                              } else{
                                final order = OrderModel(
                                    id: 'tmp',
                                    invoice: invoice.copyWith(id: resultInvoice),
                                    addressDelivery: '${_addressCtrl.text}, ${_selectedWard!}, $_selectedDistrict, $_fixedProvince',
                                    phoneContact: _phoneCtrl.text,
                                    status: 'pending',
                                    customerId: _auth.currentUser!.uid
                                );
                                final resultOrder = await _orderRepo.createNewOrder(order);
                                if(resultOrder == 'success'){
                                  for (var p in widget.products) {
                                    final result = await _cartRepo.delete(p.id);
                                    if(result != 'success'){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Text('Lỗi tạo xóa sản phẩm'),
                                            backgroundColor: Colors.blue.withOpacity(0.5),
                                          )
                                      );
                                      break;
                                    }
                                  }
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => OrderSuccessScreen(orderId: resultInvoice,)));
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Lỗi tạo đơn hàng'),
                                        backgroundColor: Colors.blue.withOpacity(0.5),
                                      )
                                  );
                                }
                              }
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Xác nhận Thanh toán',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
      )
    );
  }

  Widget _buildTextField({required String label, required String hint, bool isNumber = false, required TextEditingController ctrl, bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: readOnly ? BorderSide(color: Colors.grey.shade300) : const BorderSide(color: Colors.blue)),
            isDense: true,
          ),
          onChanged: (value){
            ctrl.text = value;
          },
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
    bool isDisabled = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        const SizedBox(height: 6),
        IgnorePointer(
          ignoring: isDisabled,
          child: DropdownButtonFormField<String>(
            menuMaxHeight: 300,
            borderRadius: BorderRadius.circular(5),
            value: value,
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              fillColor: isDisabled ? Colors.grey.shade100 : Colors.white,
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.blue)),
            ),
            hint: Text(hint, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 14, color: Colors.black87)),
              );
            }).toList(),
            onChanged: isDisabled ? null : onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({required IconData icon, required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(height: 0.5, thickness: 0.5, color: Colors.grey),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black, 
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 40,),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required int index,
    required IconData icon,
    required String title,
    required Color primaryColor,
  }) {
    final bool isSelected = _selectedPaymentMethod == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? primaryColor : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 16),
            Icon(icon, color: isSelected ? primaryColor : Colors.black54, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.black : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}