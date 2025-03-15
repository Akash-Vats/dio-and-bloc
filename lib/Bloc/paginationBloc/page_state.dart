// page_state.dart
import 'package:dumyjsonapi/model/products_model.dart';
import 'package:equatable/equatable.dart';

abstract class PageState extends Equatable {
  @override
  List<Object> get props => [];
}

class PageInitial extends PageState {}

class PageLoading extends PageState {}

class PageLoaded extends PageState {
  final List<ProductsModel> products;
  final bool hasMore;

  PageLoaded(this.products, this.hasMore);

  @override
  List<Object> get props => [products, hasMore];
}

class PageError extends PageState {
  final String message;

  PageError(this.message);

  @override
  List<Object> get props => [message];
}
