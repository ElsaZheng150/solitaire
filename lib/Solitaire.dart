import 'dart:ui';
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
  static final cardRRect = RRect.fromRectAndRadius(
    const Rect.fromLTWH(0, 0, cardWidth, cardHeight),
    const Radius.circular(cardRadius),
  );

  @override
  /*
        Special handler called when game instance is attached to the Flutter widget tree for the first time
        Like a delayed asynchronous constructor
        Loads sprite images into the game
   */
  Future<void> onLoad() async{
    await Flame.images.load('klondike-sprites.png'); //wait for image/resource to be loaded before starting game
    //create components to set size and positions in the world calculated by arithmetic
    final stock = StockPile(position: Vector2(cardGap, cardGap)); //creates pile of cards you have
    final waste = WastePile(position: Vector2(cardWidth + 2 * cardGap, cardGap));
    final foundations = List.generate(
      4,
          (i) => FoundationPile(
        i,
        position: Vector2((i + 3) * (cardWidth + cardGap) + cardGap, cardGap),
      ),
    );
    final piles = List.generate(
      7,
          (i) => TableauPile(
        position: Vector2(
          cardGap + i * (cardWidth + cardGap),
          cardHeight + 2 * cardGap,
        ),
      ),
    );

    //add components into world (root of the game board)
    world.add(stock);
    world.add(waste);
    world.addAll(foundations);
    world.addAll(piles);

    //add camera view
    camera.viewfinder.visibleGameSize = Vector2(cardWidth*7 + cardGap*8, 4*cardHeight+3 * cardGap,);
    camera.viewfinder.position = Vector2(cardWidth*3.5 + cardGap*4, 0);
    camera.viewfinder.anchor = Anchor.topCenter;

    //creating a deck
    final cards = [
      for (var rank = 1; rank <= 13; rank++)
        for (var suit = 0; suit < 4; suit++) Card(rank, suit),
    ];
    cards.shuffle();
    world.addAll(cards);

    var cardToDeal = cards.length - 1;
    for (var i = 0; i < 7; i++) {
      for (var j = i; j < 7; j++) {
        piles[j].acquireCard(cards[cardToDeal--]);
      }//end of inner for loop
      piles[i].flipTopCard();
    }//end of outer for loop
    for(int n = 0; n <= cardToDeal; n++) {
      stock.acquireCard(cards[n]);
    }//end of for loop
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
}//end of solitaireSprite

