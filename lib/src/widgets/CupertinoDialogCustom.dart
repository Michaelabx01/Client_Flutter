import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoAlertDialogCustom {
  CupertinoAlertDialogCustom();

  Future<dynamic> showCupertinoAlertDialog({
    required String title,
    required String msg,
    Function()? onPressedPositive,
    Function()? onPressedNegative,
    required BuildContext context,
  }) {
    return showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              insetAnimationCurve: Curves.bounceIn,
              title: Text(title),
              content: Text(msg),
              insetAnimationDuration: const Duration(seconds: 1),
              actions: [
                TextButton(
                  onPressed: onPressedPositive ??
                      () {
                        Navigator.pushReplacementNamed(context, "login");
                      },
                  child: const Text(
                    "Aceptar",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: onPressedNegative,
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ));
  }
}

// return await showDialog(
      //       context: context,
      //       builder: (context) => AlertDialog(
      //         title: const Text('SALIENDO DE LOAsi'),
      //         content: const Text('¿Quieres cerrar la App?'),
      //         actions: [
      //           ElevatedButton(
      //             onPressed: () => Navigator.of(context).pop(false),
      //             child: const Text('No'),
      //           ),
      //           ElevatedButton(
      //             onPressed: () {
      //               SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      //             },
      //             child: const Text('Si'),
      //           ),
      //         ],
      //       ),
      //     ) ??
      //     false; //if showDialouge had returned null, then return false