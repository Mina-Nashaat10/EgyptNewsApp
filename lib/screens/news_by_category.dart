import 'dart:async';

import 'package:auto_direction/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newsapp/helper_widgets/appbar.dart';
import 'package:newsapp/helper_widgets/no_internet_widget.dart';
import 'package:newsapp/models/news_model.dart';
import 'package:newsapp/services/internet_connection.dart';

class NewsByCategory extends StatefulWidget {
  @override
  _NewsByCategoryState createState() => _NewsByCategoryState();
}

class _NewsByCategoryState extends State<NewsByCategory> {
  List<NewsModel> newsCategory = [];
  NewsModel newsModel = new NewsModel();
  String category;
  bool isRTL = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectivitySubscription =
        connectivity.onConnectivityChanged.listen(updateConnectionStatus);
  }

  @override
  void dispose() {
    super.dispose();
    connectivitySubscription.cancel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    category = ModalRoute.of(context).settings.arguments;
  }

  Stream getNews() async* {
    newsCategory.clear();
    newsCategory = await newsModel.getNewsByCategory(category);
    yield newsCategory;
  }

  Future<void> getNewsforRefreshIndicator() async {
    newsCategory.clear();
    newsCategory = await newsModel.getNewsByCategory(category);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
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
                      fit: BoxFit.cover),
                ),
                child: null,
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
      body: RefreshIndicator(
        child: FutureBuilder(
          builder: (context, snapshot) {
            Widget widget;
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                widget = StreamBuilder(
                  builder: (context, snapshot) {
                    Widget internalWidget;
                    if (snapshot.hasData) {
                      internalWidget = Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                width: category == "Entertainment" ||
                                        category == "Technology"
                                    ? 125
                                    : 80,
                                height: 40,
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                          fontFamily: "Lobster",
                                          fontSize: 22.0,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, "/new_view",
                                        arguments: newsCategory[index].newUrl);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        bottom: 15, right: 10, left: 10),
                                    child: newsCategory[index].urlToImage ==
                                            null
                                        ? SizedBox()
                                        : Stack(
                                            alignment: Alignment.bottomCenter,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                height: 250,
                                                decoration: new BoxDecoration(
                                                  boxShadow: [
                                                    new BoxShadow(
                                                      color: Colors.black87,
                                                      blurRadius: 10.0,
                                                    ),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        newsCategory[index]
                                                            .urlToImage,
                                                    width: double.infinity,
                                                    height: 250,
                                                    fit: BoxFit.fill,
                                                    placeholder:
                                                        (context, url) =>
                                                            Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                color: Colors.black12,
                                                width: double.infinity,
                                                child: AutoDirection(
                                                  text:
                                                      newsCategory[index].title,
                                                  onDirectionChange: (isRTL) {
                                                    this.isRTL = isRTL;
                                                  },
                                                  child: Text(
                                                    newsCategory[index].title,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Colors.white,
                                                      fontFamily: "OpenSans",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                );
                              },
                              itemCount: newsCategory.length,
                            ),
                          ),
                        ],
                      );
                    } else {
                      internalWidget = Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return internalWidget;
                  },
                  stream: getNews(),
                );
              } else {
                widget = NoInternetWidget(connectionStatus);
              }
            } else {
              widget = Center(
                child: CircularProgressIndicator(),
              );
            }
            return widget;
          },
          future: InternetConnection.internetAvailable(connectivity),
        ),
        onRefresh: getNewsforRefreshIndicator,
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

  // Internet Area
  ConnectivityResult connectionStatus = ConnectivityResult.none;
  StreamSubscription<ConnectivityResult> connectivitySubscription;
  Connectivity connectivity = Connectivity();

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      connectionStatus = result;
    });
  }
// end
}
