import 'dart:convert';

import 'package:http/http.dart' as http;

class NewsModel {
  String _author;
  String _title;
  String _description;
  String _newUrl;
  String _urlToImage;
  String _publishedAt;
  String _content;

  String get author => _author;

  set author(String value) {
    _author = value;
  }

  String get title => _title;

  String get content => _content;

  set content(String value) {
    _content = value;
  }

  String get publishedAt => _publishedAt;

  set publishedAt(String value) {
    _publishedAt = value;
  }

  String get urlToImage => _urlToImage;

  set urlToImage(String value) {
    _urlToImage = value;
  }

  String get newUrl => _newUrl;

  set newUrl(String value) {
    _newUrl = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  set title(String value) {
    _title = value;
  }

  Future<List<NewsModel>> getNewsByCategory(String category) async {
    List<NewsModel> news = [];
    NewsModel newModel;
    String url =
        "http://newsapi.org/v2/top-headlines?country=eg&category=$category&apiKey=f935d00de8c4491ea58fce7128db87fd";
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        newModel = new NewsModel();
        newModel.author = element['author'];
        newModel.title = element['title'];
        newModel.description = element['description'];
        newModel.newUrl = element['url'];
        newModel.urlToImage = element['urlToImage'];
        newModel.publishedAt = element['publishedAt'];
        newModel.content = element['content'];
        news.add(newModel);
      });
    }
    return news;
  }

  Future<List<NewsModel>> getTopHeadlinesNews() async {
    List<NewsModel> news = List();
    NewsModel newModel;
    String url =
        "https://newsapi.org/v2/top-headlines?country=eg&apiKey=f935d00de8c4491ea58fce7128db87fd";
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        newModel = new NewsModel();
        newModel.author = element['author'];
        newModel.title = element['title'];
        newModel.description = element['description'];
        newModel.newUrl = element['url'];
        newModel.urlToImage = element['urlToImage'];
        newModel.publishedAt = element['publishedAt'];
        newModel.content = element['content'];
        news.add(newModel);
      });
    } else
      print("get failed");
    return news;
  }
}
