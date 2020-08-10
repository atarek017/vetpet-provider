import 'package:flutter/material.dart';
import 'package:vetwork_partner/data/network/VpNetworkRquestRepo.dart';
import 'package:vetwork_partner/data/repo/VpRequestRepo.dart';
import 'package:vetwork_partner/model/active_requests/active_request_model.dart';
import 'package:vetwork_partner/model/cancel_request/cancelReqestModel.dart';
import 'package:vetwork_partner/model/change_request_status/ChangeRequestStatusRespond.dart';
import 'package:vetwork_partner/pages/router/VpNavigationManager.dart';

class RequestTile extends StatelessWidget {
  final ActiveRequest request;
  Function onTap;

  RequestTile({
    this.request,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10.0,
      ),
      child: FlatButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.all(10.0),
        onPressed: () {
          onTap();

          //handle clicking on the request here !!
          print('\n\n------------------------------------------------');
          print('requested services: ');
          request.services.forEach((serviceData) {
            print(serviceData.name);
          });

          print('------------------------------------------------\n\n');
        },
        child: Column(
          children: <Widget>[
            _buildRequestTitle(
                request.services[0].svcTypName.toString(), request.statusId),
            SizedBox(
              height: 10.0,
            ),
            _buildDateTextWidget(request.visitTime),
            SizedBox(
              height: 10.0,
            ),
            _buildAddressTextWidget(request.userInfo.addresses.line1),
            SizedBox(
              height: 10.0,
            ),
            _buildPhoneNextBtnRow(
                request.userInfo.countrycode, request.userInfo.phone),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneNextBtnRow(String countryCode, String phone) {
    print("request Id" + request.reqId.toString());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '(+$countryCode) $phone',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        InkWell(
          child: request.statusId < 4
              ? Container(
                  width: 80,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.blue[500],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : Container(),
          onTap: () async {
            VpRequestRepo vpRequestRepo = VpNetworkRequestRepo();
            await vpRequestRepo
                .cancelRequest(new CancelRequestStatusModel(
                    " ", request.reqId.toString(), "sds"))
                .then((onValue) {
              if (onValue.success == false) {
                snackMsg(onValue.code, StaticRoutData.scaffoldkey);
              }else if(onValue.success ==true){
                snackMsg("111", StaticRoutData.scaffoldkey);
              }
            }).catchError((onError) {
              print("erorr" + onError.toString());
            });
          },
        ),
      ],
    );
  }

  Widget _buildAddressTextWidget(String address) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        address,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 13.0,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildDateTextWidget(String date) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        date,
        style: TextStyle(color: Colors.black, fontSize: 14.0),
      ),
    );
  }

  Widget _buildRequestTitle(String serviceType, int statusID) {
    print("id :" + statusID.toString());
    String statuse = " ";
    Color textColor = Colors.green[400];
    switch (statusID) {
      case 1:
        statuse = "Pending";
        textColor = Colors.green[400];

        break;
      case 2:
        statuse = "Accepted";
        textColor = Colors.green[400];
        break;
      case 3:
        statuse = "Vet on Way";
        textColor = Colors.green[400];

        break;
      case 4:
        statuse = "On Site";
        textColor = Colors.green[400];

        break;
      case 5:
        statuse = "Completed";
        textColor = Colors.green[400];

        break;
      case 6:
        statuse = "Canceled";
        textColor = Colors.red[500];
        break;
      case 7:
        statuse = "Expired";
        textColor = Colors.red[500];
        break;
    }
    print("Admin key : " + request.byadmin.toString());

    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5.0),
          width: 25.0,
          height: 25.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.5),
            color: Color.fromRGBO(0, 91, 147, 1),
          ),
          child: Image.asset(
            'assets/pics/grooming.png',
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 15.0,
        ),
        Text(
          serviceType,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(0, 91, 147, 1),
          ),
        ),
        SizedBox(
          width: 50,
        ),
        Align(
          alignment: Alignment.topRight,
          child: Text(
            statuse.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        )
      ],
    );
  }
}
