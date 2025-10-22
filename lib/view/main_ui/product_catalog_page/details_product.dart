import 'package:flutter/material.dart';

import '../../model/product_model.dart';

class DetailsProduct extends StatelessWidget {
  const DetailsProduct({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 30,
          leading: IconButton(onPressed:() => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new, size: 20,)),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 300,
                color: Colors.white,
                padding: EdgeInsets.only(top: 20, bottom: 10),
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: Image.network(product.imageUrl, width: 120, height: 150, fit: BoxFit.fitHeight,),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Text(product.name, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),),
                    SizedBox(height: 30,),
                    Row(
                      children: [
                        ProductAmount(),
                        SizedBox(width: 35),
                        Text('${(product.price - product.price*product.discount/100).toInt()} đ', style: const TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.w700)),
                        SizedBox(width: 6,),
                        Text(
                          '${product.price} đ',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30,),
                    Text("Mô tả sản phẩm",
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)
                    ),
                    SizedBox(height: 15,),
                    Expanded(
                      child: Text(product.description,
                          style: const TextStyle(fontSize: 15, color: Colors.black54)
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(100, 50),
                        maximumSize: Size(200, 50),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        backgroundColor: Colors.white
                    ),
                    child: Text('Mua ngay', style: TextStyle(fontSize: 12, color: Colors.black), ),
                  ),
                  ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 50),
                      maximumSize: Size(200, 50),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      backgroundColor: Colors.blue[400],
                    ),
                    child: Text('Thêm vào giỏ hàng', style: TextStyle(fontSize: 12, color: Colors.white), ),)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProductAmount extends StatefulWidget {
  const ProductAmount({super.key});

  @override
  State<ProductAmount> createState() => _StateProductAmount();
}

class _StateProductAmount extends State<ProductAmount> {

  int amount = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 0.5)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: GestureDetector(
              onTap: (){
                setState(() {
                  if(amount > 0){
                    amount--;
                  }
                });
              },
              child: Icon(Icons.remove, size: 16,),
            ),
          ),
          Text(amount.toString()),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: (){
                setState(() {
                  if(amount < 100){
                    amount++;
                  }
                });
              },
              child: Icon(Icons.add, size: 16,),
            ),
          ),
        ],
      ),
    );
  }
}

