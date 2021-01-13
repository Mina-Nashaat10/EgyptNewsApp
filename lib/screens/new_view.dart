import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewView extends StatefulWidget {
  @override
  _NewViewState createState() => _NewViewState();
}

class _NewViewState extends State<NewView> {
  Completer<WebViewController> completer = Completer<WebViewController>();
  bool pageIsLoaded = false;

  @override
  Widget build(BuildContext context) {
    String newUrl = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      drawer: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.white),
        child: Drawer(
          elevation: 0.0,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/news_header.jpg"),
                        fit: BoxFit.cover)),
              ),
              ListTile(
                leading: SvgPicture.asset(
                  "assets/images/trend_news_icon.svg",
                  width: 35,
                  height: 35,
                ),
                title: Text(
                  "Top News",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed("/home");
                },
              ),
              Divider(
                color: Colors.grey,
                height: 2,
              ),
              Container(
                margin: EdgeInsets.only(top: 7, left: 10),
                child: Text(
                  "Classifications",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              listTile("assets/images/business_icon.svg", "Business",
                  "/news_by_category"),
              listTile("assets/images/entertainment_icon.svg", "Entertainment",
                  "/news_by_category"),
              listTile("assets/images/general_icon.svg", "General",
                  "/news_by_category"),
              listTile("assets/images/health_icon.svg", "Health",
                  "/news_by_category"),
              listTile("assets/images/science_icon.svg", "Science",
                  "/news_by_category"),
              listTile("assets/images/sports_icon.svg", "Sports",
                  "/news_by_category"),
              listTile("assets/images/technology_icon.svg", "Technology",
                  "/news_by_category"),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.red),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Container(
          padding: EdgeInsets.only(right: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Flutter",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              Text(
                "News",
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            WebView(
              initialUrl: newUrl,
              onWebViewCreated: ((WebViewController web) {
                completer.complete(web);
              }),
              onPageFinished: (_) {
                setState(() {
                  pageIsLoaded = true;
                });
              },
            ),
            pageIsLoaded == false
                ? Center(child: CircularProgressIndicator())
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  ListTile listTile(String path, String title, String route) {
    return ListTile(
      leading: SvgPicture.asset(
        path,
        width: 29,
        height: 29,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(route, arguments: title);
      },
    );
  }
}
