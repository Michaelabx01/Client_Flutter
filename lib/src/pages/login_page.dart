import 'package:client_flutter_crud_node/src/pages/register_page.dart';
import 'package:client_flutter_crud_node/src/provider/employee_provider.dart';
import 'package:client_flutter_crud_node/src/provider/user_provider.dart';
import 'package:client_flutter_crud_node/src/transitions/left_route.dart';
import 'package:client_flutter_crud_node/src/widgets/CupertinoDialogCustom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/app_state_provider.dart';
import '../provider/product_provider.dart';
import '../utils/my_colors.dart';
import '../widgets/flush_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscureText = true;
  TextEditingController controlUser = TextEditingController();
  TextEditingController controlContrasenia = TextEditingController();

  late UserProvider userProvider;
  late AppStateProvider appStateProvider;
  late EmployeeProvider employeeProvider;
  late ProductProvider productProvider;

  @override
  void initState() {
    super.initState();
    initializationANDRemoveSplashScreen();
    initSharedPreferences();
  }

  void initializationANDRemoveSplashScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }

  void initSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    String? user = prefs.getString('user');
    String? contra = prefs.getString('contrasenia');

    controlUser.text = user ?? '';
    controlContrasenia.text = contra ?? '';
  }

  Future<bool> showExitPopup() async {
    return await CupertinoAlertDialogCustom().showCupertinoAlertDialog(
            title: 'SALIENDO DE LOAsi',
            msg: '¿Quieres cerrar la App?',
            context: context,
            onPressedNegative: () {
              Navigator.of(context).pop(false);
            },
            onPressedPositive: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            }) ??
        false;
  }

  void acederProcess() async {
    FocusScope.of(context).unfocus();
    String controlUserText = controlUser.text.trim();
    String controlContraseniaText = controlContrasenia.text.trim();
    if (controlUserText.isNotEmpty && controlContraseniaText.isNotEmpty) {
      var rpta = await userProvider.accessLogin(
          controlUserText, controlContraseniaText);

      final FocusScopeNode focus = FocusScope.of(context);
      if (!focus.hasPrimaryFocus && focus.hasFocus) {
        //SI EL TECLADO ESTA ACTIVO LO QUITAMOS
        FocusManager.instance.primaryFocus!.unfocus();
      }

      switch (rpta[0]) {
        case 1: //ACCESOS CONCEDIDOS
          if (mounted) {
            FlushBar().snackBarV2(rpta[1].toString(), Colors.green, context);
          }

          final prefs = await SharedPreferences.getInstance();

          await prefs.setString('user', controlUserText);
          await prefs.setString('contrasenia', controlContraseniaText);

          employeeProvider.getAllEmployee();
          productProvider.getAllProducts("", 1);
          appStateProvider.getAllEmployeeTypes();
          appStateProvider.getAllCategories(userProvider.userAcceso!.id!);
          await Future.delayed(const Duration(milliseconds: 2000));
          Navigator.pushNamed(context, "home");
          break;
        case 2: //ACCESOS DENEGADOS
          if (mounted) {
            FlushBar().snackBarV2(rpta[1].toString(), Colors.red, context);
          }
          break;
        case 3: //NO TUVO INFO DEL LOGIN
          if (mounted) {
            FlushBar().snackBarV2(rpta[1].toString(), Colors.red, context);
          }
          break;
        default:
      }
    } else {
      if (mounted) {
        FlushBar()
            .snackBarV2("Usuario y/o contraseña vacias", Colors.red, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    appStateProvider = Provider.of<AppStateProvider>(context);
    employeeProvider = Provider.of<EmployeeProvider>(context);
    productProvider = Provider.of<ProductProvider>(context);

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -5,
                left: -90,
                child: _circularTitleLogin(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _tagLoaSi(),
                  _lottieDeliverMan(),
                  _txtCorreo(),
                  _txtContrasena(),
                  _buttomAcceder(),
                  _txtDontHaveAccount(),
                ],
              ),
              Visibility(
                visible: userProvider.isLoading,
                child: Positioned(
                  top: 1,
                  left: 1,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 1.2,
                    width: MediaQuery.of(context).size.width * 1,
                    color: Colors.blue.withOpacity(0.4),
                    child: Center(
                      child: Container(
                        // margin: EdgeInsets.all(50),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.black,
                        ),
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttomAcceder() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 50,
        vertical: 10,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          primary: MyColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: userProvider.userAcceso == null ? acederProcess : () {},
        child: Text(
          userProvider.userAcceso == null ? "ACCEDER" : "LOGUEADO",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Row _txtDontHaveAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: const Text(
            "¿No tienes cuenta?",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          margin: const EdgeInsets.only(right: 15),
        ),
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                color: MyColors.primaryColor,
                borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              "Registrate",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          onTap: () {
            Navigator.push(context, LeftRoute(page: const RegisterPage()));
          },
        ),
      ],
    );
  }

  Container _txtContrasena() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      // padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: MyColors.secondaryColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextFormField(
        style: const TextStyle(fontSize: 20),
        controller: controlContrasenia,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Contraseña",
          hintStyle: TextStyle(
            color: MyColors.primaryColor,
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.password_outlined,
            color: MyColors.primaryColor,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
            icon: obscureText
                ? Icon(
                    Icons.visibility_rounded,
                    color: MyColors.primaryColor,
                  )
                : const Icon(Icons.visibility_off_rounded),
          ),
        ),
        textInputAction: TextInputAction.done,
        validator: (value) {
          return value!.isEmpty ? 'Email cannot be blank' : null;
        },
      ),
    );
  }

  Container _txtCorreo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      // padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: MyColors.secondaryColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextFormField(
        style: const TextStyle(fontSize: 20),
        controller: controlUser,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Correo electronico",
          hintStyle: TextStyle(
            color: MyColors.primaryColor,
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.alternate_email_outlined,
            color: MyColors.primaryColor,
          ),
        ),
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _lottieDeliverMan() {
    return Container(
      // padding: const EdgeInsets.all(35),
      margin: const EdgeInsets.only(top: 70, bottom: 30),
      child: Lottie.asset(
        'assets/lotties/phoneAppDelivery.json',
        fit: BoxFit.fill,
        // height: 220,
        width: double.infinity,
        alignment: Alignment.bottomCenter,
        repeat: true,
        // reverse: true,
        // animate: true,
      ),
    );
  }

  Widget _circularTitleLogin() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: 150,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: MyColors.primaryColor,
        borderRadius: BorderRadius.circular(100),
      ),
      alignment: Alignment.centerRight,
      child: const Text(
        "LOGIN",
        style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'NimbusSans'),
      ),
    );
  }

  Container _tagLoaSi() {
    return Container(
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.only(top: 40, right: 15),
      decoration: BoxDecoration(
        color: MyColors.primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Text(
        "LOAsi",
        style: TextStyle(
            color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
      ),
    );
  }
}
