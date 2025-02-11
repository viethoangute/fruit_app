import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

@singleton
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepo;

  CartBloc({required this.cartRepo}) : super(CartLoadingState()) {
    on<FetchCartItemEvent>(_onFetchCartItemRequest);
    on<AddCartItemEvent>(_onAddCartItemRequest);
    on<UpdateQuantityEvent>(_onUpdateQuantityRequest);
    on<RemoveCartItemEvent>(_onRemoveCartItemRequest);
  }

  Future<void> _onFetchCartItemRequest(
      FetchCartItemEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      var cartItems = await cartRepo.getCartItems();
      emit(CartLoadedState(cartData: cartItems));
    } catch (e) {
      emit(CartErrorState(error: e.toString()));
    }
  }

  Future<void> _onAddCartItemRequest(
      AddCartItemEvent event, Emitter<CartState> emit) async {
    try {
      var rs = await cartRepo.addProductToCart(
          quantity: event.quantity, productId: event.productId);
      if (rs) {
        emit(AddedCartItemState());
      } else {
        emit(AddCartItemErrorState(error: 'Can not add to Cart'));
      }
    } catch (e) {
      emit(AddCartItemErrorState(error: 'Can not add to Cart'));
    }
  }

  Future<void> _onUpdateQuantityRequest(
      UpdateQuantityEvent event, Emitter<CartState> emit) async {
    await cartRepo.updateProductQuantity(
        quantity: event.quantity,
        productId: event.productId,
        isIncrease: event.isIncrease);
  }

  Future<void> _onRemoveCartItemRequest(
      RemoveCartItemEvent event, Emitter<CartState> emit) async {
    bool rs = await cartRepo.removeCartItem(productId: event.productId);
    if (!rs) {
      emit(RemovedCartItemErrorState(
          error: 'Can not find item in Cart or something went wrong'));
    }
  }
}
