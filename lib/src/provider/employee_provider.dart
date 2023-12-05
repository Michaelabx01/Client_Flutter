import 'package:flutter/material.dart';
import '../apis/employee_service.dart';
import '../dto/responseDTO/employee.dart';

class EmployeeProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  EmployeeList? employeeListService;
  Employee? employeeService;

  Future<void> getAllEmployee() async {
    isLoading = true;

    employeeListService = await EmployeeService().getAllUsers();

    if (employeeListService != null) {
      isLoading = false;
    } else {
      isLoading = false;
      return;
    }
  }

  Future getEmployeeById(int id) async {
    isLoading = true;

    employeeService = await EmployeeService().getUsersById(id);

    if (employeeService != null) {
      isLoading = false;
    } else {
      isLoading = false;
      return;
    }
  }

  Future<bool> deleteEmployeeById(int id) async {
    isLoading = true;

    bool rptaDelete = false;

    rptaDelete = await EmployeeService().deleteUserById(id);

    if (rptaDelete) {
      isLoading = false;
      return true;
    } else {
      isLoading = false;
      return false;
    }
  }

  Future<bool> addEmployeeOrEdit(Employee employee) async {
    isLoading = true;
    bool rptaEditDelete = false;
    rptaEditDelete = await EmployeeService().addEmployeeOrEdit(employee);
    if (rptaEditDelete) {
      isLoading = false;
      return true;
    } else {
      isLoading = false;
      return false;
    }
  }
}
