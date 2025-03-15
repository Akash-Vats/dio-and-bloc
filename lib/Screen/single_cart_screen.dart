// Ensure you have this import or adjust according to your project structure

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/singlecartbloc/single_bloc.dart';
import '../Bloc/singlecartbloc/single_event_bloc.dart';
import '../Bloc/singlecartbloc/single_state_bloc.dart'; // Adjust import as necessary

class CartScreen extends StatelessWidget {
  final int cartId;
  final BuildContext context;

  CartScreen({Key? key, required this.cartId, required this.context})
      : super(key: key) {
    getRefresh(context);
  }

  void getRefresh(BuildContext context) {
    context.read<CartBloc>().add(LoadCartData(id: cartId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: RefreshIndicator(
        onRefresh: () async => getRefresh(context),
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CartLoaded) {
              final cart = state.cart;
              if (cart.isDeleted == true) return SizedBox();
              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(8.0),
                      children: [
                        ...(cart.products ?? []).map((product) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              leading: product.thumbnail == null
                                  ? null
                                  : Image.network(
                                      product.thumbnail ?? "",
                                      width: 50,
                                      height: 50,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons.error, size: 50);
                                      },
                                    ),
                              title: Text(product.title ?? ""),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Price: \$${product.price?.toStringAsFixed(2)}'),
                                  Text(
                                      'total: \$${product.total?.toStringAsFixed(2)}')
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      context.read<CartBloc>().add(
                                          DecrementProductQuantity(
                                              product.id.toString()));
                                    },
                                  ),
                                  Text('${product.quantity}'),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      context.read<CartBloc>().add(
                                          IncrementProductQuantity(
                                              product.id.toString()));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  Text('Total Price: \$${cart.total?.toStringAsFixed(2)}'),
                  Text(
                      'Total Quantity: \$${cart.totalQuantity?.toStringAsFixed(2)}'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CartBloc>().add(UpdateCart());
                        Navigator.pop(context);
                      },
                      child: state is CartLoading
                          ? const CircularProgressIndicator()
                          : const Text('Update Cart'),
                    ),
                  ),
                ],
              );
            } else if (state is CartError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('No data'));
            }
          },
        ),
      ),
    );
  }
}
