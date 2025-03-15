import 'package:dumyjsonapi/Bloc/allCartBloc/allCartbloc.dart';
import 'package:dumyjsonapi/Screen/single_cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/allCartBloc/AllCartEvent.dart';
import '../Bloc/allCartBloc/allCartState.dart';
import '../utils/commom_dialog.dart';

class AllCartScreen extends StatelessWidget {
  const AllCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carts'),
      ),
      body: BlocConsumer<AllCartBloc, AllCartState>(
        listener: (context, state) {
          if (state is AllCartErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error: '),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AllCartUpdatedState) {
            DialogUtils.showUpdateDialog(context, "hjrfhjf");
          }
        },
        builder: (context, state) {
          if (state is AllCartLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AllCartLoadedState) {
            return ListView.builder(
              itemCount: state.carts!.length,
              itemBuilder: (context, index) {
                final cart = state.carts![index];
                return Dismissible(
                  key: Key(cart.id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    DialogUtils.showDeleteConfirmationDialog(
                      context,
                      cart.id!,
                      () {
                        context
                            .read<AllCartBloc>()
                            .add(DeleteCartEvent(cartId: cart.id!));
                      },
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartScreen(
                            cartId: cart.id!.toInt(),
                            context: context,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Cart ID: ${cart.id}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: cart.products!.map((product) {
                              return Row(
                                children: [
                                  Image.network(product.thumbnail.toString(),
                                      width: 50, height: 50),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(product.title.toString())),
                                  Text(
                                      '\$${product.total?.toStringAsFixed(2)}'),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}

/*class AllCartScreen extends StatelessWidget {
  const AllCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carts'),
      ),
      body: BlocConsumer<AllCartBloc, AllCartState>(
        listener: (context, state) {
          if (state is AllCartErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: '),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AllCartUpdatedState) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Update'),
                content: Text(state.message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AllCartLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AllCartLoadedState) {
            return ListView.builder(
              itemCount: state.carts!.length,
              itemBuilder: (context, index) {
                final cart = state.carts![index];
                return Dismissible(
                  key: Key(cart.id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    context
                        .read<AllCartBloc>()
                        .add(DeleteCartEvent(cartId: cart.id!));
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CartScreen(cartId: cart.id!.toInt()),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Cart ID: ${cart.id}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => EditCartDialog(
                                        cartId: cart.id!,
                                      ),
                                    );
                                  }),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: cart.products!.map((product) {
                              return Row(
                                children: [
                                  Image.network(product.thumbnail.toString(),
                                      width: 50, height: 50),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(product.title.toString())),
                                  Text(
                                      '\$${product.discountedTotal.toStringAsFixed(2)}'),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}*/
/// with cross button
/*class AllCartScreen extends StatelessWidget {
  const AllCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carts'),
      ),
      body: BlocConsumer<AllCartBloc, AllCartState>(
        listener: (context, state) {
          if (state is AllCartErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.errMsg}'),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is AllCartDeletedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cart deleted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AllCartLoadingState || state is AllCartDeletingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AllCartLoadedState) {
            return ListView.builder(
              itemCount: state.carts!.length,
              itemBuilder: (context, index) {
                final cart = state.carts![index];
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CartScreen(cartId: cart.id!.toInt()),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Cart ID: ${cart.id}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.red),
                                    onPressed: () {
                                      print("----cart id---${cart.id}");
                                      context.read<AllCartBloc>().add(
                                          DeleteCartEvent(cartId: cart.id!));
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: cart.products!.map((product) {
                                  return Row(
                                    children: [
                                      Image.network(
                                        product.thumbnail.toString(),
                                        width: 50,
                                        height: 50,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                          child:
                                              Text(product.title.toString())),
                                      Text(
                                          '\$${product.discountedTotal.toStringAsFixed(2)}'),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}*/
