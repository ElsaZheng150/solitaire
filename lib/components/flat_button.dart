import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

class FlatButton extends ButtonComponent {
  FlatButton(
      String text, {
        super.size,
        super.onReleased,
        super.position,
      }) : super(
    //how the button will look
    button: ButtonBackground(const Color(0xffece8a3)),
    buttonDown: ButtonBackground(Colors.red),
    children: [
      TextComponent(
        text: text,
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: 0.5 * size!.y,
            fontWeight: FontWeight.bold,
            color: const Color(0xffdbaf58),
          ),
        ),
        position: size / 2.0,
        anchor: Anchor.center,
      ),
    ],
    anchor: Anchor.center,
  );
}//end of FlatButton class

class ButtonBackground extends PositionComponent with HasAncestor<FlatButton> {
  final _paint = Paint()..style = PaintingStyle.stroke;

  late double cornerRadius;

  //more on how the button will look
  ButtonBackground(Color color) {
    _paint.color = color;
  }//end of ButtonBackground

  @override
  void onMount() {
    super.onMount();
    size = ancestor.size;
    cornerRadius = 0.3 * size.y;
    _paint.strokeWidth = 0.05 * size.y;
  }//end of onMount

  late final _background = RRect.fromRectAndRadius(
    size.toRect(),
    Radius.circular(cornerRadius),
  );

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_background, _paint);
  }//end of render
}//end of ButtonBackground