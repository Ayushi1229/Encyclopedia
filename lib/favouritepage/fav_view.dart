import 'package:flutter/material.dart';

class FavView extends StatelessWidget {
  const FavView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text("Favourites"),backgroundColor: Colors.deepOrange,foregroundColor: Colors.white,),
    );
  }
}
