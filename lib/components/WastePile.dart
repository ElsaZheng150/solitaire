import 'package:flame/components.dart';
import '../Solitaire.dart';
import 'card.dart';

/*
    * PositionComponent is a component that has a position and size
    * The pile of cards that are skipped and let back in after the stock is gone
*/
class WastePile extends PositionComponent{
  @override
  bool get debugMode => true; //turned on debug mode to view

  //constructor
  WastePile({super.position}) : super(size: Solitaire.cardSize);

  final List<Card> _cards = []; //cards in the waste pile
  final Vector2 _fanOffset = Vector2(Solitaire.cardWidth * 0.2, 0); //determines shift between cards

  //add a card in
  void acquireCard(Card card) {
    assert(card.isFaceUp);
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
  }//end of acquireCard

  //must flip three cards at a time
  void _fanOutTopCards() {
    final n = _cards.length;
    for (var i = 0; i < n; i++) {
      _cards[i].position = position;
    }//end of for loop
    if (n == 2) {
      _cards[1].position.add(_fanOffset);
    }//end of if
    else if (n >= 3) {
      _cards[n - 2].position.add(_fanOffset);
      _cards[n - 1].position.addScaled(_fanOffset, 2);
    }//end of else if
  }//end of _fanOutTopCards

  //empty pile so cards can be played again
  List<Card> removeAllCards() {
    final cards = _cards.toList();
    _cards.clear();
    return cards;
  }//end of removeAllCards
}//end of Waste class