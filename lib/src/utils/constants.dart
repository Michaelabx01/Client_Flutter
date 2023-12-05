class GenericErrorMessages {
  static const String logic = 'Algo ocurrió, vuelva a intentarlo :(';
  static const String network = 'Algo ocurrió con la red, vuelva a intentarlo :(';
  static const String server = 'Algo ocurrió con el servidor, vuelva a intentarlo :(';
  static const String tokenError = 'El servidor no respondió correctamente, vuelva a intentarlo.';
  static const String noInformation = 'No se encontraron registros.';
}

class LoginMessages {
  static const String credentialError = 'Usuario o contraseña incorrecto.';
}

class LoginValidatorMessage {
  static const String email = 'Ingrese un correo válido';
  static const String password = 'Mínimo 8 caracteres, una letra, un número y carácter especial';
}

class ValidatorMessage {
  static const String email = 'Ingrese un correo válido';
  static const String empty = 'El campo no puede ser vacío';
  static const String password = 'Mínimo 8 caracteres, una letra, un número y carácter especial';
  static const String passwordNotEquals = 'La contraseña no coincide';
  static const String textClean = 'Ingrese información válida';
  static const String length = 'Los caracteres deben ser ';
  static const String number = 'Ingresar solo números';
}

class RegisterMessages {
  static const String registerError = 'No se pudo crear al usuario, vuelva a intentarlo.';
}

class Password {
  static const String emailError = 'No se pudo enviar el código de verificación, vuelva a intentarlo.';
  static const String recoverPasswordError = 'No se pudo recuperar la contraseña, vuelva a intentarlo.';
  static const String changePasswordError = 'No se pudo cambiar la contraseña, vuelva a intentarlo.';
}

class CollectionAutomaticMessages {
  static const String checkQRError = 'No es un QR válido, vuelva a intentarlo.';
}

class ReportMessages {
  static const String dateEmpty = 'Seleccione un rango de fechas válidas';
  // static const String dateEmpty = 'Seleccione algún filtro';
  static const String refresh = 'Cargando información';
  static const String refreshError = 'No se pudo cargando la información';
}

class SecureStorageKey {
  static const String userState = "USER_STATE";
  static const String accessToken = "ACCESS_TOKEN";
}
