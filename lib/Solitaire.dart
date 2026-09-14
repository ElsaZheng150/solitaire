import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';

class Solitaire extends FlameGame{
  @override
  /*
        Special handler called when game instance is attached to the Flutter widget tree for the first time
        Like a delayed asynchronous constructor
        Loads sprite images into the game
    */
  Future<void> onLoad() async{
    await Flame.images.load('klondike-sprites.png'); //wait for image/resource to be loaded before starting game
  }//end of onLoad

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
}//end of Solitaire