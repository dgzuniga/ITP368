import "dart:io";
import "dart:math";
import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter/material.dart";

void main6()
{ runApp(const PigLatin());
}

class PigLatin extends StatelessWidget
{
  const PigLatin({super.key});

  @override
  Widget build(BuildContext context)
  { return const MaterialApp
    ( title: "whatEVER",
      home: PigHome(),
    );
  }
}

class PigHome extends StatefulWidget
{
  const PigHome({super.key});

  @override
  State<PigHome> createState() => PigHomeState();
}

class PigHomeState extends State<PigHome>
{ String saying = "stuff";
  TextEditingController tec = TextEditingController();

  @override
  Widget build( BuildContext context )
  { return Scaffold
    ( appBar: AppBar(title:const Text("Pig Latin")),
      body: Column
      ( children:
        [ Text(saying),
          TextField
          ( controller: tec ),
          FloatingActionButton
          ( onPressed: ()
            { setState
              ( ()
                { String s = tec.text;
                  String h = s[0];
                  s = "${s.substring(1)}${h}ay";
                  saying = s;
                }
              );
            },
            child: const Text("do it"),
          ),
        ],
      ),
    );
  }
}
