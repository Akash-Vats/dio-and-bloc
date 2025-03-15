import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dumyjsonapi/Bloc/singlecartbloc/single_event_bloc.dart';
import 'package:dumyjsonapi/Bloc/singlecartbloc/single_state_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../Repository/all_cart_repo.dart';
import '../../model/single_cart_model.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartLoading()) {
    on<LoadCartData>(_onLoadCartData);
    on<IncrementProductQuantity>(_onIncrementProductQuantity);
    on<DecrementProductQuantity>(_onDecrementProductQuantity);
    on<UpdateCart>(_onUpdateCart);
  }

  Future<void> _onLoadCartData(
      LoadCartData event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      CartModel? cart = await GetAllCarts().fetchCart(event.id);
      emit(CartLoaded(cart!));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onIncrementProductQuantity(
      IncrementProductQuantity event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final newCart =
          currentState.cart.incrementProductQuantity(event.productId);
      emit(CartLoaded(newCart));
    }
  }

  Future<void> _onDecrementProductQuantity(
      DecrementProductQuantity event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final newCart =
          currentState.cart.decrementProductQuantity(event.productId);
      emit(CartLoaded(newCart));
    }
  }

  FutureOr<void> _onUpdateCart(
      UpdateCart event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      emit(CartLoading());
      final body = jsonEncode({
        "merge": true,
        "products": currentState.cart.updateCartApi(),
      });
      try {
        print("---- current stste id----${currentState.cart.id}");
        final response = await http.put(
          Uri.parse('https://dummyjson.com/carts/${currentState.cart.id}'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: body,
        );

        if (response.statusCode == 200) {
          print(" st cod --${response.statusCode}");
          final updatedCart = jsonDecode(response.body);
          emit(CartLoaded(CartModel.fromJson(updatedCart)));
        } else {
          emit(CartError('Failed to update cart: ${response.statusCode}'));
        }
      } catch (e) {
        emit(CartError('An error occurred: $e'));
      }
    }
  }
}
