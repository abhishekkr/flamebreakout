import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/components.dart';
import 'config.dart';

enum PlayState { welcome, playing, gameOver, won }

class FlameBreakout extends FlameGame
    with HasCollisionDetection, KeyboardEvents, TapDetector, HorizontalDragDetector {
  FlameBreakout()
      : super(
    camera: CameraComponent.withFixedResolution(
      width: gameWidth,
      height: gameHeight,
    ),
  );

  AudioManager adoMgr = AudioManager();
  final ValueNotifier<int> score = ValueNotifier(0);
  final rand = math.Random();
  double get width => size.x;
  double get height => size.y;

  late PlayState _playState;                                    // Add from here...
  PlayState get playState => _playState;
  set playState(PlayState playState) {
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
      case PlayState.gameOver:
      case PlayState.won:
        overlays.add(playState.name);
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.remove(PlayState.won.name);
    }
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    await add(adoMgr);
    await adoMgr.initialize();

    world.add(PlayArea());
    playState = PlayState.welcome;                              // Add from here...
  }

  void startGame() {
    if (playState == PlayState.playing) return;

    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Brick>());
    world.removeAll(world.children.query<Player>());

    adoMgr.playBgMusic();
    adoMgr.play('abk-clank.mp3');
    playState = PlayState.playing;
    score.value = 0;

    world.add(Ball(
        difficultyModifier: difficultyModifier,
        radius: ballRadius,
        position: size / 2,
        velocity: Vector2((rand.nextDouble() - 0.5) * width, height * 0.2)
            .normalized()
          ..scale(height / 4)));

    final batX = width / 2;
    final batY = height * 0.85;

    world.add(Bat(
        size: Vector2(batWidth, batHeight),
        cornerRadius: const Radius.circular(ballRadius / 2),
        position: Vector2(batX, batY)));

    world.add(Player(
        size: Vector2(playerWidth, playerHeight),
        position: Vector2(batX+(batWidth/3), batY + 115)));

    world.addAll([
      for (var i = 0; i < brickColors.length; i++)
        for (var j = 1; j <= 5; j++)
          Brick(
            position: Vector2(
              (i + 0.5) * brickWidth + (i + 1) * brickGutter,
              (j + 2.0) * brickHeight + j * brickGutter,
            ),
            color: brickColors[i],
          ),
    ]);
  }

  @override
  void onTap() {
    super.onTap();
    startGame();
  }

  @override
  bool onTapDown(TapDownInfo info) {
    var bat = world.children.query<Bat>().first;
    if (info.eventPosition.widget[0] < bat.position.x) {
      bat.moveBy(-batStep);
      world.children.query<Player>().first.moveBy(-batStep);
    } else {
      bat.moveBy(batStep);
      world.children.query<Player>().first.moveBy(batStep);
    }
    return true;
  }

  @override
  void onHorizontalDragStart(DragStartInfo info) {
    var bat = world.children.query<Bat>().first;
    if (info.eventPosition.widget[0] < bat.position.x) {
      bat.moveBy(-batStep);
      world.children.query<Player>().first.moveBy(-batStep);
    } else {
      bat.moveBy(batStep);
      world.children.query<Player>().first.moveBy(batStep);
    }
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        world.children.query<Bat>().first.moveBy(-batStep);
        world.children.query<Player>().first.moveBy(-batStep);
      case LogicalKeyboardKey.arrowRight:
        world.children.query<Bat>().first.moveBy(batStep);
        world.children.query<Player>().first.moveBy(batStep);
      case LogicalKeyboardKey.space:
      case LogicalKeyboardKey.enter:
        startGame();
    }
    return KeyEventResult.handled;
  }

  @override
  Color backgroundColor() => const Color(0xffffecbb);
}
