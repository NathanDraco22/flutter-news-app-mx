

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:news_app/main.dart';
import 'package:news_app/src/models/news_models.dart';
import 'package:news_app/src/services/news_services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;



class ListaNoticias extends StatelessWidget {

  final List<Article> newsList;

  const ListaNoticias({Key? key, required this.newsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return ListView.builder(
      controller: ScrollController(),
      itemCount: newsList.length,
      itemBuilder: (context, index) {

        return _NewsWidget(noticia: newsList[index], index: index);
      },
    );
  }
}

class _NewsWidget extends StatelessWidget {

  final Article noticia;
  final int index;

  const _NewsWidget({
    Key? key,
    required this.noticia,
    required this.index

    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12,),
        _TarjetaTopBar(noticia: noticia,),
        _TarjetaTitulo(noticia: noticia,),
        _TarjetaImagen(noticia: noticia,),
        _TarjetaBotones(noticia: noticia,),
        const Divider(thickness: 2.0,),
      ],
    );
  }
}

class _TarjetaBotones extends StatelessWidget {

  final bool rigth;
  final Article noticia;

  const _TarjetaBotones({
    Key? key,
    this.rigth = false,
    required this.noticia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

     final NewsService newsService = Provider.of<NewsService>(context);

    List<double> borderButtons = [40.0,16.0];
    List<Color?>  buttonsColors = [Colors.blue[400] ,Colors.green[400]];

    if (rigth) {
      borderButtons = borderButtons.reversed.toList();
      buttonsColors = buttonsColors.reversed.toList();
    }

    final bool isFavorite = 
      Hive.box(newsFatoritesBox).containsKey(newsService.generateKeyId(noticia));

    final Icon iconFavorite = isFavorite 
      ? const Icon(Icons.star_rate_rounded, size: 34, color: Colors.yellow,)
      : const Icon(Icons.star_outline_rounded, size: 32);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 64,
          child: MaterialButton(
            child: iconFavorite,
            color: isFavorite ? Colors.blue[800] : buttonsColors[0],
            shape: RoundedRectangleBorder(
              borderRadius: 
                BorderRadius.horizontal(
                  left: Radius.circular(borderButtons[0]),
                  right: Radius.circular(borderButtons[0]) 
                )
            ),
            onPressed: (){
             

              if (isFavorite){
                newsService.removeFromFavorite(noticia);
              }else{
                newsService.addToFavorite(noticia);
              }


            }
          ),
        ),
        
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 64,
          child: MaterialButton(
            child: const Icon(Icons.chevron_right,size: 36,),
            color: buttonsColors[1],
            shape: RoundedRectangleBorder(
              borderRadius: 
                BorderRadius.horizontal(
                  left: Radius.circular(borderButtons[1]),
                  right: Radius.circular(borderButtons[0]) 
                )
            ),
            onPressed: ()async {

              if (await urlLauncher.canLaunch(noticia.url)){

                urlLauncher.launch(noticia.url);
              }
            }
          ),
        )
      ],
    );
  }
}

class _TarjetaImagen extends StatelessWidget {

  final Article noticia; 

  const _TarjetaImagen({
    Key? key,
    required this.noticia
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final String? urlFiltered = noticia.urlToImage.contains("http")
                                ? noticia.urlToImage
                                : null;


    return urlFiltered == null ? const SizedBox()
    :
    ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        bottomRight: Radius.circular(30)
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FadeInImage(
          placeholder: const AssetImage("assets/img/giphy.gif"), 
          image: NetworkImage(urlFiltered)),
      ),
    );
  }
}

class _TarjetaTitulo extends StatelessWidget {

  final Article noticia;

  const _TarjetaTitulo({
    Key? key,
    required this.noticia
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 14,),
      child: Text(
        noticia.title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600
        ),
      ),
    );
  }
}



class _TarjetaTopBar extends StatelessWidget {

  final Article noticia;

  const _TarjetaTopBar({
    Key? key,
    required this.noticia
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 6),
      alignment: Alignment.centerLeft,
      child: Text(
        noticia.source.name, 
        style: TextStyle(color: Colors.red[200]),  
      ),
    );
  }
}