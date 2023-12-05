// ignore_for_file: file_names

class UiResponse {
  Response? response;
  bool? state;

  UiResponse({
    this.response,
    this.state,
  });

  factory UiResponse.fromMap(Map<String, dynamic> json) => UiResponse(
        response: Response.fromMap(json["response"]),
        state: json["state"],
      );
}

class Response {
  int? id;
  String? error;
  int? state;

  Response({
    this.id,
    this.error,
    this.state,
  });

  factory Response.fromMap(Map<String, dynamic> json) => Response(
        id: json["id"],
        error: json["error"],
        state: json["state"],
      );
}

class UiResponseSimple {
  String? response;
  bool? state;

  UiResponseSimple({
    this.response,
    this.state,
  });

  factory UiResponseSimple.fromMap(Map<String, dynamic> json) =>
      UiResponseSimple(
        response: json["response"],
        state: json["state"] == 1 ? true : false,
      );
}
