import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_spinner/utils/emojis.utils.dart';
import 'package:flutter_spinner/utils/winner.model.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_spinner/widgets/question_card.dart';

class GamePage extends StatefulWidget {
  final int numberOfPeople;
  final bool isTabuEnabled;

  const GamePage(this.numberOfPeople, this.isTabuEnabled);

  @override
  _GameState createState() => _GameState();
}

class PlayerSlice {
  int id;
  Color color;
  SvgPicture emoji;

  PlayerSlice(int id, Color color, SvgPicture emoji) {
    this.id = id;
    this.color = color;
    this.emoji = emoji;
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
  int selectedPlayerIndex = 0;
  int nextDurationInS = 4;

  Winner winner = new Winner();

  @override
  Widget build(BuildContext context) {
    final players = PlayerSlice.generate(widget.numberOfPeople);

    final wheelIndicator = FortuneIndicator(
      alignment: Alignment.topCenter,
      child: Transform.translate(
        child: new TriangleIndicator(color: const Color(0xff2f2f2f)),
        offset: const Offset(0, -11),
      ),
    );

    spinWheel() {
      setState(() {
        nextDurationInS = Random().nextInt(4) + 1;
        selectedPlayerIndex = Random().nextInt(players.length);

        winner.index = selectedPlayerIndex;
        winner.color = players[selectedPlayerIndex].color;
        winner.emoji = players[selectedPlayerIndex].emoji;
      });
    }

    // todo temporary dialog, remove this when implementing question popup
    showQuestionCard(BuildContext context) {
      AlertDialog alert = AlertDialog(
        content: Column(
          children: [
            winner.emoji,
            Text("Index won: ${winner.index} ${winner.color}"),
          ],
        ),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    openQuestion() {
      // todo temporary dialog, remove this when implementing question popup
      showQuestionCard(context);
    }

    return Scaffold(
      body: GestureDetector(
        child: Column(
          children: [
            Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: PhysicalShape(
                      color: Colors.transparent,
                      shadowColor: Colors.black,
                      elevation: 8,
                      clipper: ShapeBorderClipper(shape: CircleBorder()),
                      child: FortuneWheel(
                        physics: CircularPanPhysics(
                          duration: Duration(seconds: nextDurationInS),
                          curve: Curves.ease,
                        ),
                        onFling: spinWheel,
                        onAnimationEnd: openQuestion,
                        animateFirst: false,
                        selected: selectedPlayerIndex,
                        indicators: <FortuneIndicator>[wheelIndicator],
                        items: [
                          for (var player in players)
                            FortuneItem(
                              child: Emojis.getTransformedEmoji(player.emoji),
                              style: FortuneItemStyle(
                                color: player
                                    .color, // <-- custom circle slice fill color
                                borderColor: Colors
                                    .black38, // <-- custom circle slice stroke color
                                borderWidth:
                                    1, // <-- custom circle slice stroke width
                              ),
                            ),
                        ],
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}
