import 'package:client_flutter_crud_node/src/provider/app_state_provider.dart';
import 'package:client_flutter_crud_node/src/provider/employee_provider.dart';
import 'package:client_flutter_crud_node/src/transitions/right_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../dto/responseDTO/user_data_dto.dart';
import '../provider/user_provider.dart';
import '../utils/my_colors.dart';
import '../widgets/flush_bar.dart';
import '../widgets/simple_date_picker.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool obscureText = false;

  DateTime now = DateTime.now();
  late String currentDate = DateFormat('yyyy-MM-dd').format(now);
  late String _startTextDate = currentDate;
  String formatStringDate = 'yyyy-MM-dd';

  late DateTime _currentTime;
  late DateTime _startMinDate;
  late DateTime _startMaxDate;
  late DateTime _startCurrentDate;
  late DateTime _endCurrentDate;

  TextEditingController controlNombre = TextEditingController();
  TextEditingController controlApellido = TextEditingController();
  TextEditingController controlDNI = TextEditingController();
  TextEditingController controlTelefono = TextEditingController();
  TextEditingController controlEmail = TextEditingController();
  TextEditingController controlContrasena = TextEditingController();
  TextEditingController controlContrasenaRepeat = TextEditingController();

  UserData? userData;

  void _initDateTimes() {
    final dateNow = DateTime.now();
    _currentTime = DateTime(dateNow.year, dateNow.month, dateNow.day);

    _startCurrentDate = _currentTime;
    _endCurrentDate = _currentTime;
    _endCurrentDate = _endCurrentDate.add(const Duration(seconds: 86399));

    _startMinDate = DateTime(1970);
    _startMaxDate = _currentTime;
  }

  @override
  void initState() {
    super.initState();
    _initDateTimes();
  }

  @override
  Widget build(BuildContext context) {
    var entitiesProvider = Provider.of<UserProvider>(context);
    var appStateProvider = Provider.of<AppStateProvider>(context);
    var employeeProvider = Provider.of<EmployeeProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                top: -80,
                left: -45,
                child: _circularTitleRegister(),
              ),
              Positioned(
                top: 60,
                left: 5,
                child: _registarWithBack(),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 150),
                child: Column(
                  children: [
                    _circleAvatar(),
                    _txtDatos('Nombre', Icons.person_sharp, 50,
                        TextInputType.name, controlNombre),
                    _txtDatos('Apellido', Icons.person_sharp, 50,
                        TextInputType.name, controlApellido),
                    _txtDatos(
                        'DNI',
                        Icons.account_box_outlined,
                        8,
                        const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        controlDNI),
                    _txtDatos(
                        'Telefono',
                        Icons.phone,
                        10,
                        const TextInputType.numberWithOptions(
                            signed: false, decimal: false),
                        controlTelefono),
                    _txtDatos('Correo Electronico', Icons.email, 50,
                        TextInputType.emailAddress, controlEmail),
                    _fecha(),
                    _txtDatosPassword('Contraseña', Icons.password, 15,
                        TextInputType.visiblePassword, controlContrasena),
                    _buttomRegistrar(
                        entitiesProvider, appStateProvider, employeeProvider)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleAvatar() {
    return CircleAvatar(
      radius: 60,
      backgroundImage: const AssetImage('assets/images/user_profile_2.png'),
      backgroundColor: MyColors.secondaryColorOpacity,
    );
  }

  Widget _fecha() {
    return SimpleDatePicker(
      text: _startTextDate,
      minTime: _startMinDate,
      maxTime: _startMaxDate,
      currentTime: _startCurrentDate,
      onConfirm: (date, dateFormatted) {
        print("DATE IPHONE $date && DATEFORMATTED $dateFormatted");
        setState(() {
          _startCurrentDate = date;
          _startTextDate = dateFormatted;
        });
      },
    );
  }

  Widget _registarWithBack() {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              Navigator.push(context, RightRoute(page: const LoginPage()));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        const Text(
          "REGISTRO",
          style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'NimbusSans'),
        ),
      ],
    );
  }

  Widget _circularTitleRegister() {
    return Container(
      width: 240,
      height: 230,
      decoration: BoxDecoration(
        color: MyColors.primaryColor,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  Widget _txtDatos(String label, IconData icon, int maxLength,
      TextInputType type, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.secondaryColorOpacity,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextFormField(
        style: const TextStyle(fontSize: 20),
        controller: controller,
        maxLength: maxLength,
        keyboardType: type,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: MyColors.primaryColor,
          ),
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: MyColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _txtDatosPassword(String label, IconData icon, int maxLength,
      TextInputType type, TextEditingController controller) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: MyColors.secondaryColorOpacity,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextFormField(
        style: const TextStyle(fontSize: 20),
        controller: controller,
        obscureText: obscureText,
        maxLength: maxLength,
        keyboardType: type,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: MyColors.primaryColor,
          ),
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: MyColors.primaryColor,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(
                () => obscureText = !obscureText,
              );
            },
            icon: obscureText
                ? Icon(
                    Icons.visibility_rounded,
                    color: MyColors.primaryColor,
                  )
                : const Icon(Icons.visibility_off_rounded),
          ),
        ),
      ),
    );
  }

  Widget _buttomRegistrar(UserProvider userProvider,
      AppStateProvider appStateProvider, EmployeeProvider employeeProvider) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            primary: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
        onPressed: () {
          if (_validateFormNullSafety()) {
            var rpta = userProvider.registerUser(userData!);

            final FocusScopeNode focus = FocusScope.of(context);
            if (!focus.hasPrimaryFocus && focus.hasFocus) {
              //SI EL TECLADO ESTA ACTIVO LO QUITAMOS
              FocusManager.instance.primaryFocus!.unfocus();
            }

            rpta.then((value) async {
              switch (value[0]) {
                case 1:
                  FlushBar()
                      .snackBarV2(value[1].toString(), Colors.green, context);
                  //AUTO LOGIN
                  employeeProvider.getAllEmployee();
                  appStateProvider.getAllEmployeeTypes();
                  await Future.delayed(const Duration(seconds: 2));
                  Navigator.pushNamed(context, "home");
                  break;
                case 2:
                  FlushBar()
                      .snackBarV2(value[1].toString(), Colors.red, context);
                  break;
                case 3:
                  FlushBar()
                      .snackBarV2(value[1].toString(), Colors.red, context);
                  break;
                default:
              }
            });
          } else {
            FlushBar().snackBarV2("Campos vacios!!!", Colors.red, context);
          }
        },
        child: const Text(
          "REGISTRARSE",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  bool _validateFormNullSafety({List<TextEditingController>? controles}) {
    String controlNombreText = controlNombre.text.trim();
    String controlApellidoText = controlApellido.text.trim();
    String controlDNIText = controlDNI.text.trim();
    String controlTelefonoText = controlTelefono.text.trim();
    String controlEmailText = controlEmail.text.trim();
    String controlContrasenaText = controlContrasena.text.trim();

    if (controlNombreText.isEmpty) {
      return false;
    }
    if (controlApellidoText.isEmpty) {
      return false;
    }
    if (controlDNIText.isEmpty) {
      return false;
    }
    if (controlTelefonoText.isEmpty) {
      return false;
    }
    if (controlEmailText.isEmpty) {
      return false;
    }
    if (controlContrasenaText.isEmpty) {
      return false;
    }
    userData = UserData(
        id: 0,
        nombre: controlNombreText,
        apellido: controlApellidoText,
        dni: controlDNIText,
        telefono: controlTelefonoText,
        email: controlEmailText,
        fechaNacimiento: DateTime.parse(_startTextDate),
        contrasenia: controlContrasenaText);
    return true;
  }
}
