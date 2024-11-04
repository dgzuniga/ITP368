
import "dart:io";
import "dart:math";
import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter/material.dart";

void main2()
{ runApp(const Robot());
}

class Robot extends StatelessWidget
{
  const Robot({super.key});

  @override
  Widget build(BuildContext context)
  { return const MaterialApp
    ( title: "Robot",
      home: RobotHome(),
    );
  }
}

class RobotHome extends StatefulWidget
{
  const RobotHome({super.key});

  @override
  State<RobotHome> createState() => RobotHomeState();
}

class RobotHomeState extends State<RobotHome>
{
  int initialRobotX = 2;
  int initialRobotY = 2; 

  void robotMove(String direction) {
    setState(() {
      // Robot moves up if it isn't in the first row
      if (direction == "up" && initialRobotY != 0) {
        initialRobotY--;
      } 
      // Robot moves down if it isnt in the last row
      else if (direction == "down" && initialRobotY != 4) {
        initialRobotY++;
      } 
      // Robot moves left if it isnt in the left most column
      else if (direction == "left" && initialRobotX != 0) {
        initialRobotX--;
      } 
      // Robot moves right if it isnt in the right most column
      else if (direction == "right" && initialRobotX != 4) {
        initialRobotX++;
      }
    });
  }

  @override
  Widget build( BuildContext context )
  { 
    // grid2 is build by loop here, included in widget
    // tree later.
    Column grid2 = const Column(children:[]);
    for ( int y = 0; y<5; y++ )
    { Row arow = const Row(children:[]);
      for( int x=0; x<5; x++ )
      {
        String display;
        // Current spot should display R
        if (x == initialRobotX && y == initialRobotY) {
          display = "R";
        } else {
          display = "";
        } 
        arow.children.add( TextWithBorder(display) );
      }
      grid2.children.add(arow);
    }

    // Scaffold is the screen contents for RobotHomeState
    return Scaffold(
      appBar: AppBar(title: const Text("Robot")),
      body: Column(
        children: [
          grid2,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // When a button is pressed it calls a certain function to move the robot
              // Content inside child is what is displayed on the button
              FloatingActionButton(
                onPressed: () => robotMove("up"),
                child: const Text("up"),
              ),
              FloatingActionButton(
                onPressed: () => robotMove("down"),
                child: const Text("down"),
              ),
              FloatingActionButton(
                onPressed: () => robotMove("left"),
                child: const Text("left"),
              ),
              FloatingActionButton(
                onPressed: () => robotMove("right"),
                child: const Text("right"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// box with some text in it.
class TextWithBorder extends StatelessWidget
{
  final String s; // this is what is in the box

  const TextWithBorder(this.s, {super.key});

  @override
  Widget build( BuildContext context )
  {
    return Container
    ( height: 50,
      width: 50,
      decoration: BoxDecoration
      ( border: Border.all
                (width:2,color: const Color(0xff0000ff)),
      ),
          
      child: Text(s),
    );
  }
}
