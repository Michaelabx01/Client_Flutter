import 'package:client_flutter_crud_node/src/pages/Navigator/edit_or_create_employee.dart';
import 'package:client_flutter_crud_node/src/pages/Navigator/edit_or_create_product.dart';
import 'package:client_flutter_crud_node/src/pages/Navigator/manage_employee.dart';
import 'package:client_flutter_crud_node/src/pages/login_page.dart';
import 'package:client_flutter_crud_node/src/pages/register_page.dart';
import 'package:client_flutter_crud_node/src/provider/app_state_provider.dart';
import 'package:client_flutter_crud_node/src/provider/employee_provider.dart';
import 'package:client_flutter_crud_node/src/provider/product_provider.dart';
import 'package:client_flutter_crud_node/src/provider/products_in_out_provider.dart';
import 'package:client_flutter_crud_node/src/provider/user_provider.dart';
import 'package:client_flutter_crud_node/test/bar_code.dart';
import 'package:client_flutter_crud_node/test/incrementador.dart';
import 'package:client_flutter_crud_node/test/refresh_basic.dart';
import 'package:client_flutter_crud_node/test/refresh_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'src/pages/home_page.dart';
import 'src/utils/my_colors.dart';

void main() {
  //for splash screen time delay
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //for splash screen time delay

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppStateProvider()),
        ChangeNotifierProvider(create: (context) => EmployeeProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => ProductsInOutProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: MyColors.primaryColor, fontFamily: 'Roboto'),
        debugShowCheckedModeBanner: false,
        // title: 'Gestion Productos',
        initialRoute: 'login',
        routes: {
          'incrementador': (_) => const IncrementadorPage(),
          'home': (_) => const HomePage(),
          'manageEmployee': (_) => const ManageEmployeePage(),
          'login': (_) => const LoginPage(),
          'barcode': (_) => const BarCodePage(),
          'edit/create': (_) => const EditOrCreateEmployeePage(),
          'refreshFutBuild': (_) => const RefreshFutBuild(),
          'refreshBasic': (_) => const RefreshBasic(),
          'register': (_) => const RegisterPage(),
          'edit/create_product': (_) => EditOrCreateProduct(),
        },
      ),
    );
  }
}
