import 'user_data_dto.dart';

class Login {
  State? state;
  UserData? userData;
  Login({
    this.state,
    this.userData,
  });

  factory Login.fromMap(Map<String, dynamic> json) => Login(
        state: State.fromMap(json["state"]),
        userData: json["userData"] == null
            ? null
            : UserData.fromMap(json["userData"]),
      );
}

class State {
  State({
    this.msg,
    this.state,
  });

  String? msg;
  bool? state;

  factory State.fromMap(Map<String, dynamic> json) => State(
        msg: json["msg"],
        state: json["state"] == 1 ? true : false,
      );
}
