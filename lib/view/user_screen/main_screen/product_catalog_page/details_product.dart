import 'package:dental_booking_app/data/model/cart_product_model.dart';
import 'package:dental_booking_app/data/repository/cart_repository.dart';
import 'package:dental_booking_app/view/user_screen/main_screen/product_catalog_page/invoice_from_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/model/product_model.dart';

class DetailsProduct extends StatefulWidget {
  const DetailsProduct({super.key, required this.product});

  final Product product;

  @override
  State<DetailsProduct> createState() => _DetailsProductState();
}

class _DetailsProductState extends State<DetailsProduct> {
  int quantity = 1;
  final currency = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
    decimalDigits: 0,
  );

  final cartRepo = CartRepository();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 40,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 300,
                      color: Colors.white,
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Image.network(
                        widget.product.imageUrl,
                        width: 120,
                        height: 150,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey
                            ),
                            color: Colors.grey.shade200,
                          ),
                          child: Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (quantity > 1) {
                                      quantity--;
                                    }
                                  });
                                },
                                splashFactory: NoSplash.splashFactory,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.shade200,
                                ),
                                child: Text(
                                  quantity.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    quantity++;
                                  });
                                },
                                splashFactory: NoSplash.splashFactory,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 35),
                        Text(
                          currency.format(
                            (widget.product.price -
                                    widget.product.price *
                                        widget.product.discount /
                                        100)
                                .toInt(),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          currency.format(widget.product.price),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Mô tả sản phẩm",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),

                    Text(
                      widget.product.description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => InvoiceFromProductScreen(
                                product: widget.product,
                                quantity: quantity,
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 50),
                      maximumSize: const Size(200, 50),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black12),
                    ),
                    child: const Text(
                      'Mua ngay',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final toCart = CartProduct(
                        id: '0', 
                        productId: widget.product.id, 
                        nameProduct: widget.product.name, 
                        imageUrl: widget.product.imageUrl, 
                        price: widget.product.price, 
                        quantity: quantity, 
                        isSelected: false
                      );

                      final result = await cartRepo.addToCart(toCart);
                      if(result == 'success'){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Đã thêm vào giỏ hàng của bạn'), backgroundColor: Colors.blue.shade300,)
                        );
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('error'), backgroundColor: Colors.blue.shade300,)
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      maximumSize: const Size(200, 50),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.blue[400],
                    ),
                    child: const Text(
                      'Thêm vào giỏ hàng',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
