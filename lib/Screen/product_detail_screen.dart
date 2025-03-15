import 'package:dumyjsonapi/Bloc/Allproduct/product_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/Allproduct/product_bloc.dart';
import '../Bloc/Allproduct/product_state.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int productId;

  final BuildContext context;

  ProductDetailsScreen(
      {super.key, required this.context, required this.productId}) {
    getRefresh(context);
  }

  void getRefresh(BuildContext context) {
    context.read<ProductBloc>().add(DetailEvent(id: productId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => getRefresh(context),
        child: BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductErrorState) {}
          },
          builder: (context, state) {
            if (state is ProductLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductDetailsState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        state.productsModel!.thumbnail.toString(),
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, color: Colors.red);
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      state.productsModel!.title.toString(),
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      state.productsModel!.description.toString(),
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Price: \$${state.productsModel!.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          'Rating: ${state.productsModel!.rating.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      'ReturnPolicy: \$${state.productsModel!.returnPolicy}',
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'minimumOrderQuantity: ${state.productsModel!.minimumOrderQuantity}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('No data'));
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Handle Buy button action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product purchased'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange, // Text color
                padding:
                    const EdgeInsets.symmetric(horizontal: 70, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Buy Now'),
            ),
          ],
        ),
      ),
    );
  }
}
