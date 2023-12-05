import 'package:client_flutter_crud_node/src/apis/product_service.dart';
import 'package:flutter/material.dart';

import '../apis/employee_service.dart';
import '../dto/responseDTO/employee.dart';
import '../dto/responseDTO/product.dart';

class AppStateProvider extends ChangeNotifier {
  //IS LOADING
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  } //IS LOADING

  AppStateProvider();

  EmployeeTypeList? employeeTypeListService;
  List<Categoria>? categorias;

  Future getAllEmployeeTypes() async {
    _isLoading = true;

    employeeTypeListService = await EmployeeService().getAllEmployeeTypes();
    //notifyListeners();

    if (employeeTypeListService != null) {
      isLoading = false;
    } else {
      isLoading = false;
      return;
    }
  }

  Future getAllCategories(int id) async {
    _isLoading = true;

    categorias = await ProductService().getAllCategories(id);

    if (categorias != null) {
      isLoading = false;
    } else {
      isLoading = false;
      return;
    }
  }
}
