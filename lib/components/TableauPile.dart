import 'dart:ui';

import 'package:flame/components.dart';
import 'package:solitaire/Solitaire.dart';

import 'card.dart';

/*
    * PositionComponent is a component that has a position and size
 */
class TableauPile extends PositionComponent{
  @override
  bool get debugMode => true; //turned on debug mode to view
  // Which cards are currently placed onto this pile.
  final List<Card> _cards = [];
  final Vector2 _fanOffset = Vector2(0, Solitaire.cardHeight * 0.05);

  TableauPile({super.position}) : super(size: Solitaire.cardSize);

  void acquireCard(Card card) {
    if (_cards.isEmpty) {
      card.position = position;
    }//end of if
    else {
      card.position = _cards.last.position + _fanOffset;
    }//end of else
    card.priority = _cards.length;
    _cards.add(card);
  }//end of acquireCard

  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0x50ffffff);

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(Solitaire.cardRRect, _borderPaint);
  }//end of render

  //take a card, see it, and decide to play it or not
  void flipTopCard() {
    assert(_cards.last.isFaceDown);
    _cards.last.flip();
  }//end of flipTopCard
}//end of Pile class