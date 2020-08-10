class ChangeRequestStatusRespond{
  bool  success;
  String code;
  String paras;

  ChangeRequestStatusRespond(this.success,this.code,this.paras);

  ChangeRequestStatusRespond.fromJson(Map<String,dynamic> json){
    success=json['success'];
    code=json['code'];
    paras=json['paras'];
  }

}