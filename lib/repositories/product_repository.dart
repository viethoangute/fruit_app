import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../models/product/product.dart';

@singleton
class ProductRepository {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<Product>> getListProduct({required String category}) async {
    List<Product> products = [];
    await db
        .collection('Product')
        .where("category", isEqualTo: category)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          products.add(Product.fromJson(docSnapshot.data()));
        }
      },
      onError: (e) => throw e,
    );
    return products;
  }

  Future<List<Product>> searchProducts({required String keyword}) async {
    List<Product> products = [];
    if (keyword.isEmpty) {
      await db.collection('Product').limit(10).get().then(
        (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            products.add(Product.fromJson(docSnapshot.data()));
          }
        },
        onError: (e) => throw e,
      );
    } else {
      await db
          .collection('Product')
          .where("name", isGreaterThanOrEqualTo: keyword.toUpperCase())
          .get()
          .then(
        (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            products.add(Product.fromJson(docSnapshot.data()));
          }
        },
        onError: (e) => throw e,
      );
    }
    return products;
  }
}
