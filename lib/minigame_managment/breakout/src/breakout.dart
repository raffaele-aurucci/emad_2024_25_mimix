import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../../utils/view/app_palette.dart';
import 'components/components.dart';
import 'config.dart';

enum PlayState { welcome, playing, gameOver, won, isPaused}


class Breakout extends FlameGame with HasCollisionDetection {

  // external function to handle game over and win (for UI)
  final Function handleGameOver;
  final Function handleWon;
  bool isBallBig = false;
  bool isBatBig = false;

  Breakout({
    required this.handleGameOver,
    required this.handleWon,
  }) : super(
    camera: CameraComponent.withFixedResolution(
      width: gameWidth,
      height: gameHeight,
    ),
  ) {
    _playState = PlayState.welcome;
  }

  final rand = math.Random();
  double get width => size.x;
  double get height => size.y;

  // Score of game accessible to external.
  final ValueNotifier<int> score = ValueNotifier(0);

  // State of game accessible to external.
  late PlayState _playState;

  PlayState get playState => _playState;

  set playState(PlayState state) {
    _playState = state;
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(PlayArea());

    playState = PlayState.welcome;

    // Add objects to scene but not start the game.

    world.add(Bat(
        size: Vector2(batWidth, batHeight),
        cornerRadius: const Radius.circular(batRadius / 2),
        position: Vector2(width / 2, height * 0.95),
        color: clearBlue));

    world.addAll([
      for (var i = 0; i < 10; i++)
        for (var j = 0; j < 5; j++)
          Brick(
            position: Vector2(
              (i + 0.5) * brickWidth + (i + 1) * brickGutter,
              (j + 2.0) * brickHeight + j * brickGutter,
            ),
            color: () {
              if ((i == 1 && j == 1) ||
                  (i == 8 && j == 1) ||
                  (i == 3 && j == 3) ||
                  (i == 6 && j == 3)) {
                return bigBallBrickColor;
              } else if ((i == 3 && j == 1) ||
                  (i == 1 && j == 3) ||
                  (i == 6 && j == 1) ||
                  (i == 8 && j == 3)) {
                return bigBatBrickColor;
              } else {
                return clearBlue;
              }
            }(),
          ),
    ]);
  }

  TextComponent? _countdownText;
  int countdownValue = 3;
  late Ball _ball;
  double countdownTimer = 1.0;
  bool isCountdownActive = false;

  void startGame() {
    _ball = Ball(radius: ballRadius, position: size / 2, velocity: Vector2(350, 350));

    // Preview scene components.
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Brick>());

    if (_countdownText != null && _countdownText!.isMounted) {
      _countdownText!.removeFromParent();
    }

    // New scene.
    world.add(
      Bat(
        size: Vector2(batWidth, batHeight),
        cornerRadius: const Radius.circular(batRadius / 2),
        position: Vector2(width / 2, height * 0.95),
        color: clearBlue,
      ),
    );

    world.addAll([
      for (var i = 0; i < 10; i++)
        for (var j = 0; j < 5; j++)
          Brick(
            position: Vector2(
              (i + 0.5) * brickWidth + (i + 1) * brickGutter,
              (j + 2.0) * brickHeight + j * brickGutter,
            ),
            color: () {
              if ((i == 1 && j == 1) ||
                  (i == 8 && j == 1) ||
                  (i == 3 && j == 3) ||
                  (i == 6 && j == 3)) {
                return bigBallBrickColor;
              } else if ((i == 3 && j == 1) ||
                  (i == 1 && j == 3) ||
                  (i == 6 && j == 1) ||
                  (i == 8 && j == 3)) {
                return bigBatBrickColor;
              } else {
                return clearBlue;
              }
            }(),
          ),
    ]);

    _countdownText = TextComponent(
      text: countdownValue.toString(),
      position: Vector2(width / 2 - 35, height * 0.45),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: PaletteColor.darkBlue,
          fontSize: 150,
          fontWeight: FontWeight.bold,
          fontFamily: 'Raleway',
        ),
      ),
    );

    world.add(_countdownText!);

    // Set countdown.
    isCountdownActive = true;
    countdownTimer = 1.0;
  }

  void updateCountdown(double dt) {
    if (isCountdownActive) {
      countdownTimer -= dt;   // Time passed updated.
      if (countdownTimer <= 0) {
        countdownValue--;     // Update countdown value.
        countdownTimer = 1.0; // Reset timer to next second.

        if (countdownValue > 0) {
          _countdownText!.text = countdownValue.toString();
        } else {
          _countdownText!.removeFromParent();
          isCountdownActive = false;

          playState = PlayState.playing;
          score.value = 0;

          world.add(_ball);
        }
      }
    }
  }


  @override
  void update(double dt) {
    super.update(dt);
    updateCountdown(dt);
  }

  @override
  Color backgroundColor() => const Color(0xffffffff);

  void moveBatLeft() {
    if (playState == PlayState.playing) {
      world.children.query<Bat>().first.moveBy(-batStep);
    }
  }

  void moveBatRight() {
    if (playState == PlayState.playing) {
      world.children.query<Bat>().first.moveBy(batStep);
    }
  }

  void resetGame(){
    if (playState == PlayState.isPaused || playState == PlayState.gameOver || playState == PlayState.won) {

      if (_ball.isMounted){
        _ball.removeFromParent();
      }

      world.removeAll(world.children.query<Bat>());
      world.removeAll(world.children.query<Brick>());

      if(_countdownText != null && _countdownText!.isMounted) {
        _countdownText!.removeFromParent();
      }

      // reset scores and state
      score.value = 0;
      countdownValue = 3;
      resumeEngine();
      startGame();
    }
  }

}