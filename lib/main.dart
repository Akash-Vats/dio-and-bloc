import 'package:dumyjsonapi/Bloc/Allproduct/product_bloc.dart';
import 'package:dumyjsonapi/Bloc/allCartBloc/allCartbloc.dart';
import 'package:dumyjsonapi/Screen/All_ProductScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Bloc/paginationBloc/page_bloc.dart';
import 'Bloc/singlecartbloc/single_bloc.dart';
import 'Screen/get_all_carts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AllCartBloc>(
          create: (context) => AllCartBloc(),
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(),
        ),
        BlocProvider<PageBloc>(
          create: (context) => PageBloc(),
        ),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home:  AllCartScreen()),
    );
  }
}
