import '../product/product.dart';

class CartItem {
  late String username;
  late String id;
  late Product? itemInfo;
  late int quantity;
  late bool isChose;

  CartItem({
    required this.itemInfo,
    required this.username,
    required this.id,
    required this.quantity,
    required this.isChose,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'id': id,
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> map) {
    return CartItem(
      itemInfo: null,
      username: map['username'] as String,
      id: map['id'] as String,
      quantity: map['quantity'] as int,
      isChose: false,
    );
  }

  void setInfoData({required Product item}) {
    itemInfo = item;
  }

  @override
  String toString() {
    return 'CartItem{username: $username, id: $id, itemInfo: $itemInfo, quantity: $quantity, isChose: $isChose}';
  }
}
