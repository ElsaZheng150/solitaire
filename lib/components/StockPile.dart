import 'package:flame/components.dart';
import '../Solitaire.dart';
import 'card.dart';

/*
    * PositionComponent is a component that has a position and size
*/
class StockPile extends PositionComponent{
  @override
  bool get debugMode => true; //turned on debug mode to view
  StockPile({super.position}) : super(size: Solitaire.cardSize);

  // Which cards are currently placed onto this pile. The first card in the
  // list is at the bottom, the last card is on top.
  final List<Card> _cards = [];

  void acquireCard(Card card) {
    assert(!card.isFaceUp);
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
  }//end of acquireCard
}//end of Stock class