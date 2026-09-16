import 'dart:ui';

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
class StockPile extends PositionComponent with HasGameReference<Solitaire> implements Pile{
  @override
  bool canMoveCard(Card card, MoveMethod method) => false;

  @override
  bool canAcceptCard(Card card) => false;

  @override
  void removeCard(Card card, MoveMethod method) => throw StateError('cannot remove cards from here');

  @override
  //Card cannot be removed but could have been dragged out of place.
  void returnCard(Card card) => card.priority = _cards.indexOf(card);

  @override
  void acquireCard(Card card) {
    assert(card.isFaceDown);
    card.pile = this;
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
  }//end of acquireCard

  /*
  @override
  bool get debugMode => true; //turned on debug mode to view
  */

  //constructor
  StockPile({super.position}) : super(size: Solitaire.cardSize);

  // Which cards are currently placed onto this pile. The first card in the
  // list is at the bottom, the last card is on top.
  final List<Card> _cards = [];

  void handleTapUp(Card card) {
    final wastePile = parent!.firstChild<WastePile>()!;
    if (_cards.isEmpty) {
      assert(card.isBaseCard, 'Stock Pile is empty, but no Base Card present');
      card.position = position; // Force Base Card (back) into correct position.
      wastePile.removeAllCards().reversed.forEach((card) {
        card.flip();
        acquireCard(card);
      });//end of forEach loop
    } //end of if
    else {
      for (var i = 0; i < game.solitaireDraw; i++) {
        if (_cards.isNotEmpty) {
          final card = _cards.removeLast();
          card.doMoveAndFlip(
            wastePile.position,
            whenDone: () {
              wastePile.acquireCard(card);
            },//end of whenDone
          );
        }//end of if
      }//end of for loop
    }//end of else
  }//end of handleTapUp

  //region Rendering

  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0xFF3F5B5D);
  final _circlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 100
    ..color = const Color(0x883F5B5D);

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(Solitaire.cardRRect, _borderPaint);
    canvas.drawCircle(
      Offset(width / 2, height / 2),
      Solitaire.cardWidth * 0.3,
      _circlePaint,
    );
  }

}//end of Stock class