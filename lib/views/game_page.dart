import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_svg/svg.dart';

class GamePage extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class PlayerSlice {
  int id;
  Color color;
  SvgPicture emoji;
  Transform transformedEmoji;

  PlayerSlice(int id, Color color, SvgPicture emoji) {
    this.id = id;
    this.color = color;
    this.emoji = emoji;

    this.transformedEmoji = Transform.translate(
      offset: const Offset(60.0, 0.0),
      child: Transform.rotate(
        child: Transform.scale(child: this.emoji, scale: 0.8),
        angle: -pi / 2,
      ),
    );
  }

  static getEmojiSvg(int index) {
    // todo shuffle

    final emojis = [
      "assets/images/emoji/mouse.svg",
      "assets/images/emoji/cow.svg",
      "assets/images/emoji/elephant.svg",
      "assets/images/emoji/turtle.svg",
      "assets/images/emoji/chicken.svg",
      "assets/images/emoji/pinguin.svg",
      "assets/images/emoji/rabbit.svg",
      "assets/images/emoji/cat.svg",
      "assets/images/emoji/monkey.svg",
      "assets/images/emoji/dog.svg",
      "assets/images/emoji/pig.svg",
      "assets/images/emoji/unicorn.svg",
      "assets/images/emoji/duck.svg",
      "assets/images/emoji/shark.svg",
      "assets/images/emoji/dinosaur.svg",
    ];

    return SvgPicture.asset(emojis[index % emojis.length]);
  }

  static List<PlayerSlice> generate(int howMany) {
    List colors = new List.generate(howMany,
        (i) => HSLColor.fromAHSL(1, 360 * i / howMany, 0.7, 0.5).toColor());

    return new List.generate(
        howMany, (i) => new PlayerSlice(i, colors[i], getEmojiSvg(i)));
  }
}

class _GameState extends State<GamePage> {
  int selected = 0;
  int nextDurationInS = 4;

  int tempPlayerCount = 15;

  @override
  Widget build(BuildContext context) {
    final items = PlayerSlice.generate(tempPlayerCount);

    return Scaffold(
      body: GestureDetector(
        child: Column(
          children: [
            Expanded(
              child: FortuneWheel(
                physics: CircularPanPhysics(
                  duration: Duration(seconds: nextDurationInS),
                  curve: Curves.ease,
                ),
                onFling: () {
                  setState(() {
                    nextDurationInS = Random().nextInt(4) + 1;
                    selected = Random().nextInt(items.length);
                  });
                },
                selected: selected,
                items: [
                  for (var it in items)
                    FortuneItem(
                      // child: Text(it.text),
                      child: it.transformedEmoji,
                      style: FortuneItemStyle(
                        color: it.color, // <-- custom circle slice fill color
                        borderColor: Colors
                            .black38, // <-- custom circle slice stroke color
                        borderWidth: 1, // <-- custom circle slice stroke width
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
