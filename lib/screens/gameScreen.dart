import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/image.dart';
import 'dart:async';

import '../components/custom_box.dart';
import '../models/custom_card.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<HaribotCard> allCards = [
    HaribotCard(
      'chandler',
      Image.asset(
        'assets/chandler1.png',
        fit: BoxFit.cover,
      ),
      1,
      false,
    ),
    HaribotCard(
      'chandler',
      Image.asset(
        'assets/chandler2.jpg',
        fit: BoxFit.cover,
      ),
      1,
      false,
    ),
    HaribotCard(
      'joey',
      Image.asset(
        'assets/joey1.jpg',
        fit: BoxFit.cover,
      ),
      2,
      false,
    ),
    HaribotCard(
      'joey',
      Image.asset(
        'assets/joey2.png',
        fit: BoxFit.cover,
      ),
      2,
      false,
    ),
    HaribotCard(
      'ross',
      Image.asset(
        'assets/ross1.jpg',
        fit: BoxFit.cover,
      ),
      3,
      false,
    ),
    HaribotCard(
      'ross',
      Image.asset(
        'assets/ross2.jpg',
        fit: BoxFit.cover,
      ),
      3,
      false,
    ),
    HaribotCard(
      'monica',
      Image.asset(
        'assets/monica1.png',
        fit: BoxFit.cover,
      ),
      4,
      false,
    ),
    HaribotCard(
      'monica',
      Image.asset(
        'assets/monica2.jpg',
        fit: BoxFit.cover,
      ),
      4,
      false,
    ),
    HaribotCard(
      'rachel',
      Image.asset(
        'assets/rachel1.jpg',
        fit: BoxFit.cover,
      ),
      5,
      false,
    ),
    HaribotCard(
      'rachel',
      Image.asset(
        'assets/rachel2.jpg',
        fit: BoxFit.cover,
      ),
      5,
      false,
    ),
    HaribotCard(
      'phoebe',
      Image.asset(
        'assets/phoebe1.png',
        fit: BoxFit.cover,
      ),
      6,
      false,
    ),
    HaribotCard(
      'phoebe',
      Image.asset(
        'assets/phoebe2.jpg',
        fit: BoxFit.cover,
      ),
      6,
      false,
    ),
  ];

  void toggleActive(int index) {
    setState(() {
      if (!allCards[index].done && !allCards[index].active) {
        allCards[index].active = !allCards[index].active;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    allCards.shuffle();
    startTimer();
    updateTimeString();
  }

  int moves = 0;

  bool timeOut = false;

  late Timer timer;
  late int seconds = 30;

  late int _remainingMinute;
  late int _remainingSeconds;

  void resetTimer() {
    setState(() {
      seconds = 30;
      timeOut = false;
      startTimer();
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          stopTimer();
        }
        updateTimeString();
      });
    });
  }

  void stopTimer() {
    timer.cancel();
    setState(() {
      timeOut = true;
    });
  }

  void updateTimeString() {
    _remainingMinute = seconds ~/ 60;
    _remainingSeconds = seconds - 60 * _remainingMinute;
  }

  @override
  Widget build(BuildContext context) {
    List<HaribotCard> activeCards =
        allCards.where((activity) => activity.active).toList();

    void clearArray() {
      activeCards[0].active = false;
      activeCards[1].active = false;
      activeCards.clear();
    }

    void checkMatch() async {
      if (activeCards[0].value == activeCards[1].value) {
        var matchedCards =
            allCards.where((card) => card.name == activeCards[0].name);
        for (var card in matchedCards) {
          card.done = true;
        }
        print('match');
      } else {
        print('not match');
      }

      Timer(Duration(milliseconds: 200), () {
        setState(() {
          print('active');
          clearArray();
        });
      });
      return;
    }

    if (activeCards.length == 2) {
      checkMatch();
      moves++;
    }

    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.center,
        children: [
          Image.asset(
            'assets/bg.jpg',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          buildGameScreen(),
          Visibility(
            visible: (allCards.every((card) => card.done) || timeOut),
            child: Stack(
              fit: StackFit.expand,
              alignment: AlignmentDirectional.center,
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      timeOut ? 'assets/notready.png' : 'assets/goodjob.png',
                      height: 200,
                      width: 200,
                    ),
                    Text(
                      timeOut ? 'Time Out' : 'You Won',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Moves: $moves',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          allCards.shuffle();
                          allCards.forEach((card) {
                            card.active = false;
                            card.done = false;
                          });
                          moves = 0;
                          resetTimer();
                        });
                      },
                      child: Text('Play Again'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Scaffold buildGameScreen() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Time: ${_remainingMinute.toString().padLeft(2, '0')}:${_remainingSeconds.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Moves: $moves',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 90,
              child: Image.asset(
                'assets/logo.png',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  allCards.length, // Replace imageList with your list of images
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Change the number of columns here
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Custom_Box(
                  photo: allCards[index].image,
                  visible: allCards[index].active || allCards[index].done,
                  setActive: (p0) => toggleActive(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
