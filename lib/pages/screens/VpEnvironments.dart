import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetwork_partner/data/network/NetworkConstants.dart';
import 'package:vetwork_partner/pages/util/style.dart';

import 'login.dart';

class Environments extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EnvironmentsState();
  }
}

class EnvironmentsState extends State<Environments> {
  TextEditingController _environmentNameController =
      new TextEditingController();

  List<Enviro> environmentList = new List();

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    await getList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 500,
            child: ListView.builder(
              itemCount: environmentList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    setSelected(environmentList[index].name);
                    await NetworkConstants.getBaseIP();
                    print(NetworkConstants.baseAddress);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: environmentList[index].selected == true
                              ? Colors.blue
                              : Colors.white,
                        ),
                        height: 30,
                        // ignore: unrelated_type_equality_checks
                        child: Center(
                            child:
                                Text(environmentList[index].name.toString()))),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
                onTap: () async {
                  showEnvironmentDialog(context);
                },
                child: Container(
                  width: width * .6,
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
                    'Add Environment',
                    style: TextStyle(color: Colors.white),
                  )),
                )),
          ),
        ],
      ),
    );
  }

  showEnvironmentDialog(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _environmentNameController,
                  decoration: InputDecoration(
                    labelText: 'Environment name',
                    labelStyle: textFieldLabelStyle,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                    onTap: () async {
                      int i = await getLastElement();
                      addEnvironmentElement("env$i");
                      setLastElement((i + 1).toString());

                      setState(() {
                        getList();
                      });

                      Navigator.pop(context);
                    },
                    child: Container(
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
                        'Add Environment',
                        style: TextStyle(color: Colors.white),
                      )),
                    )),
              ],
            ),
          );
        });
  }

  addEnvironmentElement(vale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(vale, _environmentNameController.text);
  }

  setLastElement(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('envNumLast', value);
  }

  Future<int> getLastElement() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String envNumb = prefs.getString('envNumLast');
    if (envNumb == null) {
      return 1;
    } else {
      return int.parse(envNumb);
    }
  }

  getList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastElement = await getLastElement();
    environmentList.clear();

    for (int i = 1; i <= lastElement; i++) {
      String val = prefs.getString("env$i");
      if (val != null) {
        environmentList.add(new Enviro(val, await sellecte(val)));
      }
    }

  }

  Future<dynamic> sellecte(vale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sellecte = prefs.getString('envireonmentSellected');
    if (vale == sellecte) {
      return true;
    } else
      return false;
  }

  Future<dynamic> setSelected(vale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('envireonmentSellected', vale);
  }
}

class Enviro {
  String name;
  bool selected;

  Enviro(this.name, this.selected);
}
