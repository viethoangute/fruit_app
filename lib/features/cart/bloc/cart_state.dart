import '../../../models/cart_item/cart_item.dart';

abstract class CartState {}

class CartLoadingState extends CartState {}

class CartLoadedState extends CartState {
  final List<CartItem> cartData;

  CartLoadedState({
    required this.cartData,
  });
}

class CartNumberItemsState extends CartState {
  final int numberItems;

  CartNumberItemsState({
    required this.numberItems,
  });
}

class CartErrorState extends CartState {
  final String error;

  CartErrorState({
    required this.error,
  });
}

class AddedCartItemState extends CartState {}

class AddCartItemErrorState extends CartState {
  final String error;

  AddCartItemErrorState({
    required this.error,
  });
}

class UpdateQuantityErrorState extends CartState {
  final String error;

  UpdateQuantityErrorState({
    required this.error,
  });
}

class UpdatedQuantityState extends CartState {}

class RemovedCartItemState extends CartState {
  final String productId;

  RemovedCartItemState({
    required this.productId,
  });
}

class RemovedCartItemErrorState extends CartState {
  final String error;

  RemovedCartItemErrorState({
    required this.error,
  });
}
