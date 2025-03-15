import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {}

/// correct
/*class GetAllProductsEvent extends ProductEvent {
  @override
  List<Object?> get props => [];
}*/

class GetAllProductsEvent extends ProductEvent {
  final int? page;

  GetAllProductsEvent({this.page});

  @override
  // TODO: implement props
  List<Object?> get props => [page];
}

class MoreGetAllProductsEvent extends ProductEvent {
  final int? page;

  MoreGetAllProductsEvent({this.page});

  @override
  // TODO: implement props
  List<Object?> get props => [page];
}

class DetailEvent extends ProductEvent {
  final int id;
  DetailEvent({required this.id});
  @override
  List<Object?> get props => [id];
}
