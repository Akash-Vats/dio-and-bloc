// bloc/cart_state.dart

import 'package:equatable/equatable.dart';

import '../../model/single_cart_model.dart';

abstract class CartState extends Equatable {
  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final CartModel cart;

  CartLoaded(this.cart);
  CartLoaded copyWith({
    CartModel? cart,
  }) {
    return CartLoaded(cart ?? this.cart);
  }

  @override
  List<Object> get props => [cart];
}

class CartError extends CartState {
  final String message;

  CartError(this.message);

  @override
  List<Object> get props => [message];
}
