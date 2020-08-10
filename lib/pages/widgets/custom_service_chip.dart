import 'package:flutter/material.dart';
import 'package:vetwork_partner/pages/router/VpNavigationManager.dart';

class CustomChip extends StatefulWidget {
  int index;
  bool clicked;
  bool error;
  String label;

  CustomChip({this.index, this.label, this.clicked, this.error});

  @override
  State<StatefulWidget> createState() {
    return CustomChipState();
  }
}

class CustomChipState extends State<CustomChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      margin: EdgeInsets.all(0.0),
      padding: EdgeInsets.all(0.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            width: 1.0,
            color: widget.error ? Colors.red : Colors.transparent,
          )),
      child: Chip(
        backgroundColor:
            widget.clicked ? Colors.blue[900] : Colors.grey.shade200,
        label: InkWell(
          child: Text(
            widget.label,
            style: TextStyle(
                color: widget.clicked ? Colors.white : Colors.grey[700],
                fontSize: 16),
          ),
          onTap: () {
            setState(() {
              widget.clicked = !widget.clicked;
              widget.error = widget.clicked ? false : true;

              if (widget.clicked) {
                StaticRoutData.signUpUserServices.add(widget.index );
                print(StaticRoutData.signUpUserServices.toString());
              } else if (!widget.clicked) {
                StaticRoutData.signUpUserServices.remove(widget.index );
                print(StaticRoutData.signUpUserServices.toString());
              }
            });
          },
        ),
      ),
    );
  }
}
