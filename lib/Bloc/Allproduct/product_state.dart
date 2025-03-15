import 'package:dumyjsonapi/model/products_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProductState extends Equatable {}

class ProductInitialState extends ProductState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class ProductLoadingState extends ProductState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class ProductLoadedState extends ProductState {
  final AllProductsModel model;
  final bool hasMore;
  final bool loading;
  final int currentPage;

  ProductLoadedState({
    required this.model,
    required this.hasMore,
    this.loading = false,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [model, hasMore, currentPage, loading];
}

class ProductErrorState extends ProductState {
  final String errMsg;

  ProductErrorState({required this.errMsg});

  @override
  List<Object?> get props => [errMsg];
}

class ProductDetailsState extends ProductState {
  final ProductsModel productsModel;

  ProductDetailsState({required this.productsModel});

  @override
  List<Object?> get props => [productsModel];
}
