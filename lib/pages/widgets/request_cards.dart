import 'package:flutter/material.dart';
import 'package:vetwork_partner/model/active_requests/active_request_model.dart';
import 'package:vetwork_partner/pages/router/VpNavigationManager.dart';
import '../../model/RequestModel.dart';

import 'package:vetwork_partner/data/network/VpNetworkRquestRepo.dart';
import 'package:vetwork_partner/data/repo/VpRequestRepo.dart';
import '../../main.dart';
import 'package:vetwork_partner/model/accept_request/accept_model.dart';
import 'package:vetwork_partner/model/accept_request/accept_success.dart';
import 'package:vetwork_partner/model/active_requests/user_info_model.dart';
import 'package:date_format/date_format.dart';

class RequestCards extends StatefulWidget {
  final Function selectView;
  List<Requests> requests;

  RequestCards(this.selectView, this.requests);

  @override
  _RequestCardsState createState() => _RequestCardsState();
}

class _RequestCardsState extends State<RequestCards> {
  PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: Stack(
        children: <Widget>[
          Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: buildRequestCards(_width)),
          buildPreviousButton(),
          buildNextButton()
        ],
      ),
    );
  }

  Container buildRequestCards(double _width) {
    return Container(
        width: _width,
        padding: EdgeInsets.symmetric(horizontal: _width * 0.1, vertical: 20),
        height: 300,
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _controller,
              itemCount: widget.requests.length,
              itemBuilder: (context, index) {
                DateTime creatDate = DateTime.parse(
                    widget.requests[index].creationTime.toString());
                DateTime vistiDate =
                    DateTime.parse(widget.requests[index].visitTime.toString());

                Duration difrence = vistiDate.difference(creatDate);

                print(difrence.inHours.toString());

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: 60,
                        height: 60,
                        child: new OverflowBox(
                          minWidth: 0.0,
                          minHeight: 0.0,
                          maxHeight: 40,
                          maxWidth: double.infinity,
                          child: new Image(
                              image: new AssetImage('assets/pics/grooming.png'),
                              fit: BoxFit.cover),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  blurRadius: 5,
                                  spreadRadius: 5,
                                  color: Colors.grey)
                            ]),
                      ),
                      Text(
                        widget.requests[index].svcCat,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      Text(
                        widget.requests[index].state,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(color: Colors.blueGrey, fontSize: 18),
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            'Request created ${formatDate(creatDate, [
                              hh,
                              ':',
                              nn,
                              ' ',
                              am,
                              ', ',
                              dd,
                              'th',
                              ' of ',
                              M
                            ])}  ',
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(fontSize: 16),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('IN ${difrence.inHours.toString()} HOURS',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(
                                      fontSize: 16,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold)),
                        ],
                      ),
                      RaisedButton(
                          child: Text('Accept',
                              style: Theme.of(context).textTheme.button),
                          color: Colors.green,
                          onPressed: () async {
                            VpRequestRepo requestRepo = VpNetworkRequestRepo();
                            String providerId = await getProviderId();
                            AcceptSuccess acceptSuccess =
                                await requestRepo.acceptRequest(AcceptModel(
                                    providerId,
                                    widget.requests[index].reqId.toString()));

                            print(
                                "LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL");
                            print(
                                "date " + widget.requests[index].creationTime);

                            StaticRoutData.activeRequest = new ActiveRequest(
                              reqId: acceptSuccess.requestid,
                              invoiceServices:
                                  acceptSuccess.userInfo.invoiceServices,
                              services: acceptSuccess.userInfo.services,
                              extraFees: acceptSuccess.userInfo.extraFees,
                              visiteFees: acceptSuccess.userInfo.visiteFees,
                              byadmin: false,
                              statusId: 2,
                              creationTime: widget.requests[index].creationTime,
                              userInfo: UserInfo(
                                username: acceptSuccess.userInfo.name,
                                phone: acceptSuccess.userInfo.phone,
                                countrycode: acceptSuccess.userInfo.countrycode,
                                addresses: acceptSuccess.userInfo.address,
                              ),
                              location: acceptSuccess.userInfo.address.location,
                              visitTime: widget.requests[index].creationTime,
                            );

                            for (int i = 0;
                                i < acceptSuccess.userInfo.services.length;
                                i++) {
                              print("Service ${i}" +
                                  acceptSuccess.userInfo.services[i].name);
                            }
                            widget.selectView();
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)))
                    ],
                  ),
                );
              },
            ),
          ],
        ));
  }

  void nextPage() {
    _controller.nextPage(
        duration: Duration(microseconds: 200), curve: Curves.bounceIn);
  }

  void previousPage() {
    _controller.previousPage(
        duration: Duration(microseconds: 200), curve: Curves.bounceIn);
  }

  Padding buildNextButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100, right: 15),
      child: Align(
        alignment: AlignmentDirectional.bottomEnd,
        child: CircleAvatar(
          radius: 25,
          backgroundColor: Color(0xff474fa1),
          child: IconButton(
              icon: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
              onPressed: nextPage),
        ),
      ),
    );
  }

  Padding buildPreviousButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100, left: 15),
      child: Align(
        alignment: AlignmentDirectional.bottomStart,
        child: CircleAvatar(
          radius: 25,
          backgroundColor: Color(0xff474fa1),
          child: IconButton(
              icon: Icon(
                Icons.keyboard_backspace,
                color: Colors.white,
              ),
              onPressed: previousPage),
        ),
      ),
    );
  }
}
