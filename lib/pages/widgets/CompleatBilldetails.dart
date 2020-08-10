import 'package:flutter/material.dart';
import 'package:vetwork_partner/model/active_requests/active_request_model.dart';

class CompleatBilldetails extends StatelessWidget {
  ActiveRequest _activeRequest;

  CompleatBilldetails(this._activeRequest);

  @override
  Widget build(BuildContext context) {
    print(_activeRequest.visiteFees.toString());
    return Column(
      children: <Widget>[
        Container(
          height: gethight(),
          child: ListView.builder(
            itemCount: _activeRequest.invoiceServices.length,
            itemBuilder: (context, index) {
              String count = _activeRequest.invoiceServices[index].count == null ||
                      _activeRequest.invoiceServices[index].count == 1
                  ? " "
                  : "(" +
                      _activeRequest.invoiceServices[index].count.toString() +
                      ") ";

              return ListTile(
                title: Text(
                  count + _activeRequest.invoiceServices[index].name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  _activeRequest.invoiceServices[index].totalPrice.toString() + " ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 30,
        ),
        _activeRequest.visiteFees != null
            ? ListTile(
                title: Text("Visit fees"),
                trailing: Text(_activeRequest.visiteFees.toString()),
              )
            : SizedBox(),
        _activeRequest.extraFees != null
            ? ListTile(
                title: Text("Exta fees"),
                trailing: Text(_activeRequest.extraFees.toString() + " "))
            : SizedBox(),
        _activeRequest.paid != null
            ? ListTile(
                title: Text("Paid"),
                trailing: Text(_activeRequest.paid.toString() + ""),
              )
            : SizedBox(),
        _activeRequest.toString() != null
            ? ListTile(
                title: Text("Total cost"),
                trailing: Text(_activeRequest.totalCost.toString() + " "),
              )
            : SizedBox(),
      ],
    );
  }


  double gethight() {
    double servicehige = double.parse(_activeRequest.invoiceServices.length.toString());
    if (_activeRequest.invoiceServices.length < 1) {
      servicehige = 1;
    }

    double hight = 50 * servicehige;

    if (hight < 150)
      return hight;
    else
      return 150;
  }

}
