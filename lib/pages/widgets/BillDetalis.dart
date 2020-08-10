import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vetwork_partner/data/network/NetworkConstants.dart';
import 'package:vetwork_partner/data/network/VpNetworkPillRepo.dart';
import 'package:vetwork_partner/data/repo/VpPill.dart';
import 'package:vetwork_partner/model/active_requests/active_request_model.dart';
import 'package:vetwork_partner/model/prices/GetPricesRespond.dart';
import 'package:vetwork_partner/model/prices/Price.dart';
import 'package:vetwork_partner/model/prices/PriceRequestModel.dart';
import 'package:vetwork_partner/model/services/Service.dart';

List<Services> services = [];

class BillDetails extends StatefulWidget {
  ActiveRequest _activeRequest;
  final Function selectView;

  BillDetails(this._activeRequest, this.selectView);

  @override
  State<StatefulWidget> createState() {
    return BillDetailsState();
  }
}

class BillDetailsState extends State<BillDetails> {
  VpPill vpUserRepo = VpNetworkPillRepo();
  List<Services> allServices = [];
  TextEditingController cash = TextEditingController();
  TextEditingController comment = TextEditingController();
  bool isLoading = true;

  @override
  void dispose() {
    cash.dispose();
    comment.dispose();
    super.dispose();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    services = widget._activeRequest.invoiceServices;

    NetworkConstants.requestId = widget._activeRequest.reqId.toString();
//    setService();
    setState(() {
      isLoading = false;
    });
    allServices = await vpUserRepo.getAllServices();

    setAllServices();
  }

  setAllServices() async {
    for (int i = 0; i < services.length; i++) {
      for (int j = 0; j < allServices.length; j++) {
        if (services[i].id == allServices[j].id) {
          setState(() {
            allServices[j].check = true;
          });
        } else {
          setState(() {
            allServices[j].check = false;
          });
        }
      }
    }
  }

  setService() {
    NetworkConstants.billServices = services;
  }

  double gethight() {
    double servicehige = double.parse(services.length.toString());
    if (services.length < 1) {
      servicehige = 1;
    }

    double hight = 50 * servicehige;

    if (hight < 150)
      return hight;
    else
      return 150;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          isLoading
              ? Center(
                  child: Container(
                  margin: EdgeInsets.all(10),
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(),
                ))
              : Container(
                  height: gethight(),
                  child: ListView.builder(
                    itemCount: services.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: widget._activeRequest.statusId == null ||
                                widget._activeRequest.statusId < 5
                            ? Container(
                                width: 55,
                                height: 40,
                                child: Row(
                                  children: <Widget>[
                                    InkWell(
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            color: Colors.red[900],
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        child: Center(
                                            child: Text(
                                          "-",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          services[index].count--;

                                          if (services[index].count == 0 ||
                                              services[index].count < 0) {
                                            services.removeAt(index);

                                            setAllServices();
//                                            setService();
                                          }
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            color: Colors.green[500],
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        child: Center(
                                            child: Text(
                                          "+",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          services[index].count++;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : null,
                        title: Row(
                          children: <Widget>[
                            services[index].count > 1
                                ? Text("(" +
                                    services[index].count.toString() +
                                    "x)")
                                : Container(),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: 100,
                              child: Text(
                                services[index].name,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                                maxLines: 4,
                              ),
                            ),
                          ],
                        ),
                        trailing: Text(
                          (services[index].price * services[index].count)
                                  .toString() +
                              ' EGP',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
          SizedBox(
            height: 30,
          ),
          Column(
            children: <Widget>[
              widget._activeRequest.visiteFees != null
                  ? ListTile(
                      title: Text("Visit fees"),
                      trailing:
                          Text(widget._activeRequest.visiteFees.toString()),
                    )
                  : SizedBox(),
              widget._activeRequest.extraFees != null
                  ? ListTile(
                      title: Text("Exta fees"),
                      trailing:
                          Text(widget._activeRequest.extraFees.toString()))
                  : SizedBox(),
            ],
          ),
          InkWell(
            child: widget._activeRequest.statusId == null ||
                    widget._activeRequest.statusId < 5
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(11.0)),
                        child: Center(
                            child: Text(
                          "+",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Add New Services',
                        style: TextStyle(color: Colors.grey[700], fontSize: 18),
                      )
                    ],
                  )
                : Container(),
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showDialog();
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Text(
              'Total',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold),
            ),
            trailing: Text(getTotal() + ' EGP',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 10,
          ),
          widget._activeRequest.statusId == null ||
                  widget._activeRequest.statusId < 5
              ? InkWell(
                  onTap: () {
                    setService();
                    widget.selectView();
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
                      'Send Bill',
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  String getTotal() {
    double total = 0;
    for (int i = 0; i < services.length; i++) {
      total += (services[i].price * services[i].count);
    }
    if (widget._activeRequest.visiteFees != null) {
      total += widget._activeRequest.visiteFees;
    }
    if (widget._activeRequest.extraFees != null) {
      total += widget._activeRequest.extraFees;
    }
    NetworkConstants.total = total;
    return total.toString();
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return new CupertinoAlertDialog(
          title: new Text('Please select Services'),
          actions: <Widget>[
            new CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop('Done');
                setState(() {});
              },
              child: new Text('Done'),
            ),
          ],
          content: new SingleChildScrollView(
            child: new Material(
              child: new MyDialogContent(
                allservices: allServices,
                activeRequest: widget._activeRequest,
              ),
            ),
          ),
        );
      },
      barrierDismissible: false,
    );
  }
}

class MyDialogContent extends StatefulWidget {
  MyDialogContent({
    Key key,
    this.allservices,
    this.activeRequest,
  }) : super(key: key);

  final List<Services> allservices;
  ActiveRequest activeRequest;

  @override
  _MyDialogContentState createState() => new _MyDialogContentState();
}

class _MyDialogContentState extends State<MyDialogContent> {
  VpPill vpUserRepo = VpNetworkPillRepo();

  @override
  void initState() {
    super.initState();
  }

  _getContent() {
    if (widget.allservices.length == 0) {
      return new Container();
    }

    return Container(
      height: 400,
      child: ListView.builder(
          itemCount: widget.allservices.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              title: Text(widget.allservices[index].name.toString()),
              onChanged: (bool value) {
                setState(() async {

                  if (value == true) {
                    setState(() {
                      widget.allservices[index].check = value;
                    });
                    double pric = await getPrice(widget.allservices[index].id);
                    Services ser = Services(
                        widget.allservices[index].id,
                        widget.allservices[index].typId,
                        widget.allservices[index].name,
                        1,
                        pric,
                        true);

                    setState(() {
                      services.add(ser);
                    });
                  } else {
                    setState(() {
                      widget.allservices[index].check = value;
                      services.removeWhere(
                          (item) => item.id == widget.allservices[index].id);
                    });
                  }
                });
              },
              value: widget.allservices[index].check == null
                  ? false
                  : widget.allservices[index].check,
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getContent();
  }

  Future<double> getPrice(int id) async {
    GetPricesRespond getPricesRespond = await vpUserRepo
        .getPrices(
            PriceRequestModel('', [id], widget.activeRequest.visitTime, 'EG'))
        .catchError((onExror) {
      print('erorr ' + onExror.toString());
    });

    List<Price> prices = getPricesRespond.prices;
    if (prices[0].svcId == id) {
      print('id ' + prices[0].svcId.toString());
      print('price ' + prices[0].price.toString());

      return prices[0].price;
    }
    return 1;
  }


}
