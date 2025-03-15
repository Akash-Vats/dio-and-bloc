import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {}

class LoadCartData extends CartEvent {
  final int id;

  LoadCartData({required this.id});

  @override
  List<Object?> get props => [id];
}

class IncrementProductQuantity extends CartEvent {
  final String productId;
  IncrementProductQuantity(this.productId);

  @override
  List<Object?> get props => [productId];
}

class DecrementProductQuantity extends CartEvent {
  final String productId;
  DecrementProductQuantity(this.productId);

  @override
  List<Object?> get props => [productId];
}

class UpdateCart extends CartEvent {
  @override
  List<Object?> get props => [];
}
