// product_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/paginationBloc/page_bloc.dart';
import '../Bloc/paginationBloc/page_event.dart';
import '../Bloc/paginationBloc/page_state.dart';

class PageScreen extends StatefulWidget {
  @override
  _PageScreenState createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  final ScrollController _scrollController = ScrollController();
  late PageBloc _pageBloc;

  @override
  void initState() {
    super.initState();
    _pageBloc = BlocProvider.of<PageBloc>(context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_pageBloc.state is PageLoaded &&
            (_pageBloc.state as PageLoaded).hasMore) {
          final currentPage =
              (_pageBloc.state as PageLoaded).products.length ~/ 10 + 1;
          _pageBloc.add(LoadMoreProducts());
        }
      }
    });

    _pageBloc.add(FetchProducts(10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: BlocBuilder<PageBloc, PageState>(
        builder: (context, state) {
          if (state is PageLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PageError) {
            return Center(child: Text(state.message));
          } else if (state is PageLoaded) {
            final products = state.products;
            return ListView.builder(
              controller: _scrollController,
              itemCount: products.length + 1,
              itemBuilder: (context, index) {
                if (index < products.length) {
                  final product = products[index];
                  return ListTile(
                    title: Text(product.title.toString()),
                    subtitle: Text('\$${product.price}'),
                    leading: Image.network(product.thumbnail.toString()),
                  );
                } else {
                  return state.hasMore
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox.shrink();
                }
              },
            );
          } else {
            return Center(child: Text('No products found'));
          }
        },
      ),
    );
  }
}
