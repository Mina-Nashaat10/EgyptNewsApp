import 'package:auto_direction/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newsapp/models/news_model.dart';

class NewsByCategory extends StatefulWidget {
  @override
  _NewsByCategoryState createState() => _NewsByCategoryState();
}

class _NewsByCategoryState extends State<NewsByCategory> {
  List<NewsModel> newsCategory = List();
  NewsModel newsModel = new NewsModel();
  String category;
  bool isRTL = false;

  Stream<List<NewsModel>> getNews() async* {
    newsCategory.addAll(await newsModel.getNewsByCategory(category));
    yield newsCategory;
  }

  @override
  Widget build(BuildContext context) {
    category = ModalRoute.of(context).settings.arguments;
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/home", (route) => false);
      },
      child: StreamBuilder(
        builder: (context, snapshot) {
          Widget widget;
          if (snapshot.hasData) {
            widget = Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.red),
                backgroundColor: Colors.white,
                elevation: 0.0,
                title: Padding(
                  padding: EdgeInsets.only(right: 40),
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
                      listTile("assets/images/technology_icon.svg",
                          "Technology", "/news_by_category"),
                    ],
                  ),
                ),
              ),
              body: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
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
                            margin: EdgeInsets.only(top: 15, right: 7, left: 7),
                            child: newsCategory[index].urlToImage == null
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                newsCategory[index].urlToImage,
                                            width: double.infinity,
                                            height: 250,
                                            fit: BoxFit.fill,
                                            placeholder: (context, url) =>
                                                Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        color: Colors.black12,
                                        width: double.infinity,
                                        child: AutoDirection(
                                          text: newsCategory[index].title,
                                          onDirectionChange: (isRTL) {
                                            this.isRTL = isRTL;
                                          },
                                          child: Text(
                                            newsCategory[index].title,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
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
                      itemCount: snapshot.data.length,
                    ),
                  ),
                ],
              ),
            );
          } else {
            widget = Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0.0,
                title: Padding(
                  padding: EdgeInsets.only(right: 40),
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
          }
          return widget;
        },
        stream: getNews(),
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
