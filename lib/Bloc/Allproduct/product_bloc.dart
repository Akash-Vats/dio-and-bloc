import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dumyjsonapi/Bloc/Allproduct/product_event.dart';
import 'package:dumyjsonapi/Bloc/Allproduct/product_state.dart';
import 'package:dumyjsonapi/Repository/all_cart_repo.dart';
import 'package:dumyjsonapi/model/products_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  int currentPage = 1;
  bool _hasMore = true;
  final int _limit = 10;

  ProductBloc() : super(ProductInitialState()) {
    on<GetAllProductsEvent>(_onGetProducts);
    on<MoreGetAllProductsEvent>(_onMoreGetAllProductsEvent);
    on<DetailEvent>(_onDetailsProduct);
    add(GetAllProductsEvent(page: currentPage));

  }

  FutureOr<void> _onMoreGetAllProductsEvent(
    MoreGetAllProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoadedState) {
      final cast = state as ProductLoadedState;
      if (cast.loading) return;
      try {
        emit(ProductLoadedState(
          model: cast.model,
          hasMore: cast.hasMore,
          currentPage: cast.currentPage,
          loading: true,
        ));

        final response = await GetDio().getAll(
          limit: 10,
          page: cast.model.products?.length ?? 0,
        );

        if (response == null) {
          emit(ProductLoadedState(
            model: cast.model,
            hasMore: cast.hasMore,
            currentPage: cast.currentPage,
          ));
        } else {
          final userData = AllProductsModel.fromJson(response.data);
          print("user data---$response");
          var list = cast.model.products ?? <ProductsModel>[];
          list.addAll(userData.products ?? []);
          _hasMore = userData.total != list.length;
          emit(ProductLoadedState(
            model: AllProductsModel(products: list),
            hasMore: _hasMore,
            currentPage: currentPage,
          ));
        }
      } catch (e) {
        emit(ProductLoadedState(
          model: cast.model,
          hasMore: cast.hasMore,
          currentPage: cast.currentPage,
        ));
        print("---error---${e.toString()}");
      }
    }
  }

  FutureOr<void> _onGetProducts(
    GetAllProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (!_hasMore) return;

    try {
      emit(ProductLoadingState());

      final response = await GetDio().getAll(
        limit: 10,
        page: event.page ?? currentPage,
      );

      if (response == null) {
        emit(ProductErrorState(errMsg: "Something went wrong"));
      } else {
        final userData = AllProductsModel.fromJson(response.data);
        print("user data---$response");

        _hasMore = userData.products!.length == _limit;

        if (_hasMore) {
          currentPage = event.page ?? currentPage + 1;
        }

        emit(ProductLoadedState(
          model: userData,
          hasMore: _hasMore,
          currentPage: currentPage,
        ));
      }
    } catch (e) {
      emit(ProductErrorState(errMsg: e.toString()));
      print("---error---${e.toString()}");
    }
  }

  FutureOr<void> _onDetailsProduct(
      DetailEvent event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoadingState());
      final response = await GetDio().detailData(event.id);

      if (response == null || response.data == null) {
        emit(ProductErrorState(errMsg: "Something went wrong"));
      } else {
        final userData = ProductsModel.fromJson(response.data);
        print("User data: $userData");
        emit(ProductDetailsState(productsModel: userData));
      }
    } catch (e, stackTrace) {
      emit(ProductErrorState(errMsg: "An error occurred: ${e.toString()}"));
      print("Error: ${e.toString()}");
      print("Stack Trace: $stackTrace");
    }
  }
}
///
///
///


/*
class UserScreen extends StatelessWidget {
  final PaginationController userController = Get.put(PaginationController());
  final ScrollController scrollController = ScrollController();

  UserScreen() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent &&
          !userController.isLastPage.value &&
          !userController.isLoading.value) {
        userController.fetchUsers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Paginated Users')),
      body: Obx(() {
        if (userController.users.isEmpty && userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          controller: scrollController,
          itemCount: userController.users.length +
              (userController.isLastPage.value ? 0 : 1),
          itemBuilder: (context, index) {
            if (index < userController.users.length) {
              final user = userController.users[index];
              return ListTile(
                title: Text(user.username),
                subtitle: Text(user.email),
                trailing: Text(user.phone),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        );
      }),
    );
  }
}*/
/*
class PaginationController extends GetxController {
  var users = <PaginationModel>[].obs;
  var isLoading = false.obs;
  var isLastPage = false.obs;
  var currentPage = 1;
  final int limit = 10;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    if (isLoading.value || isLastPage.value) return;
    isLoading.value = true;

    final url =
        'https://fakestoreapi.com/users?limit=$limit&page=$currentPage';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        if (data.isEmpty) {
          isLastPage.value = true;
        } else {
          users.addAll(data.map((e) => PaginationModel.fromJson(e)).toList());
          currentPage++;
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch users');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}*/
