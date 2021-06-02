import 'dart:async';
import 'package:auto_direction/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newsapp/helpers/data.dart';
import 'package:newsapp/models/category_model.dart';
import 'package:newsapp/models/news_model.dart';
import 'dart:math' as math;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  NewsModel newsModel = NewsModel();
  List<CategoryModel> categories = [];
  List<NewsModel> topNews = [];
  bool isRTL = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categories = getCategories();
    getTopNews();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    categories = getCategories();
  }

  Stream<List<NewsModel>> getTopNews() async* {
    topNews.clear();
    topNews.addAll(await newsModel.getTopHeadlinesNews());
    yield topNews;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context, snapshot) {
        Widget widget;
        if (snapshot.hasData) {
          widget = Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.red),
              backgroundColor: Colors.white,
              title: Padding(
                padding: EdgeInsets.only(right: 50.0),
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
              ),
              centerTitle: true,
            ),
            drawer: Theme(
              data: Theme.of(context).copyWith(canvasColor: Colors.white),
              child: Drawer(
                elevation: 0.0,
                child: ListView(
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage("assets/images/news_header.jpg"),
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
                    listTile("assets/images/entertainment_icon.svg",
                        "Entertainment", "/news_by_category"),
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
            body: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5),
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/news_by_category",
                              arguments: categories[index].categoryName);
                        },
                        child: categoryItem(categories[index].categoryName,
                            categories[index].imageUrl),
                      );
                    },
                    itemCount: categories.length,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "/new_view",
                              arguments: topNews[index].newUrl);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 15, right: 7, left: 7),
                          child: topNews[index].urlToImage == null
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
                                            color: Colors.black45,
                                            blurRadius: 10.0,
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        child: CachedNetworkImage(
                                          imageUrl: topNews[index].urlToImage,
                                          width: double.infinity,
                                          height: 250,
                                          fit: BoxFit.fill,
                                          placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          width: double.infinity,
                                          color: Colors.black12,
                                          child: AutoDirection(
                                            text: topNews[index].title,
                                            onDirectionChange: (isRTL) {
                                              this.isRTL = isRTL;
                                            },
                                            child: Text(
                                              topNews[index].title,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontFamily: "OpenSans",
                                              ),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    },
                    itemCount: snapshot.data.length,
                  ),
                ),
              ],
            ),
          );
        } else
          widget = Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: Padding(
                padding: EdgeInsets.only(right: 25.0),
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
              ),
              centerTitle: true,
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        return widget;
      },
      stream: getTopNews(),
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
        Navigator.of(context).pushNamed(route, arguments: title);
      },
    );
  }

  Widget categoryItem(String name, String url) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              url,
              width: 120,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: 120,
            height: 80,
            color: Colors.black26,
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
