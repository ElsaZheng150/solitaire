import 'package:flame/components.dart';
import '../Solitaire.dart';
import 'Pile.dart';
import 'card.dart';

/*
    * PositionComponent is a component that has a position and size
    * The pile of cards that are skipped and let back in after the stock is gone
*/
class WastePile extends PositionComponent with HasGameReference<Solitaire> implements Pile {
  //Tap and drag cards ok
  @override
  bool canMoveCard(Card card, MoveMethod method) => _cards.isNotEmpty && card == _cards.last;

  @override
  bool canAcceptCard(Card card) => false;

  @override
  void removeCard(Card card, MoveMethod method) {
    assert(canMoveCard(card, method));
    _cards.removeLast();
    _fanOutTopCards();
  }//end of removeCard

  @override
  void returnCard(Card card) {
    card.priority = _cards.indexOf(card);
    _fanOutTopCards();
  }//end of returnCard

  @override
  void acquireCard(Card card) {
    assert(card.isFaceUp);
    card.pile = this;
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
    _fanOutTopCards();
  }//end of acquireCard

  /*
  @override
  bool get debugMode => true; //turned on debug mode to view
  */

  //constructor
  WastePile({super.position}) : super(size: Solitaire.cardSize);

  final List<Card> _cards = []; //cards in the waste pile
  final Vector2 _fanOffset = Vector2(Solitaire.cardWidth * 0.2, 0); //determines shift between cards

  void _fanOutTopCards() {
    if (game.solitaireDraw == 1) {   // No fan-out in Klondike Draw 1.
      return;
    }//end of if
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