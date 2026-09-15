import 'dart:ui';
import 'package:flame/components.dart';
import 'package:solitaire/Solitaire.dart';
import 'Pile.dart';
import 'card.dart';

/*
    * PositionComponent is a component that has a position and size
*/
class TableauPile extends PositionComponent implements Pile{
  @override
  bool canMoveCard(Card card) => card.isFaceUp;

  @override
  bool canAcceptCard(Card card) {
    if (_cards.isEmpty) {
      return card.rank.value == 13;
    }//end of if
    else {
      final topCard = _cards.last;
      return card.suit.isRed == !topCard.suit.isRed &&
          card.rank.value == topCard.rank.value - 1;
    }//end of else
  }//end of canAcceptCard

  @override
  void removeCard(Card card) {
    assert(_cards.contains(card) && card.isFaceUp);
    final index = _cards.indexOf(card);
    _cards.removeRange(index, _cards.length);
    if (_cards.isNotEmpty && _cards.last.isFaceDown) {
      flipTopCard();
    }//end of if
  }//end of removeCard

  @override
  void returnCard(Card card) {
    final index = _cards.indexOf(card);
    card.position =
    index == 0 ? position : _cards[index - 1].position + _fanOffset;
    card.priority = index;
  }//end of returnCard

  @override
  bool get debugMode => true; //turned on debug mode to view
  // Which cards are currently placed onto this pile.
  final List<Card> _cards = [];
  final Vector2 _fanOffset = Vector2(0, Solitaire.cardHeight * 0.05);
  final Vector2 _fanOffset1 = Vector2(0, Solitaire.cardHeight * 0.05);
  final Vector2 _fanOffset2 = Vector2(0, Solitaire.cardHeight * 0.20);

  TableauPile({super.position}) : super(size: Solitaire.cardSize);

  void acquireCard(Card card) {
    if (_cards.isEmpty) {
      card.position = position;
    }//end of if
    else {
      card.position = _cards.last.position + _fanOffset;
    }//end of else
    card.priority = _cards.length;
    card.pile = this;
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

  void layOutCards() {
    if (_cards.isEmpty) {
      return;
    }//end of if
    _cards[0].position.setFrom(position);
    for (var i = 1; i < _cards.length; i++) {
      _cards[i].position
        ..setFrom(_cards[i - 1].position)
        ..add(_cards[i - 1].isFaceDown ? _fanOffset1 : _fanOffset2);
    }//end of for loop
    height = Solitaire.cardHeight * 1.5 + _cards.last.y - _cards.first.y;
  }//end of layOutCards

  //to figure out which cards are stacked on each other
  List<Card> cardsOnTop(Card card) {
    assert(card.isFaceUp && _cards.contains(card));
    final index = _cards.indexOf(card);
    return _cards.getRange(index + 1, _cards.length).toList();
  }//end of cardsOnTop
}//end of Pile class