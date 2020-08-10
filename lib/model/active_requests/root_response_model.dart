import 'active_request_model.dart';

class RootResponseModel {
  bool success;
  String code;
  Paras paras;

  RootResponseModel({this.code, this.paras, this.success});

  RootResponseModel.fromJson(Map<String, dynamic> parsedJson)
      : success = parsedJson['success'],
        code = parsedJson['code'],
        paras = Paras.fromJson(parsedJson['paras']);


  RootResponseModel.fromJsonComPleat(Map<String, dynamic> parsedJson)
      : success = parsedJson['success'],
        code = parsedJson['code'],
        paras = Paras.fromJsonComPleat(parsedJson['paras']);

}

class Paras {
  List<ActiveRequest> requests;

  Paras({this.requests});

  Paras.fromJson(Map<String, dynamic> parsedJson) {
    List<dynamic> tempList = parsedJson['requests'];
    requests = tempList
        .map((requestJson) => ActiveRequest.fromJson(requestJson))
        .toList();
  }


  Paras.fromJsonComPleat(Map<String, dynamic> parsedJson) {
    List<dynamic> tempList = parsedJson['requests'];
    requests = tempList
        .map((requestJson) => ActiveRequest.fromJsonComPleat(requestJson))
        .toList();
  }
}

class ActiveRequestBody{
  String provid;

  ActiveRequestBody({this.provid});

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['provid'] = this.provid;
    return data;
  }
}
