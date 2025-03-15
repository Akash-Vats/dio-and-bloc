import 'dart:async';

import 'package:dumyjsonapi/Bloc/allCartBloc/AllCartEvent.dart';
import 'package:dumyjsonapi/Bloc/allCartBloc/allCartState.dart';
import 'package:dumyjsonapi/Repository/all_cart_repo.dart';
import 'package:dumyjsonapi/model/single_cart_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllCartBloc extends Bloc<AllCartEvent, AllCartState> {
  AllCartBloc() : super(AllCartInitialState()) {
    on<GetAllCartEvent>(_onGetAllCarts);
    on<DeleteCartEvent>(_onDeleteCart);
    on<UpdateCartEvent>(_onUpdateCart);

    add(GetAllCartEvent());
  }

  FutureOr<void> _onGetAllCarts(
      GetAllCartEvent event, Emitter<AllCartState> emit) async {
    try {
      emit(AllCartLoadingState());

      List<CartModel>? carts = await GetAllCarts().getAllData();
      if (carts == null || carts.isEmpty) {
        emit(AllCartErrorState(errMsg: 'No carts found.'));
      } else {
        emit(AllCartLoadedState(carts: carts));
      }
    } catch (e) {
      emit(AllCartErrorState(errMsg: e.toString()));
    }
  }

  FutureOr<void> _onDeleteCart(
      DeleteCartEvent event, Emitter<AllCartState> emit) async {
    try {
      /* emit(AllCartDeletingState());*/

      await GetAllCarts().deleteCart(event.cartId);
      /*  emit(AllCartDeletedState());*/

      /*  add(GetAllCartEvent());*/
    } catch (e) {
      emit(AllCartErrorState(errMsg: e.toString()));
    }
  }

  FutureOr<void> _onUpdateCart(
      UpdateCartEvent event, Emitter<AllCartState> emit) async {
    try {
      emit(AllCartUpdatingState());

      await GetAllCarts().updateCart(event.cartId, event.updatedCart);
      add(GetAllCartEvent());
      emit(AllCartUpdatedState(message: 'Cart updated successfully'));
    } catch (e) {
      emit(AllCartErrorState(errMsg: e.toString()));
    }
  }
}
