import 'package:dental_booking_app/view/user_screen/main_screen/product_catalog_page/cart_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dental_booking_app/view/user_screen/main_screen/product_catalog_page/details_product.dart';
import 'package:dental_booking_app/data/model/category_model.dart';
import 'package:dental_booking_app/data/repository/catalog_repository.dart';
import 'package:dental_booking_app/data/repository/product_repository.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../data/model/product_model.dart';



class ProductCatalogPage extends StatefulWidget {
  const ProductCatalogPage({super.key});

  @override
  State<ProductCatalogPage> createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {
  late Future<List<ProductCatalog>> _catalogsFuture;
  List<ProductCatalog> _catalogs = [];
  String? _selectedId;
  Future<List<Product>>? _productsFuture;

  @override
  void initState() {
    super.initState();
    _catalogsFuture = CatalogRepository().getAll();
    _catalogsFuture.then((cats) {
      if (!mounted) return;
      _catalogs = cats;
      _selectedId = cats.isNotEmpty ? cats.first.id : null;
      if (_selectedId != null) {
        _productsFuture =
            ProductRepository(_selectedId!).getProductForCatalog();
      }
      setState(() {});
    });
  }

  void _selectCatalog(String id) {
    if (id == _selectedId) return;
    setState(() {
      _selectedId = id;
      _productsFuture = ProductRepository(id).getProductForCatalog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục sản phẩm',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () => 
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ShoppingCartScreen())
                ),
              style: IconButton.styleFrom(
                splashFactory: NoSplash.splashFactory
              ),
              icon: SvgPicture.asset(
                  'assets/icons/shopping-cart.svg', width: 21),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          children: [
            SizedBox(
              height: 110,
              child: FutureBuilder<List<ProductCatalog>>(
                future: _catalogsFuture,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return Center(child: Text('Lỗi: ${snap.error}'));
                  }
                  final data = snap.data ?? [];
                  if (data.isEmpty) {
                    return const Center(child: Text('Chưa có danh mục'));
                  }
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 5),
                    itemBuilder: (context, index) {
                      final c = data[index];
                      final selected = c.id == _selectedId;
                      return GestureDetector(
                        onTap: () => _selectCatalog(c.id),
                        child: AnimatedContainer(
                          width: 80,
                          duration: const Duration(milliseconds: 160),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: selected
                                  ? const Color.fromARGB(255, 71, 162, 208)
                                  : Colors.transparent,
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: selected ? 10 : 6,
                                spreadRadius: 0,
                                offset: const Offset(0, 2),
                                color: Colors.black
                                    .withOpacity(selected ? 0.08 : 0.04),
                              )
                            ],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(c.imageUrl, height: 45),
                              const SizedBox(height: 6),
                              Text(
                                c.name,
                                style: const TextStyle(fontSize: 13),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            Expanded(
              child: _productsFuture == null
                  ? const Center(child: CircularProgressIndicator())
                  : FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return Center(child: Text('Lỗi: ${snap.error}'));
                  }
                  final items = snap.data ?? [];
                  if (items.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: _EmptyBox(),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, _) =>
                      const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return ProductTile(product: items[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  const _EmptyBox();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Chưa có sản phẩm cho danh mục này', style: TextStyle(color: Colors.grey)),
    );
  }
}

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF86B817);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.network(product.imageUrl, width: 36, height: 36,),//Icon(Icons.image_outlined, size: 36, color: Colors.grey)
            ),
            const SizedBox(width: 12),

            // thông tin
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if ((product.price - product.price*product.discount/100) < product.price) ...[
                        Text(
                          '${product.price} đ',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text('${(product.price - product.price*product.discount/100).toInt()} đ', style: const TextStyle(fontSize: 13, color: Colors.red, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 8),
                      if (product.discount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFFFFEEF0), borderRadius: BorderRadius.circular(8)),
                          child: Text('-${product.discount}%', style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.w700)),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // nút mua
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade300,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.only(),
                  minimumSize: Size(55, 30)
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsProduct(product: product)));
              },
              child: const Text('Mua ngay', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}