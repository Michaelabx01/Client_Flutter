import 'constants.dart';

class Validators {
  static const String emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  // r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  static const String passwordPattern =
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$';
  static const String textCleanPattern =
      r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$";
  static const String numberPatternWithPointBlanks = r'(^[0-9]*$)';
  static const String numberPattern = r'[0-9]';
  static const String amountPattern = r'[0-9.]';

  static String? emailHasMatch(
      {String? input, String output = ValidatorMessage.email}) {
    return _hashMatch(emailPattern, input ?? '') ? null : output;
  }

  static String? textClean(
      {String? input, String output = ValidatorMessage.textClean}) {
    return _hashMatch(textCleanPattern, input ?? '') ? null : output;
  }

  static String? onlyNumbers(
      {String? input, String output = ValidatorMessage.textClean}) {
    return _hashMatch(numberPattern, input ?? '') ? null : output;
  }

  static String? length({
    String? input,
    required int length,
    String output = ValidatorMessage.length,
    String outputTwo = ValidatorMessage.number,
  }) {
    return _hashMatch(numberPattern, input)
        ? (input != null && input.length == length)
            ? null
            : '$output $length'
        : outputTwo;
  }

  static String? verificationAmountTransfer({
    String? input,
    String output = ValidatorMessage.empty,
    String outputTwo = ValidatorMessage.number,
  }) {
    return (input != null && input.isNotEmpty)
        ? _hashMatch(numberPattern, input)
            ? null
            : outputTwo
        : output;
  }

  static String? empty(
      {String? input, String output = ValidatorMessage.empty}) {
    return (input != null && input.isNotEmpty) ? null : output;
  }

  static String? passwordHasMatch(
      {String? input, String output = ValidatorMessage.password}) {
    return _hashMatch(passwordPattern, input ?? '') ? null : output;
  }

  static String? passwordHasMatchAndEquals(
      {String? input,
      required String? inputTwo,
      String output = ValidatorMessage.password,
      String outputTwo = ValidatorMessage.passwordNotEquals}) {
    return _hashMatch(passwordPattern, input ?? '')
        ? (input != null && inputTwo != null && input == inputTwo)
            ? null
            : outputTwo
        : output;
  }

  static String? passwordEquals(
      {String? input,
      required String? inputTwo,
      String output = ValidatorMessage.empty,
      String outputTwo = ValidatorMessage.passwordNotEquals}) {
    return (input != null && input.isNotEmpty)
        ? (inputTwo != null && input == inputTwo)
            ? null
            : outputTwo
        : output;
  }

  static String? verificationCode(
      {String? input,
      required int length,
      String output = ValidatorMessage.length}) {
    return (input != null && input.length == length) ? null : '$output $length';
  }

  static String? verificationAmount(
      {String? input, String output = ValidatorMessage.textClean}) {
    return _hashMatch(amountPattern, input ?? '') ? null : output;
  }

  static bool _hashMatch(String pattern, String? input) {
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(input ?? '');
  }
}
