import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/animation.dart';
import 'package:solitaire/Solitaire.dart';
import '../rank.dart';
import '../suit.dart';
import 'FoundationPile.dart';
import 'Pile.dart';
import 'StockPile.dart';
import 'TableauPile.dart';

class Card extends PositionComponent with DragCallbacks, TapCallbacks, HasWorldReference<Solitaire>{
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

  //card details
  final Rank rank;
  final Suit suit;
  Pile? pile;
  // A Base Card is rendered in outline only and is NOT playable. It can be
  // added to the base of a Pile (e.g. the Stock Pile) to allow it to handle
  // taps and short drags (on an empty Pile) with the same behavior and
  // tolerances as for regular cards (see KlondikeGame.dragTolerance) and using
  // the same event-handling code, but with different handleTapUp() methods.
  final bool isBaseCard;
  bool _faceUp = false;
  bool _isAnimatedFlip = false;
  bool _isFaceUpView = false;
  bool _isDragging = false;
  Vector2 _whereCardStarted = Vector2(0,0); //initial position of the card
  final List<Card> attachedCards = []; //cards the move in a stack
  //public accessors and mutators for _faceUp
  bool get isFaceUp => _faceUp;
  bool get isFaceDown => !_faceUp;

  //for debugging
  @override
  String toString() => rank.label + suit.label; //e.g., "Queen of Hearts or 10 of diamonds"

  //creates a board the game rests on
  @override
  void render(Canvas canvas) {
    if (isBaseCard) {
      _renderBaseCard(canvas);
      return;
    }//end of if
    if (_isFaceUpView) {
      _renderFront(canvas);
    }//end of if
    else {
      _renderBack(canvas);
    }//end of else
  }//end of render

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

  //renders the back of the card with the design
  void _renderBack(Canvas canvas) {
    canvas.drawRRect(cardRRect, backBackgroundPaint);
    canvas.drawRRect(cardRRect, backBorderPaint1);
    canvas.drawRRect(backRRectInner, backBorderPaint2);
    flameSprite.render(canvas, position: size / 2, anchor: Anchor.center);
  }//end of _renderBack

  void _renderBaseCard(Canvas canvas) {
    canvas.drawRRect(cardRRect, backBorderPaint1);
  }//end of _renderBaseCard

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

  //don't move card in certain circumstances
  @override
  void onTapCancel(TapCancelEvent event) {
    if (pile is StockPile) {
      _isDragging = false;
      handleTapUp();
    }//end of if
  }//end of onTapCancel

  //methods to allow user to drag and drop the cards
  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if(pile is StockPile){
      _isDragging = false;
      return;
    }//end of if

