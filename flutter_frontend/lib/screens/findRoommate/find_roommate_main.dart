import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter/material.dart';

class OurFindRoommateMain extends StatefulWidget{
  @override
  State<OurFindRoommateMain> createState() => _OurFindRoommateMainState();
}

class _OurFindRoommateMainState extends State<OurFindRoommateMain> {
  List<Container> cards = [
    Container(
      alignment: Alignment.center,
      child: const Text('1'),
      color: Colors.blue,
    ),
    Container(
      alignment: Alignment.center,
      child: const Text('2'),
      color: Colors.red,
    ),
    Container(
      alignment: Alignment.center,
      child: const Text('3'),
      color: Colors.purple,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flexible(
        child: CardSwiper(
          cardsCount: cards.length,
          cardBuilder: (context, index, percentThresholdX, percentThresholdY) => cards[index],
        ),
      ),
    );
  }


  _getAllCards(){
    
  }
}