import 'package:dumyjsonapi/model/single_cart_model.dart';
import 'package:equatable/equatable.dart';

abstract class AllCartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AllCartInitialState extends AllCartState {}

class AllCartLoadingState extends AllCartState {}

class AllCartLoadedState extends AllCartState {
  final List<CartModel>? carts;

  AllCartLoadedState({this.carts});

  @override
  List<Object?> get props => [carts];
}

class AllCartDeletingState extends AllCartState {}

class AllCartDeletedState extends AllCartState {}

class AllCartUpdatingState extends AllCartState {}

class AllCartUpdatedState extends AllCartState {
  final String message;

  AllCartUpdatedState({required this.message});

  @override
  List<Object> get props => [message];
}

class AllCartErrorState extends AllCartState {
  final String errMsg;

  AllCartErrorState({required this.errMsg});

  @override
  List<Object?> get props => [errMsg];
}
