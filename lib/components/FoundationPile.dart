import 'dart:ui';
import 'package:flame/components.dart';
import '../Solitaire.dart';
import '../suit.dart';
import 'Pile.dart';
import 'card.dart';

/*
    * PositionComponent is a component that has a position and size
*/
class FoundationPile extends PositionComponent implements Pile{
  @override
  bool canMoveCard(Card card) => _cards.isNotEmpty && card == _cards.last;

  @override
  bool canAcceptCard(Card card) {
    final topCardRank = _cards.isEmpty ? 0 : _cards.last.rank.value;
    return card.suit == suit &&
        card.rank.value == topCardRank + 1 &&
        card.attachedCards.isEmpty;
  }//end of canAcceptCard

  @override
  void removeCard(Card card) {
    assert(canMoveCard(card));
    _cards.removeLast();
  }//end of removeCard

  @override
  void returnCard(Card card) {
    card.position = position;
    card.priority = _cards.indexOf(card);
  }//end of returnCard

  @override
  bool get debugMode => true; //turned on debug mode to view
  final Suit suit; //what kind of card is it
  final List<Card> _cards = []; //to hold the cards

  //constructor
  FoundationPile(int intSuit, {super.position})
      : suit = Suit.fromInt(intSuit),
        super(size: Solitaire.cardSize);

  //add card in
  void acquireCard(Card card) {
    assert(card.isFaceUp);
    card.position = position;
    card.priority = _cards.length;
    card.pile = this;
    _cards.add(card);
  }//end of acquireCard

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(Solitaire.cardRRect, _borderPaint);
    suit.sprite.render(
      canvas,
      position: size / 2,
      anchor: Anchor.center,
      size: Vector2.all(Solitaire.cardWidth * 0.6),
      overridePaint: _suitPaint,
    );
  }//end of render

  //helper methods for render
  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0x50ffffff);
  late final _suitPaint = Paint()
    ..color = suit.isRed? const Color(0x3a000000) : const Color(0x64000000)
    ..blendMode = BlendMode.luminosity;
}//end of Foundation class