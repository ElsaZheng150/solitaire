import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:solitaire/Solitaire.dart';
import '../rank.dart';
import '../suit.dart';
import 'Pile.dart';
import 'TableauPile.dart';

class Card extends PositionComponent with DragCallbacks{
  //card details
  final Rank rank;
  final Suit suit;
  bool _faceUp;
  Pile? pile;
  final List<Card> attachedCards = []; //cards the move in a stack
  //public accessors and mutators for _faceUp
  bool get isFaceUp => _faceUp;
  bool get isFaceDown => !_faceUp;
  void flip() => _faceUp = !_faceUp; //flip the card
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

  //creates a board the game rests on
  @override
  void render(Canvas canvas) {
    if (_faceUp) {
      _renderFront(canvas);
    }//end of if
    else {
      _renderBack(canvas);
    }//end of else
  }//end of render

  //renders the front of the card with the details
  void _renderFront(Canvas canvas) {
    canvas.drawRRect(cardRRect, frontBackgroundPaint);
    canvas.drawRRect(
      cardRRect,
      suit.isRed ? redBorderPaint : blackBorderPaint,
    );

    final rankSprite = suit.isBlack ? rank.blackSprite : rank.redSprite;
    final suitSprite = suit.sprite;
    _drawSprite(canvas, rankSprite, 0.1, 0.08);
    _drawSprite(canvas, rankSprite, 0.1, 0.08, rotate: true);
    _drawSprite(canvas, suitSprite, 0.1, 0.18, scale: 0.5);
    _drawSprite(canvas, suitSprite, 0.1, 0.18, scale: 0.5, rotate: true);

    switch (rank.value) {
      case 1:
        _drawSprite(canvas, suitSprite, 0.5, 0.5, scale: 2.5);
      case 2:
        _drawSprite(canvas, suitSprite, 0.5, 0.25);
        _drawSprite(canvas, suitSprite, 0.5, 0.25, rotate: true);
      case 3:
        _drawSprite(canvas, suitSprite, 0.5, 0.2);
        _drawSprite(canvas, suitSprite, 0.5, 0.5);
        _drawSprite(canvas, suitSprite, 0.5, 0.2, rotate: true);
      case 4:
        _drawSprite(canvas, suitSprite, 0.3, 0.25);
        _drawSprite(canvas, suitSprite, 0.7, 0.25);
        _drawSprite(canvas, suitSprite, 0.3, 0.25, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.25, rotate: true);
      case 5:
        _drawSprite(canvas, suitSprite, 0.3, 0.25);
        _drawSprite(canvas, suitSprite, 0.7, 0.25);
        _drawSprite(canvas, suitSprite, 0.3, 0.25, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.25, rotate: true);
        _drawSprite(canvas, suitSprite, 0.5, 0.5);
      case 6:
        _drawSprite(canvas, suitSprite, 0.3, 0.25);
        _drawSprite(canvas, suitSprite, 0.7, 0.25);
        _drawSprite(canvas, suitSprite, 0.3, 0.5);
        _drawSprite(canvas, suitSprite, 0.7, 0.5);
        _drawSprite(canvas, suitSprite, 0.3, 0.25, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.25, rotate: true);
      case 7:
        _drawSprite(canvas, suitSprite, 0.3, 0.2);
        _drawSprite(canvas, suitSprite, 0.7, 0.2);
        _drawSprite(canvas, suitSprite, 0.5, 0.35);
        _drawSprite(canvas, suitSprite, 0.3, 0.5);
        _drawSprite(canvas, suitSprite, 0.7, 0.5);
        _drawSprite(canvas, suitSprite, 0.3, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.2, rotate: true);
      case 8:
        _drawSprite(canvas, suitSprite, 0.3, 0.2);
        _drawSprite(canvas, suitSprite, 0.7, 0.2);
        _drawSprite(canvas, suitSprite, 0.5, 0.35);
        _drawSprite(canvas, suitSprite, 0.3, 0.5);
        _drawSprite(canvas, suitSprite, 0.7, 0.5);
        _drawSprite(canvas, suitSprite, 0.3, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.5, 0.35, rotate: true);
      case 9:
        _drawSprite(canvas, suitSprite, 0.3, 0.2);
        _drawSprite(canvas, suitSprite, 0.7, 0.2);
        _drawSprite(canvas, suitSprite, 0.5, 0.3);
        _drawSprite(canvas, suitSprite, 0.3, 0.4);
        _drawSprite(canvas, suitSprite, 0.7, 0.4);
        _drawSprite(canvas, suitSprite, 0.3, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.3, 0.4, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.4, rotate: true);
      case 10:
        _drawSprite(canvas, suitSprite, 0.3, 0.2);
        _drawSprite(canvas, suitSprite, 0.7, 0.2);
        _drawSprite(canvas, suitSprite, 0.5, 0.3);
        _drawSprite(canvas, suitSprite, 0.3, 0.4);
        _drawSprite(canvas, suitSprite, 0.7, 0.4);
        _drawSprite(canvas, suitSprite, 0.3, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.2, rotate: true);
        _drawSprite(canvas, suitSprite, 0.5, 0.3, rotate: true);
        _drawSprite(canvas, suitSprite, 0.3, 0.4, rotate: true);
        _drawSprite(canvas, suitSprite, 0.7, 0.4, rotate: true);
      case 11:
        _drawSprite(canvas, suit.isRed? redJack : blackJack, 0.5, 0.5);
      case 12:
        _drawSprite(canvas, suit.isRed? redQueen : blackQueen, 0.5, 0.5);
      case 13:
        _drawSprite(canvas, suit.isRed? redKing : blackKing, 0.5, 0.5);
    }
  }//end of _renderFront

