import 'package:flutter/cupertino.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'Solitaire.dart';

/*
  * objects of this class should not be modified after creation
 */
@immutable class Suit{
  final int value; //card value
  final String label; //card name
  final Sprite sprite; //card image
  //singletons list
  static final List<Suit> _singletons = [
    Suit._(0, '♥', 1176, 17, 172, 183),
    Suit._(1, '♦', 973, 14, 177, 182),
    Suit._(2, '♣', 974, 226, 184, 172),
    Suit._(3, '♠', 1178, 220, 176, 182),
  ];
  //to enforce that cards need to be placed into alternating color piles
  bool get isRed => value <= 1;
  bool get isBlack => value >= 2;

  /*
    * using factory constructor to force a singleton pattern for the class
    * does not create a new object every time
    * returns to pre built objects in singletons list
   */
  factory Suit.fromInt(int index){
    assert(index>=0 && index<=3);
    return _singletons[index];
  }//end of Suit.fromInt

  /*
    * private constructor
    initializes the main properties of each Suit object (numeric val, string label, sprite object)
   */
  Suit._(this.value, this.label, double x, double y, double w, double h) : sprite = solitaireSprite(x,y,w,h);
}//end of Suit class