import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:training_example/models/cart_item/cart_item.dart';
import 'package:training_example/models/product/product.dart';

@singleton
class CartRepository {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  String? currentUser = FirebaseAuth.instance.currentUser?.email;

  Future<List<CartItem>> getCartItems() async {
    List<CartItem> cartItems = [];
    await db
        .collection('Cart')
        .where("username", isEqualTo: currentUser)
        .get()
        .then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          var item = CartItem.fromJson(docSnapshot.data());
          await db
              .collection('Product')
              .where('id', isEqualTo: item.id)
              .get()
              .then((querySnapshot) {
            for (var docSnapshot in querySnapshot.docs) {
              item.itemInfo = Product.fromJson(docSnapshot.data());
            }
          });
          cartItems.add(item);
        }
      },
      onError: (e) => throw e,
    );
    return cartItems;
  }

  Future<bool> updateProductQuantity({required String productId, required int quantity, required bool isIncrease}) async {
    int quantityUpdate = isIncrease ? quantity : (quantity * -1);
    try {
      var querySnapshot = await db
          .collection('Cart')
          .where('username', isEqualTo: currentUser)
          .where('id', isEqualTo: productId)
          .get();
      if (querySnapshot.size == 0) {
        return false;
      } else {
        await db
            .collection('Cart')
            .where('username', isEqualTo: currentUser)
            .where('id', isEqualTo: productId)
            .get()
            .then((qs) {
          for (var doc in qs.docs) {
            int currentAmount = doc.get('quantity');
            doc.reference.update({'quantity': currentAmount + quantityUpdate});
          }
        });
        return true;
      }
    }catch (e) {
      return false;
    }
  }

  Future<bool> addProductToCart({required String productId, required int quantity}) async {
    try {
      var querySnapshot = await db
          .collection('Cart')
          .where('username', isEqualTo: currentUser)
          .where('id', isEqualTo: productId)
          .get();
      if (querySnapshot.size == 0) {
        //Handle create new cart item to FS
        final data = {
          'id': productId,
          'quantity': quantity,
          'username': currentUser
        };
        await db.collection('Cart').add(data);
        return true;
      } else {
        //Handle add number item to the current cart item to FS
        await db
            .collection('Cart')
            .where('username', isEqualTo: currentUser)
            .where('id', isEqualTo: productId)
            .get()
            .then((qs) {
          for (var doc in qs.docs) {
            int currentAmount = doc.get('quantity');
            doc.reference.update({'quantity': currentAmount + quantity});
          }
        });
        return true;
      }
    }catch (e) {
      return false;
    }
  }

  Future<bool> removeCartItem({required String productId}) async {
    var querySnapshot = await db.collection('Cart')
        .where('username', isEqualTo: currentUser)
        .where('id', isEqualTo: productId).get();
    if (querySnapshot.size != 0) {
      for (QueryDocumentSnapshot snapshot in querySnapshot.docs) {
        await snapshot.reference.delete();
      }
      return true;
    }
    return false;
  }
}
