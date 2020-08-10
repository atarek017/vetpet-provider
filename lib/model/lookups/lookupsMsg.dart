class LookupsMsg{
  int code;
  String msg;

  LookupsMsg(this.code,this.msg);

  LookupsMsg.fromJson(Map<String , dynamic> json){
    code=json['code'];
    msg=json['msg'];
  }

}