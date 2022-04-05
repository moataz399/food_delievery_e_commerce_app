import 'package:flutter/material.dart';
import 'package:food_delievery_app/controllers/cart_controller.dart';
import 'package:food_delievery_app/data/repository/popular_product_repo.dart';
import 'package:food_delievery_app/models/product_models.dart';
import 'package:food_delievery_app/utils/colors.dart';
import 'package:get/get.dart';

class PopularProductController extends GetxController {
  final PopularProductRepo popularProductRepo;

  PopularProductController({required this.popularProductRepo});

  late CartController _cartController;
  List<dynamic> _popularList = [];

  List<dynamic> get popularProductList => _popularList;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  int _quantity = 0;

  int get quantity => _quantity;

  int _inCartItems = 0;

  int get inCartItems => _inCartItems + _quantity;

  Future<void> getPopularProductList() async {
    Response response = await popularProductRepo.getPopularProductList();

    if (response.statusCode == 200) {
      _popularList = [];
      _popularList.addAll(Product.fromJson(response.body).products);
      _isLoaded = true;
      update();
    } else {
      print(" status code = ${response.statusCode}");
      print('popular products error ');
    }
  }

  void setQuantity(bool isIncrement) {
    print("increment" + _quantity.toString());
    if (isIncrement) {
      _quantity = checkQuantity(_quantity + 1);
    } else {
      _quantity = checkQuantity(_quantity - 1);
    }
    update();
  }

  int checkQuantity(int quantity) {
    if (quantity < 0) {
      Get.snackbar('Item count ', "you can't reduce more ",
          backgroundColor: AppColors.mainColor, colorText: Colors.white);
      return 0;
    } else if (quantity > 20) {
      Get.snackbar('Item count ', "you can't add more ",
          backgroundColor: AppColors.mainColor, colorText: Colors.white);
      return 20;
    } else {
      return quantity;
    }
  }

  void initProduct(CartController cartController) {
    _quantity = 0;
    _inCartItems = 0;
    _cartController = cartController;
  }

  void addItem(PopularProductsModel product) {
    _cartController.addItems(product, _quantity);
  }
}
