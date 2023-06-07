import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MediaMetaData extends StatelessWidget {
   const MediaMetaData ({
     required this.title, required this.artist, required this.image});

final String title;
final String artist;
final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CachedNetworkImage(imageUrl: image,height: 100,),
          Text(title,style: TextStyle(
             color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700
          ),),
        Text(artist,style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700
        ),),
      ],

    );
  }
}
