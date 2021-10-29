
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:news_app/main.dart';
import 'package:news_app/src/models/category_model.dart';
import 'package:news_app/src/models/news_models.dart';
import 'package:http/http.dart' as http;



const urlNEWS = "https://newsapi.org/v2";
const apiKEY = "2f455f3a5a4d40cf90d3208de7771658";

class NewsService with ChangeNotifier{

  bool isLoadingCategory = false;

  List<Category> categories = [
    Category(icon: Icons.star, name: "favorites"),
    Category(icon: FontAwesomeIcons.building, name: "business"),
    Category(icon: FontAwesomeIcons.tv, name: "entertainment"),
    Category(icon: FontAwesomeIcons.addressCard, name: "general"),
    Category(icon: FontAwesomeIcons.headSideVirus, name: "health"),
    Category(icon: FontAwesomeIcons.vials, name: "science"),
    Category(icon: FontAwesomeIcons.volleyballBall, name: "sports"),
    Category(icon: FontAwesomeIcons.memory, name: "technology")


  ];

  String _selectedCategory = "business";

  Map<String, List<Article>> mapCategories = <String,List<Article>>{};

  String get selectedCategory => _selectedCategory;

  List<Article> get getSelectedCategoryNews => mapCategories[_selectedCategory]!;



  set selectedCategory(String value){
    _selectedCategory = value;

    notifyListeners();
  }

  List<Article> headlines = [];

//----- Constructor ------------------------------------------------------------

  NewsService(){

    categories.map((item){

      mapCategories[item.name] = [];

    });

    getTopHeadlines();

    getNewsByCategory(_selectedCategory);

  }

//------------------------------------------------------------------------------

  getTopHeadlines() async {
    
    const url = "$urlNEWS/top-headlines?country=mx&apiKey=$apiKEY"; 

    final resp = await http.get(Uri.parse(url));

    final NewsResponse newsResponse = newsResponseFromJson(resp.body);

    headlines.addAll(newsResponse.articles);

    notifyListeners();
  }

  getNewsByCategory( String category )async {

    selectedCategory = category;

    if (!mapCategories.containsKey(category) && category != "favorites"){

      isLoadingCategory = true;
      notifyListeners();

      final url = "$urlNEWS/top-headlines?country=mx&apiKey=$apiKEY&category=$category"; 

      final resp = await http.get(Uri.parse(url));

      final NewsResponse newsResponse = newsResponseFromJson(resp.body);

      mapCategories[category] = newsResponse.articles;

      isLoadingCategory = false;
      notifyListeners();
    }else if (category == "favorites"){

      loadFromDB(category);

    }

 
 
  }

  Map<String,Article> newsFavoritesMap = {};

  addToFavorite(Article article)async{

    String keyBox = generateKeyId(article);
    String jsonString = json.encode(article.toJson());

    await Hive.box(newsFatoritesBox).put(keyBox,jsonString);

    newsFavoritesMap[keyBox] = article;

    notifyListeners();

  }

  removeFromFavorite(Article article)async{

    String keyBox = generateKeyId(article);

    await Hive.box(newsFatoritesBox).delete(keyBox);

    newsFavoritesMap.remove(keyBox);

    notifyListeners();
  }

  loadFromDB(String category){
          final Iterable dataFromDB = Hive.box(newsFatoritesBox).values;

      final List<Article> listArticleFromDB = dataFromDB.map((e){

        final jsonMap = json.decode(e);

        return Article.fromJson(jsonMap);

      }).toList();

      mapCategories[category] = listArticleFromDB;

      notifyListeners();
  }  

  String generateKeyId(Article article) {
    
    final utf8String = article.title.substring(0,10) + article.author;

    final asciiString = utf8String.replaceAll(RegExp("[^\\x00-\\x7F]"), "");



    return asciiString;
  }
}
