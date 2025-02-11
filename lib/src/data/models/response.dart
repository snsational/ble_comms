class ResponseModel {
  String? action;
  String? uid;
  String? result;
  String? rcode;
  String? openDoorDuration;
  String? codeRDS;

  ResponseModel({this.action, this.uid, this.result, this.rcode, this.openDoorDuration, this.codeRDS});

  factory ResponseModel.fromJson({required Map<String, dynamic>? json}) => ResponseModel(
    action: json?["a"] as String?,
    uid: json?["uid"] as String?,
    result: json?["result"] as String?,
    rcode: json?["rcode"] as String?,
    openDoorDuration: json?["od"] as String?,
    codeRDS: json?["c"] as String?,
  );

  String getCategory() {
    switch (codeRDS) {
      case "0":
        return "cans";
      case "1":
        return "glass";
      case "2":
        return "plastic";
      case "3":
        return "brick";
      default:
        return "unknown";
    }
  }
}
