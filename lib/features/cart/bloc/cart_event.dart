import 'package:training_example/models/cart_item/cart_item.dart';

abstract class CartEvent {}

class FetchCartItemEvent extends CartEvent{

}

class FetchCartNumberItemsEvent extends CartEvent{

}

class AddCartItemEvent extends CartEvent{
  final String productId;
  final int quantity;

  AddCartItemEvent({
    required this.productId,
    required this.quantity
  });
}

class RemoveCartItemEvent extends CartEvent{
  final String productId;

  RemoveCartItemEvent({
    required this.productId,
  });
}

class UpdateQuantityEvent extends CartEvent{
  final String productId;
  final int quantity;
  final bool isIncrease;

  UpdateQuantityEvent({
    required this.productId,
    required this.quantity,
    required this.isIncrease
  });
}