  //renders the back of the card with the design
  void _renderBack(Canvas canvas) {
    canvas.drawRRect(cardRRect, backBackgroundPaint);
    canvas.drawRRect(cardRRect, backBorderPaint1);
    canvas.drawRRect(backRRectInner, backBorderPaint2);
    flameSprite.render(canvas, position: size / 2, anchor: Anchor.center);
  }//end of _renderBack

  //helper methods for _renderBack
  static final Paint backBackgroundPaint = Paint()
    ..color = const Color(0xff380c02);
  static final Paint backBorderPaint1 = Paint()
    ..color = const Color(0xffdbaf58)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;
  static final Paint backBorderPaint2 = Paint()
    ..color = const Color(0x5CEF971B)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 35;
  static final RRect cardRRect = RRect.fromRectAndRadius(
    Solitaire.cardSize.toRect(),
    const Radius.circular(Solitaire.cardRadius),
  );
  static final RRect backRRectInner = cardRRect.deflate(40);
  static final Sprite flameSprite = solitaireSprite(1367, 6, 357, 501);

  //helper for _renderFront
  static final Paint frontBackgroundPaint = Paint()
    ..color = const Color(0xff000000);
  static final Paint redBorderPaint = Paint()
    ..color = const Color(0xffece8a3)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;
  static final Paint blackBorderPaint = Paint()
    ..color = const Color(0xff7ab2e8)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;
  static final Sprite redJack = solitaireSprite(81, 565, 562, 488);
  static final Sprite redQueen = solitaireSprite(717, 541, 486, 515);
  static final Sprite redKing = solitaireSprite(1305, 532, 407, 549);
  static final blueFilter = Paint()
    ..colorFilter = const ColorFilter.mode(
      Color(0x880d8bff),
      BlendMode.srcATop,
    );
  static final Sprite blackJack = solitaireSprite(81, 565, 562, 488)
    ..paint = blueFilter;
  static final Sprite blackQueen = solitaireSprite(717, 541, 486, 515)
    ..paint = blueFilter;
  static final Sprite blackKing = solitaireSprite(1305, 532, 407, 549)
    ..paint = blueFilter;

  void _drawSprite(
      Canvas canvas,
      Sprite sprite,
      double relativeX,
      double relativeY, {
        double scale = 1,
        bool rotate = false,
      }) {//end of relativeY
    if (rotate) {
      canvas.save();
      canvas.translate(size.x / 2, size.y / 2);
      canvas.rotate(pi);
      canvas.translate(-size.x / 2, -size.y / 2);
    }//end of if
    sprite.render(
      canvas,
      position: Vector2(relativeX * size.x, relativeY * size.y),
      anchor: Anchor.center,
      size: sprite.srcSize.scaled(scale),
    );
    if (rotate) {
      canvas.restore();
    }//end of if
  }//end of _drawSprite

  //methods to allow user to drag and drop the cards
  @override
  void onDragStart(DragStartEvent event) {
    if (pile?.canMoveCard(this) ?? false) {
      super.onDragStart(event);
      priority = 100;
      if (pile is TableauPile) {
        attachedCards.clear();
        final extraCards = (pile! as TableauPile).cardsOnTop(this);
        for (final card in extraCards) {
          card.priority = attachedCards.length + 101;
          attachedCards.add(card);
        }//end of for
      }//end of if
    }//end of if
  }//end of onDragStart;

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!isDragged) {
      return;
    }//end of if
    final delta = event.localDelta;
    position.add(delta);
    attachedCards.forEach((card) => card.position.add(delta));
  }//end of onDragUpdate

  @override
  void onDragEnd(DragEndEvent event) {
    if (!isDragged) {
      return;
    }//end of if
    super.onDragEnd(event);
    final dropPiles = parent!
        .componentsAtPoint(position + size / 2)
        .whereType<Pile>()
        .toList();
    if (dropPiles.isNotEmpty) {
      if (dropPiles.first.canAcceptCard(this)) {
        pile!.removeCard(this);
        dropPiles.first.acquireCard(this);
        if (attachedCards.isNotEmpty) {
          attachedCards.forEach((card) => dropPiles.first.acquireCard(card));
          attachedCards.clear();
        }//end of if
        return;
      }//end of if
    }//end of if

    pile!.returnCard(this);

    if (attachedCards.isNotEmpty) {
      attachedCards.forEach((card) => pile!.returnCard(card));
      attachedCards.clear();
    }//end of if
  }//end of onDragEnd

  //for debugging
  @override
  String toString() => rank.label + suit.label; //e.g., "Queen of Hearts or 10 of diamonds"
}//end of Card class