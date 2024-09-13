// Barrett Koster
// Your Name Here (replace mine, this is just demos
// of stuff anyone can use).

import 'package:flutter/material.dart';
import 'dart:math'; // For random number generation

void main() {
  runApp(Yahtzee());
}

class Yahtzee extends StatelessWidget {
  Yahtzee({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Yahtzee",
      home: YahtzeeHome(),
    );
  }
}

class YahtzeeHome extends StatefulWidget {
  @override
  State<YahtzeeHome> createState() => YahtzeeHomeState();
}

class YahtzeeHomeState extends State<YahtzeeHome> {
  // List of dice numbers, initially set to 1 for all dice
  List<int> diceValues = List.generate(5, (index) => 1);
  // List to track whether each dice is held
  List<bool> isHeld = List.generate(5, (index) => false);

  // Function to randomize all dice values
  void rollAllDice() {
    setState(() {
      for (int i = 0; i < diceValues.length; i++) {
        // Only roll dice that are not held
        if (!isHeld[i]) {
          diceValues[i] = Random().nextInt(6) + 1;
        }
      }
    });
  }

  // Function to toggle the "Hold" state for a dice
  void toggleHold(int index) {
    setState(() {
      isHeld[index] = !isHeld[index];
    });
  }

  // Function to build the dice images with hold functionality
  Widget buildDice(int number, int index) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              width: 3,
              color: isHeld[index] ? Colors.red : Colors.black, // Highlight if held
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(
            'assets/dice-six-faces-$number.png',
            height: 100,
            width: 100,
          ),
        ),
        ElevatedButton(
          onPressed: () => toggleHold(index),
          child: Text(isHeld[index] ? 'Held' : 'Hold'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yahtzee")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: rollAllDice,
            child: Text("Roll All"),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(diceValues.length, (index) {
              return buildDice(diceValues[index], index);
            }),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
=======
// Barrett Koster
// Your Name Here (replace mine, this is just demos
// of stuff anyone can use).

import 'package:flutter/material.dart';
import 'dart:math'; // For random number generation

void main() {
  runApp(Yahtzee());
}

class Yahtzee extends StatelessWidget {
  Yahtzee({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Yahtzee",
      home: YahtzeeHome(),
    );
  }
}

class YahtzeeHome extends StatefulWidget {
  @override
  State<YahtzeeHome> createState() => YahtzeeHomeState();
}

class YahtzeeHomeState extends State<YahtzeeHome> {
  // List of dice numbers, initially set to 1 for all dice
  List<int> diceValues = List.generate(5, (index) => 1);
  // List to track whether each dice is held
  List<bool> isHeld = List.generate(5, (index) => false);

  // Function to randomize all dice values
  void rollAllDice() {
    setState(() {
      for (int i = 0; i < diceValues.length; i++) {
        // Only roll dice that are not held
        if (!isHeld[i]) {
          diceValues[i] = Random().nextInt(6) + 1;
        }
      }
    });
  }

  // Function to toggle the "Hold" state for a dice
  void toggleHold(int index) {
    setState(() {
      isHeld[index] = !isHeld[index];
    });
  }

  // Function to build the dice images with hold functionality
  Widget buildDice(int number, int index) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              width: 3,
              color: isHeld[index] ? Colors.red : Colors.black, // Highlight if held
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(
            'assets/dice-six-faces-$number.png',
            height: 100,
            width: 100,
          ),
        ),
        ElevatedButton(
          onPressed: () => toggleHold(index),
          child: Text(isHeld[index] ? 'Held' : 'Hold'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yahtzee")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: rollAllDice,
            child: Text("Roll All"),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(diceValues.length, (index) {
              return buildDice(diceValues[index], index);
            }),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
>>>>>>> e38d0c0ee65e0d9c2a4af9772224c97a9b8e5e7c
