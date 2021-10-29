import 'package:flutter/material.dart';
import 'package:news_app/src/pages/tabs_page.dart';
import 'package:news_app/src/scroll/custom_scroll.dart';
import 'package:news_app/src/services/news_services.dart';
import 'package:news_app/src/theme/theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ( _ ) => NewsService(),
      child: MaterialApp(
        scrollBehavior: CustomScrollB(),
        debugShowCheckedModeBanner: false,
        theme: myTheme,
        title: 'News App',
        home: const TabPage()
      ),
    );
  }
}