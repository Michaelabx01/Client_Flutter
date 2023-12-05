import 'package:flutter/material.dart';

import '../apis/user_service.dart';
import '../dto/responseDTO/UiResponse.dart';
import '../dto/responseDTO/login.dart';
import '../dto/responseDTO/user_data_dto.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  UserData? userAcceso;

  Future<List<Object>> accessLogin(String user, String contrasenia) async {
    isLoading = true;

    await Future.delayed(const Duration(seconds: 2));

    Login? login = await UserService().login(user, contrasenia);

    if (login != null) {
      isLoading = false;
      if (login.userData != null) {
        userAcceso = login.userData;
        return [1, "Ingresando al Sistema"];
      } else {
        return [2, "Accesos denegados!!!"];
      }
    } else {
      isLoading = false;
      return [3, "Error del servidor!!!"];
    }
  }

  Future<List<Object>> registerUser(UserData userData) async {
    isLoading = true;

    UiResponse? response = await UserService().registerOrEditUser(userData);

    if (response != null) {
      isLoading = false;
      if (response.state == true) {
        return [1, "Registrado"];
      } else {
        return [2, response.response!.error!];
      }
    } else {
      isLoading = false;
      return [3, "Error del servidor!!!"];
    }
  }
}
