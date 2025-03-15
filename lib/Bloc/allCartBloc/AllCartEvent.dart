import 'package:equatable/equatable.dart';

abstract class AllCartEvent extends Equatable {}

class GetAllCartEvent extends AllCartEvent {
  @override
  List<Object?> get props => [];
}

class DeleteCartEvent extends AllCartEvent {
  final int cartId;

  DeleteCartEvent({required this.cartId});

  @override
  List<Object?> get props => [cartId];
}

class UpdateCartEvent extends AllCartEvent {
  final int cartId;
  final Map<String, dynamic> updatedCart;

  UpdateCartEvent({required this.cartId, required this.updatedCart});

  @override
  List<Object> get props => [cartId, updatedCart];
}
