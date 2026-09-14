import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'Solitaire.dart';

void main() {
  final game = Solitaire();
  runApp(GameWidget(game: game));
}//end of main