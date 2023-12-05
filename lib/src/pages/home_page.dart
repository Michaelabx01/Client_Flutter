import 'package:client_flutter_crud_node/src/pages/Navigator/almacen.dart';
import 'package:client_flutter_crud_node/src/pages/Navigator/inicio_page.dart';
import 'package:client_flutter_crud_node/src/pages/Navigator/manage_employee.dart';
import 'package:client_flutter_crud_node/src/provider/employee_provider.dart';
import 'package:client_flutter_crud_node/src/provider/user_provider.dart';
import 'package:client_flutter_crud_node/src/widgets/CupertinoDialogCustom.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../test/bar_code.dart';
import '../../test/incrementador.dart';
import '../provider/products_in_out_provider.dart';
import 'Navigator/ingreso_compra.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index_page = 0;
  final screens = [
    const IncrementadorPage(),
    const AlmacenGestion(),
    const ManageEmployeePage(),
    const IngresoAlmacen(),
    const BarCodePage(),
  ];

  final screensTitle = [
    'DashBoard',
    'Almacen',
    'Gestion',
    'Ingreso Productos',
    'Salida Productos',
  ];

  @override
  Widget build(BuildContext context) {
    var productSelectedProvider = Provider.of<ProductsInOutProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);

    Future<bool> showExitPopup() async {
      return await CupertinoAlertDialogCustom().showCupertinoAlertDialog(
              title: "Cerrar Sesion",
              msg: "¿Estas seguro de Cerrar Sesion?",
              context: context,
              onPressedNegative: () {
                Navigator.of(context).pop(false);
              },
              onPressedPositive: () {
                productSelectedProvider.cleanShoppingCart();
                userProvider.userAcceso = null;
                Navigator.pushReplacementNamed(context, "login");
              }) ??
          false;
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("${screensTitle[index_page]} - LOAsi"),
          actions: [
            Container(
              padding: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundColor: Colors.red[100],
                child: IconButton(
                  tooltip: "Cerrar sesion",
                  icon: Icon(
                    Icons.logout,
                    color: Colors.red[300],
                    size: 30,
                  ),
                  onPressed: () {
                    CupertinoAlertDialogCustom().showCupertinoAlertDialog(
                      title: "Cerrar Sesion",
                      msg: "¿Estas seguro de Cerrar Sesion?",
                      onPressedPositive: () {
                        productSelectedProvider.cleanShoppingCart();
                        userProvider.userAcceso = null;
                        Navigator.pushNamed(context, "login");
                      },
                      onPressedNegative: () {
                        Navigator.pop(context);
                      },
                      context: context,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: screens[index_page],
        bottomNavigationBar: GNav(
          backgroundColor: Colors.black,
          rippleColor: Colors.grey[200]!,
          hoverColor: Colors.grey[200]!,
          // haptic: true,
          tabBorderRadius: 15,
          tabActiveBorder:
              Border.all(color: Colors.black, width: 1), // tab button border
          tabBorder:
              Border.all(color: Colors.grey, width: 1), // tab button border
          tabShadow: [
            BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 8)
          ], // tab button shadow
          curve: Curves.easeOutExpo, // tab animation curves
          duration: const Duration(milliseconds: 200), // tab animation duration
          gap: 2, // the tab button gap between icon and text
          color: Colors.black, // unselected icon color
          activeColor: Colors.blue[900], // selected icon and text color
          iconSize: 40, // tab button icon size
          textSize: 100,
          // style: GnavStyle.google,
          tabBackgroundColor:
              Colors.lightBlueAccent[200]!, // selected tab background color
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
          tabs: [
            GButton(
              icon: Icons.home_filled,
              text: screensTitle[index_page],
              iconColor: index_page != 0 ? Colors.orange : Colors.black,
            ),
            GButton(
              icon: Icons.check_box,
              text: screensTitle[index_page],
              iconColor: index_page != 1 ? Colors.green : Colors.black,
            ),
            GButton(
              icon: Icons.precision_manufacturing_outlined,
              text: screensTitle[index_page],
              iconColor: index_page != 2 ? Colors.grey[700] : Colors.black,
            ),
            GButton(
              icon: Icons.file_upload,
              text: screensTitle[index_page],
              iconColor: index_page != 3 ? Colors.blue : Colors.black,
            ),
            GButton(
              icon: Icons.download,
              text: screensTitle[index_page],
              iconColor: index_page != 4 ? Colors.red : Colors.black,
            ),
          ],
          // selectedIndex: index_page,
          onTabChange: (index) {
            setState(() {
              index_page = index;
            });
          },
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   type: BottomNavigationBarType.fixed,
        //   elevation: 5,
        //   items: <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: Icon(
        //         Icons.home_filled,
        //         color: index == 0 ? Colors.orange : Colors.black,
        //       ),
        //       label: 'Dashboard',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(
        //         Icons.check_box,
        //         color: index == 1 ? Colors.green : Colors.black,
        //       ),
        //       label: 'Inventario',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(
        //         Icons.precision_manufacturing_outlined,
        //         color: index == 2 ? Colors.green : Colors.black,
        //       ),
        //       label: 'Gestion Almacen',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(
        //         Icons.file_upload,
        //         color: index == 3 ? Colors.blue : Colors.black,
        //       ),
        //       label: 'Ingreso',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(
        //         Icons.download,
        //         color: index == 4 ? Colors.orange : Colors.black,
        //       ),
        //       label: 'Retiro',
        //     ),
        //   ],
        //   iconSize: 25,
        //   backgroundColor: Colors.lightBlueAccent[500],
        //   currentIndex: index,
        //   unselectedItemColor: Colors.black,
        //   selectedFontSize: 15,
        //   selectedItemColor: Colors.blue,
        //   onTap: (index) => setState(() => this.index = index),
        // ),
      ),
    );
  }
}