    //Clone the position or the initial position changes as the card moves
    _whereCardStarted = position.clone();
    attachedCards.clear();
    if(pile?.canMoveCard(this, MoveMethod.drag) ?? false){
      _isDragging = true;
      priority = 100;
      if(pile is TableauPile){
        final extraCards = (pile! as TableauPile).cardsOnTop(this);
        for(final card in extraCards){
          card.priority = attachedCards.length + 101;
          attachedCards.add(card);
        }//end of for loop
      }//end of if
    }//end of if
  }//end of onDragStart;

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!_isDragging) {
      return;
    }//end of if
    final delta = event.localDelta;
    position.add(delta);
    attachedCards.forEach((card) => card.position.add(delta));
  }//end of onDragUpdate

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (!_isDragging) {
      return;
    }//end of else
    _isDragging = false;

    //If short drag, return card to Pile and treat it as having been tapped.
    final shortDrag =
        (position - _whereCardStarted).length < Solitaire.dragTolerance;
    if (shortDrag && attachedCards.isEmpty) {
      doMove(
        _whereCardStarted,
        onComplete: () {
          pile!.returnCard(this);
          // Card moves to its Foundation Pile next, if valid, or it stays put.
          handleTapUp();
        },//end of onComplete
      );
      return;
    }//end of if

    //Find out what is under the center-point of this card when it is dropped.
    final dropPiles = parent!
        .componentsAtPoint(position + size / 2)
        .whereType<Pile>()
        .toList();
    if (dropPiles.isNotEmpty) {
      if (dropPiles.first.canAcceptCard(this)) {
        // Found a Pile: move card(s) the rest of the way onto it.
        pile!.removeCard(this, MoveMethod.drag);
        if (dropPiles.first is TableauPile) {
          // Get TableauPile to handle positions, priorities and moves of cards.
          (dropPiles.first as TableauPile).dropCards(this, attachedCards);
          attachedCards.clear();
        }//end of if
        else {
          // Drop a single card onto a FoundationPile.
          final dropPosition = (dropPiles.first as FoundationPile).position;
          doMove(
            dropPosition,
            onComplete: () {
              dropPiles.first.acquireCard(this);
            },//end of onComplete
          );
        }//end of else
        return;
      }//end of if
    }//end of onDragEnd

    // Invalid drop (middle of nowhere, invalid pile or invalid card for pile).
    doMove(
      _whereCardStarted,
      onComplete: () {
        pile!.returnCard(this);
      },//end of onComplete
    );
    if (attachedCards.isNotEmpty) {
      attachedCards.forEach((card) {
        final offset = card.position - position;
        card.doMove(
          _whereCardStarted + offset,
          onComplete: () {
            pile!.returnCard(card);
          },//end of onComplete
        );
      });//end of forEach loop
      attachedCards.clear();
    }//end of if
  }//end of onDragEnd

  /*
    * for moving the card
    * requires location to move to
  */
  void doMove(
      Vector2 to, {
        double speed = 10.0,
        double start = 0.0,
        Curve curve = Curves.easeOutQuad,
        VoidCallback? onComplete,
      }) {//end of Vector2
    assert(speed > 0.0, 'Speed must be > 0 widths per second');
    final dt = (to - position).length / (speed * size.x);
    assert(dt > 0.0, 'Distance to move must be > 0');
    priority = 100;
    add(
      MoveToEffect(
        to,
        EffectController(duration: dt, startDelay: start, curve: curve),
        onComplete: () {
          onComplete?.call();
        },//end of EffectController
      ),
    );
  }//end of doMove

  void doMoveAndFlip(
      Vector2 to, {
        double speed = 10.0,
        double start = 0.0,
        Curve curve = Curves.easeOutQuad,
        VoidCallback? whenDone,
      }) {//end of Vector2
    assert(speed > 0.0, 'Speed must be > 0 widths per second');
    final dt = (to - position).length / (speed * size.x);
    assert(dt > 0, 'Distance to move must be > 0');
    priority = 100;
    add(
      MoveToEffect(
        to,
        EffectController(duration: dt, startDelay: start, curve: curve),
        onComplete: () {
          turnFaceUp(
            onComplete: whenDone,
          );
        },//end of onComplete
      ),
    );
  }//end of doMoveAndFlip

  void turnFaceUp({
    double time = 0.3,
    double start = 0.0,
    VoidCallback? onComplete,
    }) {//end of onComplete
    assert(!_isFaceUpView, 'Card must be face-down before turning face-up.');
    assert(time > 0.0, 'Time to turn card over must be > 0');
    _isAnimatedFlip = true;
    anchor = Anchor.topCenter;
    position += Vector2(width / 2, 0);
    priority = 100;
    add(
      ScaleEffect.to(
        Vector2(scale.x / 100, scale.y),
        EffectController(
          startDelay: start,
          curve: Curves.easeOutSine,
          duration: time / 2,
          onMax: () {
            _isFaceUpView = true;
          },//end of onMax
          reverseDuration: time / 2,
          onMin: () {
            _isAnimatedFlip = false;
            _faceUp = true;
            anchor = Anchor.topLeft;
            position -= Vector2(width / 2, 0);
          },//end of onMin
        ),
        onComplete: () {
          onComplete?.call();
        },//end of onComplete
      ),
    );
  }//end of turnFaceUp

  //flip the card
  void flip() {
    if (_isAnimatedFlip) {
      // Let the animation determine the FaceUp/FaceDown state.
      _faceUp = _isFaceUpView;
    }//end of if
    else {
      // No animation: flip and render the card immediately.
      _faceUp = !_faceUp;
      _isFaceUpView = _faceUp;
    }//end of else
  }//end of flip

  //Tap a face-up card to make it auto-move and go out (if acceptable), but
  //if it is face-down and on the Stock Pile, pass the event to that pile.
  @override
  void onTapUp(TapUpEvent event) {
    handleTapUp();
  }//end of onTapUp

  void handleTapUp() {
    // Can be called by onTapUp or after a very short (failed) drag-and-drop.
    // We need to be more user-friendly towards taps that include a short drag.
    if (pile?.canMoveCard(this, MoveMethod.tap) ?? false) {
      final suitIndex = suit.value;
      if (world.foundations[suitIndex].canAcceptCard(this)) {
        pile!.removeCard(this, MoveMethod.tap);
        doMove(
          world.foundations[suitIndex].position,
          onComplete: () {
            world.foundations[suitIndex].acquireCard(this);
          },//end of onComplete
        );
      }//end of if
    }//end of if
    else if (pile is StockPile) {
      world.stock.handleTapUp(this);
    }//end of else if
  }//end of handleTapUp
}//end of Card class

//helper class
class CardMoveEffect extends MoveToEffect {
  CardMoveEffect(
      super.destination,
      super.controller, {
        super.onComplete,
        this.transitPriority = 100,
      }); //end of constructor

  final int transitPriority;

  @override
  void onStart() {
    super.onStart(); // Flame connects MoveToEffect to EffectController.
    parent?.priority = transitPriority;
  }//end of onStart
}//end of CardMoveEffect class