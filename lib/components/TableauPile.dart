import 'dart:ui';
import 'package:flame/components.dart';
import 'package:solitaire/Solitaire.dart';
import 'Pile.dart';
import 'card.dart';

/*
    * PositionComponent is a component that has a position and size
*/
class TableauPile extends PositionComponent implements Pile{
  //Drag can move multiple cards: tap can move last card only (to Foundation).
  @override
  bool canMoveCard(Card card, MoveMethod method) =>
      card.isFaceUp && (method == MoveMethod.drag || card == _cards.last);

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
  void removeCard(Card card, MoveMethod method) {
    assert(_cards.contains(card) && card.isFaceUp);
    final index = _cards.indexOf(card);
    _cards.removeRange(index, _cards.length);
    if (_cards.isNotEmpty && _cards.last.isFaceDown) {
      flipTopCard();
      return;
    }//end of if
    layOutCards();
  }//end of removeCard

  @override
  void returnCard(Card card) {
    card.priority = _cards.indexOf(card);
    layOutCards();
  }//end of returnCard

  @override
  void acquireCard(Card card) {
    card.pile = this;
    card.priority = _cards.length;
    _cards.add(card);
    layOutCards();
  }//end of acquireCard

  // Which cards are currently placed onto this pile.
  final List<Card> _cards = [];
  final Vector2 _fanOffset1 = Vector2(0, Solitaire.cardHeight * 0.05);
  final Vector2 _fanOffset2 = Vector2(0, Solitaire.cardHeight * 0.20);

  TableauPile({super.position}) : super(size: Solitaire.cardSize);

  //take a card, see it, and decide to play it or not
  void flipTopCard({double start = 0.1}) {
    assert(_cards.last.isFaceDown);
    _cards.last.turnFaceUp(
      start: start,
      onComplete: layOutCards,
    );
  }//end of flipTopCard

  void layOutCards() {
    if(_cards.isEmpty) {
      calculateHitArea(); //shrink hit-area when all cards have been removed.
      return;
    }//end of if
    _cards[0].position.setFrom(position);
    _cards[0].priority = 0;
    for(var i = 1; i < _cards.length; i++) {
      _cards[i].priority = i;
      _cards[i].position
        ..setFrom(_cards[i - 1].position)
        ..add(_cards[i - 1].isFaceDown ? _fanOffset1 : _fanOffset2);
    }//end of for loop
    calculateHitArea(); //Adjust hit-area to more cards or fewer cards.
  }//end of layOutCards

  //helper method
  void calculateHitArea() {
    height = Solitaire.cardHeight * 1.5 + (_cards.length < 2 ? 0.0 : _cards.last.y - _cards.first.y);
  }//end of calculateHitArea

  //to figure out which cards are stacked on each other
  List<Card> cardsOnTop(Card card) {
    assert(card.isFaceUp && _cards.contains(card));
    final index = _cards.indexOf(card);
    return _cards.getRange(index + 1, _cards.length).toList();
  }//end of cardsOnTop

  //placing the cards down in their respective piles
  void dropCards(Card firstCard, [List<Card> attachedCards = const []]) {
    final cardList = [firstCard];
    cardList.addAll(attachedCards);
    Vector2 nextPosition = _cards.isEmpty ? position : _cards.last.position;
    var nCardsToMove = cardList.length;
    for (final card in cardList) {
      card.pile = this;
      card.priority = _cards.length;
      if (_cards.isNotEmpty) {
        nextPosition =
            nextPosition + (card.isFaceDown ? _fanOffset1 : _fanOffset2);
      }//end of if
      _cards.add(card);
      card.doMove(
        nextPosition,
        startPriority: card.priority,
        onComplete: () {
          nCardsToMove--;
          if (nCardsToMove == 0) {
            calculateHitArea(); // Expand the hit-area.
          }//end of if
        },//end of onComplete
      );
    }//end of for loop
  }//end of dropCards

  //region rendering
  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0x50ffffff);

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(Solitaire.cardRRect, _borderPaint);
  }//end of render
}//end of Pile class