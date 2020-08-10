class ParseError implements Exception{

  int _httpStatus;
  int _status;
  final String _message ;


  ParseError(this._httpStatus,this._status,this._message);

  String get message => _message;
  String toString() => 'Server Exception: $_message';

}