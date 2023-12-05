import 'dart:convert';
import 'package:http/http.dart' as http;

import '../dto/responseDTO/login.dart';
import '../dto/responseDTO/UiResponse.dart';
import '../dto/responseDTO/user_data_dto.dart';
import 'config_host.dart';

class UserService {
  final String _apiHost = AppData().hostNodeServer;
  static const String _routePath_login = "/login";
  static const String _routePath_AddUserOrEdit = "/AddUserOrEdit";

  UserService();

  Future<Login?> login(
    String user,
    String contrasenia,
  ) async {
    try {
      var headers = {
        'accept': 'text/plain',
        'Content-Type': 'application/json',
      };
      final body = jsonEncode(
        {
          "user": user,
          "contrasenia": contrasenia,
        },
      );

      final response = await http.post(
        Uri.https(_apiHost, _routePath_login),
        headers: headers,
        body: body,
      );
      print("API login ${response.statusCode}");
      if (response.statusCode == 200) {
        return Login.fromMap(jsonDecode(response.body));
      }
    } catch (e) {
      print("ERROR $_routePath_login: $e");
      return null;
    }
  }

  Future<UiResponse?> registerOrEditUser(UserData userReqAddEditBody) async {
    try {
      var headers = {
        'accept': 'text/plain',
        'Content-Type': 'application/json',
      };

      final body = jsonEncode(userReqAddEditBody);

      final response = await http.post(
        Uri.https(_apiHost, _routePath_AddUserOrEdit),
        headers: headers,
        body: body,
      );
      print("API" + response.statusCode.toString());
      if (response.statusCode == 200) {
        return UiResponse.fromMap(jsonDecode(response.body));
      }
    } catch (e) {
      print("ERROR $_routePath_AddUserOrEdit: $e");
      return null;
    }
    return null;
  }
}
