import 'package:equatable/equatable.dart';

class CartListModel extends Equatable {
  List<CartModel>? carts;
  int? total;
  int? skip;
  int? limit;

  CartListModel({this.carts, this.total, this.skip, this.limit});

  CartListModel.fromJson(Map<String, dynamic> json) {
    if (json['carts'] != null) {
      carts = <CartModel>[];
      json['carts'].forEach((v) {
        carts!.add(new CartModel.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.carts != null) {
      data['carts'] = this.carts!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['skip'] = this.skip;
    data['limit'] = this.limit;
    return data;
  }

  @override
  List<Object?> get props => [
        carts,
        total,
        skip,
        limit,
      ];
}

class CartModel extends Equatable {
  int? id;
  List<Product>? products;
  num? total;
  num? discountedTotal;
  int? userId;
  int? totalProducts;
  int? totalQuantity;
  bool? isDeleted;
  String? deletedOn;

  CartModel(
      {this.id,
      this.products,
      this.total,
      this.discountedTotal,
      this.userId,
      this.totalProducts,
      this.totalQuantity,
      this.isDeleted,
      this.deletedOn});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      products: (json['products'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
      total: json['total'].toDouble(),
      discountedTotal: json['discountedTotal'].toDouble(),
      userId: json['userId'],
      totalProducts: json['totalProducts'],
      totalQuantity: json['totalQuantity'],
      isDeleted: json['isDeleted'],
      deletedOn: json['deletedOn'],
    );
  }

  CartModel copyWith({
    int? id,
    List<Product>? products,
    num? total,
    num? discountedTotal,
    int? userId,
    int? totalProducts,
    int? totalQuantity,
  }) {
    return CartModel(
      id: id ?? this.id,
      products: products ?? this.products,
      total: total ?? this.total,
      discountedTotal: discountedTotal ?? this.discountedTotal,
      userId: userId ?? this.userId,
      totalProducts: totalProducts ?? this.totalProducts,
      totalQuantity: totalQuantity ?? this.totalQuantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'products': products?.map((product) => product.toJson()).toList(),
      'total': total,
      'discountedTotal': discountedTotal,
      'userId': userId,
      'totalProducts': totalProducts,
      'totalQuantity': totalQuantity,
      'isDeleted': isDeleted,
      'deletedOn': deletedOn,
    };
  }

  List<Map<String, dynamic>> updateCartApi() {
    final updatedProducts = (products ?? []).map((product) {
      return product.toJsonApi();
    }).toList();
    return updatedProducts;
  }

  CartModel incrementProductQuantity(String productId) {
    final updatedProducts = products?.map((product) {
      if (product.id.toString() == productId) {
        return product.updateQuantity((product.quantity ?? 0) + 1);
      }
      return product;
    }).toList();

    final updatedTotal = updatedProducts?.fold(
        0, (sum, product) => sum + (product.total ?? 0).toInt());
    final updatedDiscountedTotal = updatedProducts?.fold(
        0, (sum, product) => sum + (product.discountedTotal ?? 0).toInt());
    final updatedTotalQuantity = updatedProducts?.fold(
        0, (sum, product) => sum + (product.quantity ?? 0).toInt());
    final updatedTotalProducts = updatedProducts?.length;

    return copyWith(
      products: updatedProducts,
      total: updatedTotal,
      discountedTotal: updatedDiscountedTotal,
      totalQuantity: updatedTotalQuantity,
      totalProducts: updatedTotalProducts,
    );
  }

  CartModel decrementProductQuantity(String productId) {
    final updatedProducts = products?.map((product) {
      if (product.id.toString() == productId && (product.quantity ?? 0) > 0) {
        return product.updateQuantity((product.quantity ?? 0) - 1);
      }
      return product;
    }).toList();

    final updatedTotal = updatedProducts?.fold(
        0, (sum, product) => sum + (product.total ?? 0).toInt());
    final updatedDiscountedTotal = updatedProducts?.fold(
        0, (sum, product) => sum + (product.discountedTotal ?? 0).toInt());
    final updatedTotalQuantity = updatedProducts?.fold(
        0, (sum, product) => sum + (product.quantity ?? 0).toInt());
    final updatedTotalProducts = updatedProducts?.length;

    return copyWith(
      products: updatedProducts,
      total: updatedTotal,
      discountedTotal: updatedDiscountedTotal,
      totalQuantity: updatedTotalQuantity,
      totalProducts: updatedTotalProducts,
    );
  }

  @override
  List<Object?> get props => [
        id,
        products,
        total,
        discountedTotal,
        userId,
        totalProducts,
        totalQuantity,
      ];
}

class Product extends Equatable {
  final int? id;
  final String? title;
  final num? price;
  final int? quantity;
  final num? total;
  final num? discountPercentage;
  final num? discountedTotal;
  final String? thumbnail;

  Product({
    this.id,
    this.title,
    this.price,
    this.quantity,
    this.total,
    this.discountPercentage,
    this.discountedTotal,
    this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price']?.toDouble(),
      quantity: json['quantity'],
      total: json['total']?.toDouble(),
      discountPercentage: json['discountPercentage']?.toDouble(),
      discountedTotal: json['discountedTotal']?.toDouble(),
      thumbnail: json['thumbnail'],
    );
  }

  Product copyWith({
    int? id,
    String? title,
    num? price,
    int? quantity,
    num? total,
    num? discountPercentage,
    num? discountedTotal,
    String? thumbnail,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      discountedTotal: discountedTotal ?? this.discountedTotal,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }

  Product updateQuantity(int newQuantity) {
    final newTotal = (price ?? 0) * newQuantity;
    final newDiscountedTotal =
        newTotal - (newTotal * (discountPercentage ?? 0) / 100);
    return copyWith(
      quantity: newQuantity,
      total: newTotal,
      discountedTotal: newDiscountedTotal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'quantity': quantity,
      'total': total,
      'discountPercentage': discountPercentage,
      'discountedTotal': discountedTotal,
      'thumbnail': thumbnail,
    };
  }

  Map<String, dynamic> toJsonApi() {
    return {
      'id': id,
      'quantity': quantity,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        price,
        quantity,
        total,
        discountPercentage,
        discountedTotal,
        thumbnail,
      ];
}
