import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../Solitaire.dart';
import 'Pile.dart';
import 'card.dart';
import 'WastePile.dart';

/*
    * PositionComponent is a component that has a position and size
    * The deck of cards that can be played
*/
class StockPile extends PositionComponent with TapCallbacks, HasGameReference<Solitaire> implements Pile{
  @override
  bool canMoveCard(Card card) => false;

  @override
  bool canAcceptCard(Card card) => false;

  @override
  void removeCard(Card card) => throw StateError('cannot remove cards from here');

  @override
  void returnCard(Card card) => throw StateError('cannot remove cards from here');

  @override
  bool get debugMode => true; //turned on debug mode to view
  
  @override
  void onTapUp(TapUpEvent event) {
    final wastePile = parent!.firstChild<WastePile>()!;
    if (_cards.isEmpty) {
      wastePile.removeAllCards().reversed.forEach((card) {
        card.flip();
        acquireCard(card);
      });
    }//end of if
    else {
      for (var i = 0; i < game.solitaireDraw ; i++) {
        if (_cards.isNotEmpty) {
          final card = _cards.removeLast();
          card.flip();
          wastePile.acquireCard(card);
        }//end of if
      }//end of for loop
    }//end of else
  }//end of onTapUp

  //constructor
  StockPile({super.position}) : super(size: Solitaire.cardSize);

  // Which cards are currently placed onto this pile. The first card in the
  // list is at the bottom, the last card is on top.
  final List<Card> _cards = [];

  //add a card in
  void acquireCard(Card card) {
    assert(!card.isFaceUp);
    card.position = position;
    card.priority = _cards.length;
    card.pile = this;
    _cards.add(card);
  }//end of acquireCard

  //first three cards are flipped and thrown away according to the rules
  @override
  void onTapUp(TapUpEvent event) {
    final wastePile = parent!.firstChild<WastePile>()!;
    if (_cards.isEmpty) {
      wastePile.removeAllCards().reversed.forEach((card) {
        card.flip();
        acquireCard(card);
      });
    } //end of if
    else {
      for (var i = 0; i < 3; i++) {
        if (_cards.isNotEmpty) {
          final card = _cards.removeLast();
          card.flip();
          wastePile.acquireCard(card);
        }//end of if
      }//end of for loop
    }//end of else
  }//end of onTapUp
}//end of Stock class