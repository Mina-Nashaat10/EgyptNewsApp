import 'package:flutter/material.dart';

Widget appBar(BuildContext context) {
  return AppBar(
    iconTheme: IconThemeData(color: Colors.red),
    backgroundColor: Colors.white,
    title: Container(
      margin: EdgeInsets.only(right: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Egypt",
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  "News",
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
            onTap: () => Navigator.of(context).pushNamed('/home'),
          ),
        ],
      ),
    ),
  );
}
