// ignore_for_file: no_leading_underscores_for_local_identifiers, non_constant_identifier_names, prefer_interpolation_to_compose_strings, unused_element

import 'package:client_flutter_crud_node/src/provider/app_state_provider.dart';
import 'package:client_flutter_crud_node/src/provider/employee_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../dto/responseDTO/employee.dart';

class ManageEmployeePage extends StatefulWidget {
  const ManageEmployeePage({Key? key}) : super(key: key);

  @override
  State<ManageEmployeePage> createState() => _ManageEmployeePageState();
}

class _ManageEmployeePageState extends State<ManageEmployeePage> {
  late List<DropdownMenuItem> dropDownMenuItems = [];
  int currentData = 0;
  // dynamic employeeProviderInit;

  List<DropdownMenuItem> getDropDownMenuItems(List<dynamic> typesEmployee) {
    List<DropdownMenuItem> items = [];
    for (EmployeeType employeeType in typesEmployee) {
      items.add(DropdownMenuItem(
        value: employeeType.id,
        child: Text(employeeType.nom_type!),
        onTap: () {
          Fluttertoast.showToast(msg: employeeType.nom_type!);
        },
      ));
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
  }

  void changedDropDownItem(dynamic value) {
    setState(() {
      currentData = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // var appStateProvider = Provider.of<AppStateProvider>(context);
    var employeeProvider = Provider.of<EmployeeProvider>(context);

    Widget _buildBody() {
      if (employeeProvider.isLoading) {
        return ListView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: const [
            Center(
              heightFactor: 20,
              child: CircularProgressIndicator(),
            )
          ],
        );
      } else if (employeeProvider.employeeListService == null) {
        return ListView(
          children: const [Text("NO DATA, THERES NO CONECTION WITH SERVER")],
        );
      } else if (employeeProvider.employeeListService!.listaEmployee == null) {
        return ListView(
          children: const [Center(child: Text("NO DATA"))],
        );
      } else {
        EmployeeList? employeeList = employeeProvider.employeeListService;

        return ListView.builder(
          itemCount: employeeList!.listaEmployee!.length,
          itemBuilder: (context, index) {
            int id = employeeList.listaEmployee![index].id!;
            String id_employee_type =
                employeeList.listaEmployee![index].id_employee_type!.toString();

            return ListTile(
              onTap: () async {
                await employeeProvider.getEmployeeById(id).then((value) {
                  if (employeeProvider.employeeService != null) {
                    Navigator.pushNamed(context, "edit/create");
                  }
                });
              },
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (_) => CupertinoAlertDialog(
                          insetAnimationCurve: Curves.bounceIn,
                          title: const Text("Eliminar Empleado"),
                          content: Text(
                              "¿Estas seguro de eliminar al usuario ${employeeList.listaEmployee![index].name!}? "),
                          actions: [
                            TextButton(
                              onPressed: () {
                                employeeProvider.deleteEmployeeById(id);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Eliminar",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancelar",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ));
              },
              title: Text(
                employeeList.listaEmployee![index].name! +
                    " " +
                    employeeList.listaEmployee![index].salary!.toString(),
              ),
              subtitle: Text(
                employeeList.listaEmployee![index].id!.toString(),
              ),
              leading: CircleAvatar(
                child: Text(
                  id_employee_type.length >= 3
                      ? id_employee_type.substring(0, 3)
                      : id_employee_type,
                ),
              ),
              trailing: const Icon(
                Icons.touch_app_outlined,
                color: Colors.red,
              ),
            );
          },
        );
      }
    }

    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   leading: _backAppBar(context),
      //   title: Text(widget.title),
      // ),
      body: Column(
        children: [
          Visibility(
            visible: true,
            child: SizedBox(
              width: double.infinity,
              child: Material(
                color: Colors.white,
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, right: 10, bottom: 15, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // if (employeeProviderMain.employeeTypeListService != null)
                      //   comboBox(dropDownMenuItems, employeeProviderMain)
                      Consumer<AppStateProvider>(
                          builder: (context, appStateProvider, child) {
                        // print(
                        //     "DATA ${appStateProvider.employeeTypeListService}");
                        // if (appStateProvider.employeeTypeListService!
                        //     .listaEmployeeType!.isEmpty) {
                        //   return Container(
                        //     color: Colors.amber[200],
                        //     child: const Text("COMBO VACIO"),
                        //   );
                        // } else {
                        dropDownMenuItems = getDropDownMenuItems(
                            appStateProvider
                                .employeeTypeListService!.listaEmployeeType!);

                        currentData = currentData == 0
                            ? appStateProvider.employeeTypeListService!
                                .listaEmployeeType![0].id!
                            : currentData;

                        print("VALUE CURRENT: $currentData");

                        return comboBox(dropDownMenuItems);
                      })
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: RefreshIndicator(
              //INIDCAMOS QUE LA RECARGA SERA EN CUALQUIER PARTE DEL CUERPO DE LA LISTA
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              edgeOffset: 20,
              displacement: 150,
              color: Colors.blueGrey[900],
              backgroundColor: Colors.lightBlueAccent[70],
              onRefresh: employeeProvider.getAllEmployee,
              child: _buildBody(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          employeeProvider.employeeService = null;
          Navigator.pushNamed(context, "edit/create");
        },
        tooltip: "Agregar Empleado",
        child: const Icon(Icons.add),
      ),
    );
  }

  CircleAvatar _backAppBar(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new,
            color: Colors.blueAccent, size: 32),
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => CupertinoAlertDialog(
                    insetAnimationCurve: Curves.bounceIn,
                    title: const Text("Cerrar Sesion"),
                    content: const Text("¿Estas seguro de Cerrar Sesion? "),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "login");
                        },
                        child: const Text(
                          "Cerrar Sesion",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ));
        },
      ),
    );
  }

  Container comboBox(List<DropdownMenuItem> items) {
    return items.isNotEmpty
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blueAccent, width: 4)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  iconSize: 50,
                  isExpanded: true,
                  value: currentData,
                  items: items,
                  onChanged: changedDropDownItem),
            ),
          )
        : Container(color: Colors.blue, child: const Text("NO TYPE"));
  }
}
