// product_bloc.dart
import 'dart:convert';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http;

import '../../model/products_model.dart'; // Ensure the correct path
import '../../model/products_model.dart'; // Ensure the correct path
import 'page_event.dart';
import 'page_event.dart';
import 'page_state.dart';
import 'page_state.dart';

class PageBloc extends Bloc<PageEvent, PageState> {
  int _currentPage = 1;
  final int _limit = 10;
  bool _hasMore = true;

  PageBloc() : super(PageInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
  }

  Future<void> _onFetchProducts(
      FetchProducts event, Emitter<PageState> emit) async {
    _currentPage = 1; // Reset to page 1 when fetching initial products
    _hasMore = true; // Reset the hasMore flag

    emit(PageLoading());

    await _fetchProducts(emit);
  }

  Future<void> _onLoadMoreProducts(
      LoadMoreProducts event, Emitter<PageState> emit) async {
    if (!_hasMore) return; // No more pages to fetch

    emit(PageLoading());

    _currentPage++; // Increment the current page for loading more products

    await _fetchProducts(emit);
  }

  Future<void> _fetchProducts(Emitter<PageState> emit) async {
    try {
      final response = await http.get(Uri.parse(
          'https://dummyjson.com/products?limit=$_limit&page=$_currentPage'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<ProductsModel> products = (data['products'] as List)
            .map((item) => ProductsModel.fromJson(item))
            .toList();

        _hasMore = products.length == _limit;

        // Update the state with the new products
        if (_currentPage == 1) {
          emit(PageLoaded(products, _hasMore));
        } else {
          // Append new products to the existing list
          if (state is PageLoaded) {
            final existingProducts = (state as PageLoaded).products;
            emit(PageLoaded([...existingProducts, ...products], _hasMore));
          }
        }
      } else {
        emit(PageError('Failed to load products'));
      }
    } catch (e) {
      emit(PageError(e.toString()));
    }
  }
}
