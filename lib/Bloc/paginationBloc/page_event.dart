// page_event.dart
import 'package:equatable/equatable.dart';

abstract class PageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchProducts extends PageEvent {
  final int page;

  FetchProducts(this.page);

  @override
  List<Object> get props => [page];
}

class LoadMoreProducts extends PageEvent {
  @override
  List<Object> get props => [];
}
