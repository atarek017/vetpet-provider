import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vetwork_partner/data/network/NetworkConstants.dart';
import 'package:vetwork_partner/data/network/VpNetworkPillRepo.dart';
import 'package:vetwork_partner/data/repo/VpPill.dart';
import 'package:vetwork_partner/model/confirm_invoice/BillInvoice.dart';
import 'package:vetwork_partner/model/confirm_invoice/ConfirmInvoicModel.dart';
import 'package:vetwork_partner/model/confirm_invoice/ConfirmInvoiceRespond.dart';
import 'package:vetwork_partner/model/services/Service.dart';
import 'package:vetwork_partner/pages/router/VpNavigationManager.dart';
import 'package:vetwork_partner/pages/util/style.dart';

class FinalBill extends StatefulWidget {
  Function homActiveRequest;

  FinalBill(this.homActiveRequest);

  @override
  State<StatefulWidget> createState() {
    return BillSate();
  }
}

class BillSate extends State<FinalBill> {
  TextEditingController payout = TextEditingController();
  TextEditingController feedBck = TextEditingController();
  int x = 0;
  VpPill vpUserRepo = VpNetworkPillRepo();

  //invoices
  double total = 0;
  List<Services> serviceList = [];
  double visitFees;
  double extraFees;

  // loading
  bool loadDetails=true;

  @override
  void initState() {
    billInvoices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: loadDetails==false?ListView(
        children: <Widget>[
          SizedBox(
            height: 80,
          ),
          Text("Thank You",
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontSize: 20, color: Colors.black)),
          SizedBox(
            height: 20,
          ),
          Text("Final Payment:",
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontSize: 20, color: Colors.black)),
          SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Text("Total :",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            trailing: Text(
              "$total EGP",
              style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text("ENTER PAYOUT AMOUNT :",
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: Colors.blue[900])),
          TextField(
            decoration: InputDecoration(
              labelStyle: textFieldLabelStyle,
            ),
            keyboardType: TextInputType.number,
            controller: payout,
          ),
          SizedBox(
            height: 10,
          ),
          x == 1 ? showFeedBack() : Container(),
          SizedBox(
            height: 20,
          ),
          Center(
            child: InkWell(
              onTap: () {
                Confirm();
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .6,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: LinearGradient(colors: [
                      Colors.blue[900],
                      Colors.blue[700],
                      Colors.blue,
                    ])),
                child: Center(
                    child: Text(
                      'Confirm Payment',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Text("Details : ",
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontSize: 20, color: Colors.black)),
          Container(
            height: gethight(),
            child: ListView.builder(
              itemCount: serviceList.length,
              itemBuilder: (contexte, index) {
                return ListTile(
                  leading: Text(serviceList[index].name),
                  trailing: Text(serviceList[index].totalPrice.toString()+" EGP"),
                );
              },
            ),
          ),

          visitFees != null
              ? ListTile(
            title: Text("Visit fees"),
            trailing: Text(visitFees.toString()),
          )
              : SizedBox(),
          extraFees != null
              ? ListTile(
              title: Text("Exta fees"),
              trailing: Text(extraFees.toString() + " "))
              : SizedBox(),

          ListTile(
            leading: Text("Total :",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            trailing: Text(
              "$total EGP",
              style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),

          SizedBox(height: 10,)
        ],
      ):Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
    );
  }

  Confirm() {
    double pay = double.parse(payout.text);
    if (total > pay && x == 0) {
      setState(() {
        x = 1;
      });
    } else {
      confirmInvic();
    }
  }

  Widget showFeedBack() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            "This amount is below final ammount. \n Please provide feedback. :",
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: Colors.red[900])),
        SizedBox(
          height: 25,
        ),
        Text("FEEDBACK:",
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: Colors.blue[900])),
        TextField(
          decoration: InputDecoration(
            labelStyle: textFieldLabelStyle,
          ),
          keyboardType: TextInputType.text,
          controller: feedBck,
        ),
      ],
    );
  }

  confirmInvic() async {
    setState(() {
      loadDetails=true;
    });

    await vpUserRepo
        .confirmInvoice(ConfirmInvoiceModel(
            '',
            NetworkConstants.requestId.toString(),
            payout.text.toString(),
            feedBck.text.toString(),
            '1',
            NetworkConstants.billServices))
        .then((onValue) async {
      if (onValue.success == true) {
        snackMsg("111", StaticRoutData.scaffoldkey);
        await Future.delayed(const Duration(seconds: 1));
        widget.homActiveRequest();
        NetworkConstants.billServices = [];
      } else {
        snackMsg(onValue.code, StaticRoutData.scaffoldkey);
      }
    }).catchError((erorr) {
      print("Errrorr : : " + erorr);
    });

    setState(() {
      loadDetails=false;
    });
  }

  billInvoices() async {
    setState(() {
      loadDetails=true;
    });
    await vpUserRepo
        .billInvoice(BillInvoice('', NetworkConstants.requestId.toString(),
            NetworkConstants.billServices))
        .then((onValue) async {
      if (onValue.success == true) {
        setState(() {
          total = onValue.invoce.totalCost;
          serviceList = onValue.invoce.services;
          visitFees = onValue.invoce.visitFees;
          extraFees = onValue.invoce.extraFees;

        });
      } else {
        snackMsg(onValue.code, StaticRoutData.scaffoldkey);
      }
    }).catchError((erorr) {
      print("Errrorr : : " + erorr);
    });

    setState(() {
      loadDetails=false;
    });
  }

  double gethight() {
    double servicehige = double.parse(serviceList.length.toString());
    if (serviceList.length < 1) {
      servicehige = 1;
    }

    double hight = 50 * servicehige;

    if (hight < 150)
      return hight;
    else
      return 150;
  }
}
