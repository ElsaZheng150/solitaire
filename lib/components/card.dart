import 'package:flame/components.dart';
import 'package:solitaire/Solitaire.dart';
import '../rank.dart';
import '../suit.dart';


class Card extends PositionComponent{
  //card details
  final Rank rank;
  final Suit suit;
  bool _faceUp;

  /*
    * Constructor
    * takes integer rank and suit
    * card facing down at first
  */
  Card(int intRank, int intSuit)
      : rank = Rank.fromInt(intRank),
        suit = Suit.fromInt(intSuit),
        _faceUp = false,
        super(size: Solitaire.cardSize);

  //public accessors and mutators for _faceUp
  bool get isFaceUp => _faceUp;
  bool get isFaceDown => !_faceUp;
  void flip() => _faceUp = !_faceUp; //flip the card

  //for debugging
  @override
  String toString() => rank.label + suit.label; //e.g., "Queen of Hearts or 10 of diamonds"
}//end of Card class