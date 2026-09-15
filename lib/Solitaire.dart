import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';

import 'components/foundation.dart';
import 'components/pile.dart';
import 'components/stock.dart';
import 'components/waste.dart';

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
    final stock = Stock() //creates pile of cards you have
      ..size = cardSize
      ..position = Vector2(cardGap, cardGap);
    final waste = Waste() //waste pile
      ..size = cardSize
      ..position = Vector2(cardWidth + 2 * cardGap, cardGap);
    final foundations = List.generate( //setting up 4 piles you have to sort the cards into
      4,
          (i) => Foundation()
        ..size = cardSize
        ..position =
        Vector2((i + 3) * (cardWidth + cardGap) + cardGap, cardGap),
    );
    final piles = List.generate( //the 7 piles you place cards in Solitaire
      7,
          (i) => Pile()
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