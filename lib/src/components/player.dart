import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../flamebreakout.dart';

class Player extends SpriteComponent
    with HasGameReference<FlameBreakout> {
  Player({
    required super.position,
    required super.size,
  }) : super(
    anchor: Anchor.center,
    angle: -25,
  );

  //late final SpriteComponent player;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('breakout-girl.png');
  }

  void moveBy(double dx) {
    add(MoveToEffect(
      Vector2((position.x + dx).clamp(0, game.width), position.y),
      EffectController(duration: 0.1),
    ));
  }
}