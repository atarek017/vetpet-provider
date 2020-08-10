import 'package:flutter/material.dart';

class RequestNumber extends StatelessWidget {

  String requestsCount;
  RequestNumber(this.requestsCount);

  @override
  Widget build(BuildContext context) {
    double wedith = MediaQuery.of(context).size.width;
    return Container(
      height: 40,
      width: wedith * .7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: <Widget>[
          Icon(Icons.my_location),
          SizedBox(
            width: 20,
          ),
        Text("$requestsCount ",style: TextStyle(color: Colors.black),),
        ],
      ),
    );
  }
}
