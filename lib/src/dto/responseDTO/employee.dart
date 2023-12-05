// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class EmployeeList {
  List<Employee>? listaEmployee;

  EmployeeList({this.listaEmployee});

  factory EmployeeList.fromMap(jsonArray) {
    final List<dynamic> dataList = jsonDecode(jsonArray);

    final employeeList = <Employee>[];

    for (var element in dataList) {
      employeeList.add(Employee.fromJson(element));
    }

    return EmployeeList(
      listaEmployee: employeeList.isNotEmpty ? employeeList : null,
    );
  }
}

class Employee {
  int? id;
  String? name;
  dynamic salary;
  dynamic id_employee_type;

  Employee({
    this.id,
    this.name,
    this.salary,
    this.id_employee_type,
  });

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    salary = json['salary'];
    id_employee_type = json['id_employee_type'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['salary'] = salary;
    data['id_employee_type'] = id_employee_type;
    return data;
  }
}

class EmployeeTypeList {
  List<EmployeeType>? listaEmployeeType;

  EmployeeTypeList({this.listaEmployeeType});

  factory EmployeeTypeList.fromMap(jsonArray) {
    final List<dynamic> dataList = jsonDecode(jsonArray);

    final employeeListType = <EmployeeType>[];

    for (var element in dataList) {
      employeeListType.add(EmployeeType.fromJson(element));
    }

    return EmployeeTypeList(
      listaEmployeeType: employeeListType.isNotEmpty ? employeeListType : null,
    );
  }
}

class EmployeeType {
  int? id;
  String? nom_type;
  String? desc;
  bool? estado;

  EmployeeType({
    this.id,
    this.nom_type,
    this.desc,
    this.estado,
  });

  EmployeeType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom_type = json['nom_type'];
    desc = json['desc'];
    estado = json['estado'] == 1 ? true : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['nom_type'] = nom_type;
    data['desc'] = desc;
    data['estado'] = estado;
    return data;
  }
}
