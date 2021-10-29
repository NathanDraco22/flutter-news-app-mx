
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/src/models/category_model.dart';
import 'package:news_app/src/models/news_models.dart';
import 'package:http/http.dart' as http;



const _URL_NEWS = "https://newsapi.org/v2";
const _API_KEY = "2f455f3a5a4d40cf90d3208de7771658";

class NewsService with ChangeNotifier{

  bool isLoadingCategory = false;

  List<Category> categories = [
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
    

    const url = "$_URL_NEWS/top-headlines?country=mx&apiKey=$_API_KEY"; 

    final resp = await http.get(Uri.parse(url));

    final NewsResponse newsResponse = newsResponseFromJson(resp.body);

    headlines.addAll(newsResponse.articles);

    notifyListeners();
  }

  getNewsByCategory( String category )async {

    selectedCategory = category;

    if (!mapCategories.containsKey(category)){

      isLoadingCategory = true;
      notifyListeners();

      final url = "$_URL_NEWS/top-headlines?country=mx&apiKey=$_API_KEY&category=$category"; 

      final resp = await http.get(Uri.parse(url));

      final NewsResponse newsResponse = newsResponseFromJson(resp.body);

      mapCategories[category] = newsResponse.articles;

      isLoadingCategory = false;
      notifyListeners();
  
    
    }

    

  }
}
