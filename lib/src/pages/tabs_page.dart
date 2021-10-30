import 'package:flutter/material.dart';
import 'package:news_app/src/pages/tab1_page.dart';
import 'package:news_app/src/pages/tab2_page.dart';
import 'package:news_app/src/services/news_services.dart';
import 'package:provider/provider.dart';



class TabPage extends StatelessWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      
      create: ( _ ) => _NavigationModel(),

      child: const Scaffold(
          body:  _Pages(),
          bottomNavigationBar: 
            _Navigation(),
      ),
    );
  }
}

class _Navigation extends StatelessWidget {
  const _Navigation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final navigation = Provider.of<_NavigationModel>(context);

    return BottomNavigationBar(
      backgroundColor: Colors.grey[900],
      currentIndex: navigation.currentPage,
      onTap: (i) {

        navigation.currentPage = i;

        final NewsService newsService =
          Provider.of<NewsService>(context, listen: false);

        newsService.currentPageOption = i;

        if (i > 0) newsService.loadFromDB("favorites");
        
      },
      items:  const [
        BottomNavigationBarItem(
          label: "For You",
          icon: Icon(Icons.person_outline)),
        BottomNavigationBarItem(
          label: "Headers",
          icon: Icon(Icons.public)),
      ],
    );
  }
}




class _Pages extends StatelessWidget {
  const _Pages({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final navigationModel = Provider.of<_NavigationModel>(context);

    return PageView(
      controller: navigationModel.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [

        Tab1Page(),

        Tab2Page(),

      ],
    );
  }
}

class _NavigationModel with ChangeNotifier{

  int _currentPage = 0;

  final PageController _pageController = PageController();

  int get currentPage => _currentPage;

  PageController get pageController => _pageController;

  set currentPage(int value){

    _pageController.animateToPage(
      value, 
      duration: const Duration(milliseconds: 500), 
      curve: Curves.easeOut);
    
    _currentPage = value;

    notifyListeners();
 
  }

}