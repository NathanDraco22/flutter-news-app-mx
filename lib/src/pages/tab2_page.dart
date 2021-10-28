

import 'package:flutter/material.dart';
import 'package:news_app/src/models/category_model.dart';
import 'package:news_app/src/services/news_services.dart';
import 'package:news_app/src/widgets/news_list.dart';
import 'package:provider/provider.dart';



class Tab2Page extends StatefulWidget {
  const Tab2Page({Key? key}) : super(key: key);

  @override
  State<Tab2Page> createState() => _Tab2PageState();
}

class _Tab2PageState extends State<Tab2Page> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final newsService = Provider.of<NewsService>(context);


    return SafeArea(
      child: Scaffold(
        body: Column(children:[
          const _ListaCategorias(),

          //------loading news by categories
          newsService.isLoadingCategory 
          ? 
          const Center(child: Padding(
            padding: EdgeInsets.only(top: 16),
            child: CircularProgressIndicator(),
          ),)
          :
          Expanded(child: ListaNoticias(newsList: newsService.getSelectedCategoryNews)),
          //----------------------------
        ],) ,
      ),
    );
  }


}

class _ListaCategorias extends StatelessWidget {
  const _ListaCategorias({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final catogories = Provider.of<NewsService>(context).categories;

    

    return Container(
      width: double.infinity,
      height: 90,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.red, width: 1))

      ),
      child: ListView.builder(
        controller: ScrollController(),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: catogories.length,
        itemBuilder: (BuildContext context, int index) {

          final cName = catogories[index].name;

          return Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                _IconContainer(catogory: catogories[index]),
                const SizedBox(height: 4,),
                Text("${cName[0].toUpperCase()}${cName.substring(1)}"),
                
              ],
            ),
            );
        },
      ),
    );
  }
}

class _IconContainer extends StatelessWidget {
  const _IconContainer({
    Key? key,
    required this.catogory,
  }) : super(key: key);

  final Category catogory;

  @override
  Widget build(BuildContext context) {

    final newsService = Provider.of<NewsService>(context);
    final categorySelected = newsService.selectedCategory;

    return GestureDetector (
      onTap: ()=> newsService.getNewsByCategory(catogory.name),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: categorySelected == catogory.name ? Colors.red : Colors.black45,
          shape: BoxShape.circle
        ),
        child: Icon(catogory.icon)
        
        ),
    );
  }
}
