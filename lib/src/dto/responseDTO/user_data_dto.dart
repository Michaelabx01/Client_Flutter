class UserData {
  UserData({
    this.id,
    this.nombre,
    this.apellido,
    this.dni,
    this.telefono,
    this.email,
    this.fechaNacimiento,
    this.contrasenia,
    this.estado,
    this.idUserType,
  });

  int? id;
  String? nombre;
  String? apellido;
  String? dni;
  String? telefono;
  String? email;
  DateTime? fechaNacimiento;
  String? contrasenia;
  int? estado;
  int? idUserType;

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
        id: json["id"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        dni: json["dni"],
        telefono: json["telefono"],
        email: json["email"],
        fechaNacimiento: DateTime.parse(json["fecha_nacimiento"]),
        contrasenia: json["contrasenia"],
        estado: json["estado"],
        idUserType: json["id_user_type"],
      );
}
