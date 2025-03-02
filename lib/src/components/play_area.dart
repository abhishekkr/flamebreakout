import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../flamebreakout.dart';

class PlayArea extends RectangleComponent with HasGameReference<FlameBreakout> {
  PlayArea()
      : super(
    paint: Paint()..color = const Color(0xfff6e5a1),
    children: [RectangleHitbox()],
  );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);
  }
}