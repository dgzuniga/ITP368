

import "package:flutter/material.dart";

void main2()
{ runApp(Robot());
}

class Robot extends StatelessWidget
{
  Robot({super.key});

  @override
  Widget build(BuildContext context)
  { return MaterialApp
    ( title: "Robot",
      home: RobotHome(),
    );
  }
}

class RobotHome extends StatefulWidget
{
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
    Column grid2 = Column(children:[]);
    for ( int y = 0; y<5; y++ )
    { Row arow = Row(children:[]);
      for( int x=0; x<5; x++ )
      {
        String display;
        // Current spot should display R
        if (x == initialRobotX && y == initialRobotY) 
          display = "R";
        else {
          display = "";
        } 
        arow.children.add( TextWithBorder(display) );
      }
      grid2.children.add(arow);
    }

    // Scaffold is the screen contents for RobotHomeState
    return Scaffold(
      appBar: AppBar(title: Text("Robot")),
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
                child: Text("up"),
              ),
              FloatingActionButton(
                onPressed: () => robotMove("down"),
                child: Text("down"),
              ),
              FloatingActionButton(
                onPressed: () => robotMove("left"),
                child: Text("left"),
              ),
              FloatingActionButton(
                onPressed: () => robotMove("right"),
                child: Text("right"),
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
