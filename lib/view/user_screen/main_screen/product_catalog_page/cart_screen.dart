import 'package:dental_booking_app/data/model/cart_product_model.dart';
import 'package:dental_booking_app/data/repository/cart_repository.dart';
import 'package:dental_booking_app/view/user_screen/main_screen/product_catalog_page/invoice_from_cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  List<CartProduct> _cartProducts = [];
  late final Future<List<CartProduct>> cartFuture;
  final cartRepo = CartRepository();

  @override
  void initState() {
    cartFuture = cartRepo.getAll();
    cartFuture.then((products) {
      _cartProducts = products.isNotEmpty ? products : [];
      setState(() {});
    });
    super.initState();
  }

  int get _totalAmount {
    int total = 0;
    for (var product in _cartProducts) {
      if (product.isSelected) {
        total += product.price * product.quantity;
      }
    }
    return total;
  }

  bool get _isAllSelected {
    if (_cartProducts.isEmpty) return false;
    return _cartProducts.every((product) => product.isSelected);
  }

  final currency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),

      body: FutureBuilder(
        future: cartFuture, 
        builder: (context, snap){
          if(snap.connectionState == ConnectionState.waiting){
            return Center(
              child: LoadingAnimationWidget.waveDots(color: Colors.blue.shade300, size: 30),
            );
          }
          return _cartProducts.isEmpty
          ? const Center(
              child: Text(
                'Hiện chưa có sản phẩm nào.',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: _cartProducts.length,
              itemBuilder: (ctx, index) {
                final product = _cartProducts[index];
                return _buildProductItem(product);
              },
            );
        }
      ),

      bottomNavigationBar: Container(
        height: screenHeight * 0.08,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: _isAllSelected,
                      onChanged: (bool? newValue) {
                        setState(() {
                          for (var product in _cartProducts) {
                            product.isSelected = newValue ?? false;
                            cartRepo.update(product.copyWith(isSelected: newValue));
                          }
                        });
                      },
                      side: BorderSide(
                        color: Colors.grey,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)
                      ),
                      activeColor: Colors.blue,
                    ),
                    const Text('Tất cả'),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Tổng thanh toán',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          currency.format(_totalAmount),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              height: double.infinity,
              child: ElevatedButton(
                onPressed: _totalAmount > 0 ? () {
                  final List<CartProduct> products = [];
                  for(var i in _cartProducts){
                    if(i.isSelected){
                      products.add(i);
                    }
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context) => InvoiceFromCartScreen(products: products,totalAmount: _totalAmount)));
                } : null, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: _totalAmount > 0 ? Colors.red : Colors.grey, 
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Mua hàng',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(CartProduct product) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5, top: 5),
        child: Column(
          children: [
            Row(
              children: [
                 Checkbox(
                  value: product.isSelected,
                  onChanged: (bool? newValue) {
                    setState(() {
                      product.isSelected = newValue ?? false;
                      cartRepo.update(product.copyWith(isSelected: newValue));
                    });
                  },
                  side: BorderSide(
                    color: Colors.grey,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3)
                  ),
                  activeColor: Colors.blue,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async{
                    final result = await cartRepo.delete(product);
                      if(result != 'success'){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result))
                        );
                      }
                    setState(() {
                      _cartProducts.remove(product);
                    });
                    
                  },
                  style: TextButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    splashFactory: NoSplash.splashFactory,
                  ), 
                  child: Text('Xóa', style: TextStyle(fontSize: 14, color: Colors.grey),),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      product.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported, color: Colors.grey),
                          ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          product.nameProduct,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          currency.format(product.price),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (product.quantity > 1) {
                                          product.quantity--;
                                        }
                                      });
                                    },
                                    splashFactory: NoSplash.splashFactory,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                                      child: const Icon(Icons.remove, size: 16, color: Colors.black),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey.shade200
                                    ),
                                    child: Text(
                                      product.quantity.toString(),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        product.quantity++;
                                      });
                                    },
                                    splashFactory: NoSplash.splashFactory,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                                      child: const Icon(Icons.add, size: 20, color: Colors.black),
                                    ),
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
          ],
        )
      ),
    );
  }
}
