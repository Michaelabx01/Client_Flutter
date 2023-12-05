// ignore_for_file: constant_identifier_names, duplicate_ignore, prefer_interpolation_to_compose_strings, avoid_print

import 'dart:convert';

import 'package:client_flutter_crud_node/src/dto/responseDTO/employee.dart';
import 'package:http/http.dart' as http;

import 'config_host.dart';

class EmployeeService {
  final String _apiHost = AppData().hostNodeServer;
  // ignore: constant_identifier_names
  static const String _routePath_getAllUser = "/getAllEmployee";
  static const String _routePath_getAllEmplopyeeType = "/getAllEmployeeType";
  static const String _routePath_getUserByID = "/findEmployee/";
  static const String _routePath_deleteUserByID = "/deleteEmployee/";
  static const String _routePath_addEmployeeOrEdit = "/AddEmployeeOrEdit/";

  EmployeeService();

  Future<EmployeeList?> getAllUsers() async {
    try {
      final response =
          await http.get(Uri.https(_apiHost, _routePath_getAllUser));
      print("API" + response.statusCode.toString());
      if (response.statusCode == 200) {
        return EmployeeList.fromMap(response.body);
      }
    } catch (e) {
      print("ERROR $_routePath_getAllUser: $e");
    }
    return null;
  }

  Future<EmployeeTypeList?> getAllEmployeeTypes() async {
    try {
      final response =
          await http.get(Uri.https(_apiHost, _routePath_getAllEmplopyeeType));
      print("API" + response.statusCode.toString());
      if (response.statusCode == 200) {
        return EmployeeTypeList.fromMap(response.body);
      }
    } catch (e) {
      print("ERROR $_routePath_getAllEmplopyeeType: $e");
    }
    return null;
  }

  Future<Employee?> getUsersById(int id) async {
    try {
      final response = await http.get(
        Uri.https(
          _apiHost,
          (_routePath_getUserByID + id.toString()),
        ),
      );
      print("API" + response.statusCode.toString());
      if (response.statusCode == 200) {
        return Employee.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("ERROR $_routePath_getUserByID: $e");
    }
    return null;
  }

  Future<bool> deleteUserById(int id) async {
    try {
      final response = await http.delete(
        Uri.https(
          _apiHost,
          (_routePath_deleteUserByID + id.toString()),
        ),
      );
      print("API" + response.statusCode.toString());
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print("ERROR $_routePath_deleteUserByID: $e");
    }
    return false;
  }

  Future<bool> addEmployeeOrEdit(Employee employee) async {
    try {
      final response = await http.post(
        Uri.https(
          _apiHost,
          (_routePath_addEmployeeOrEdit),
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(employee.toJson()),
      );
      print("API" + response.statusCode.toString());
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print("ERROR $_routePath_addEmployeeOrEdit: $e");
    }
    return false;
  }
}
