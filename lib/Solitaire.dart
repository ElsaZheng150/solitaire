import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';

import 'components/card.dart';
import 'components/FoundationPile.dart';
import 'components/TableauPile.dart';
import 'components/StockPile.dart';
import 'components/WastePile.dart';

class Solitaire extends FlameGame{
  //card dimensions
  static const double cardWidth = 1000.0;
  static const double cardHeight= 1400.0;
  static const double cardGap = 175.0;
  static const double cardRadius = 100.0;
  static final Vector2 cardSize = Vector2(cardWidth, cardHeight);

  @override
  /*
        Special handler called when game instance is attached to the Flutter widget tree for the first time
        Like a delayed asynchronous constructor
        Loads sprite images into the game
    */
  Future<void> onLoad() async{
    await Flame.images.load('klondike-sprites.png'); //wait for image/resource to be loaded before starting game
    //create components to set size and positions in the world calculated by arithmetic
    final stock = StockPile() //creates pile of cards you have
      ..size = cardSize
      ..position = Vector2(cardGap, cardGap);
    final waste = WastePile() //waste pile
      ..size = cardSize
      ..position = Vector2(cardWidth + 2 * cardGap, cardGap);
    final foundations = List.generate( //setting up 4 piles you have to sort the cards into
      4,
          (i) => FoundationPile()
        ..size = cardSize
        ..position =
        Vector2((i + 3) * (cardWidth + cardGap) + cardGap, cardGap),
    );
    final piles = List.generate( //the 7 piles you place cards in Solitaire
      7,
          (i) => TableauPile()
        ..size = cardSize
        ..position = Vector2(
          cardGap + i * (cardWidth + cardGap),
          cardHeight + 2 * cardGap,
        ),
    );

    //add components into world (root of the game board)
    world.add(stock);
    world.add(waste);
    world.addAll(foundations);
    world.addAll(piles);

    //add camera view
    camera.viewfinder.visibleGameSize = Vector2(cardWidth*7 + cardGap*8, cardHeight+2 * cardGap);
    camera.viewfinder.position = Vector2(cardWidth*3.5 + cardGap*4, 0);
    camera.viewfinder.anchor = Anchor.topCenter;

    //lays down 28 random cards facing up
    final random = Random();
    for (var i = 0; i < 7; i++) {
      for (var j = 0; j < 4; j++) {
        final card = Card(random.nextInt(13) + 1, random.nextInt(4))
          ..position = Vector2(100 + i * 1150, 100 + j * 1500)
          ..addToParent(world);
        if (random.nextDouble() < 0.9) { // flip face up with 90% probability
          card.flip();
        }
      }
    }
  }//end of onLoad
}//end of Solitaire

/*
        Extracts sprites from the sprite sheet
  */

Sprite solitaireSprite(double x, double y, double width, double height){
  return Sprite(
    Flame.images.fromCache('klondike-sprites.png'),
    srcPosition: Vector2(x,y),
    srcSize: Vector2(width, height),
  );
}