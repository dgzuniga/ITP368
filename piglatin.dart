import "package:flutter/material.dart";

void main6()
{ runApp(PigLatin());
}

class PigLatin extends StatelessWidget
{
  PigLatin({super.key});

  @override
  Widget build(BuildContext context)
  { return MaterialApp
    ( title: "whatEVER",
      home: PigHome(),
    );
  }
}

class PigHome extends StatefulWidget
{
  @override
  State<PigHome> createState() => PigHomeState();
}

class PigHomeState extends State<PigHome>
{ String saying = "stuff";
  TextEditingController tec = TextEditingController();

  @override
  Widget build( BuildContext context )
  { return Scaffold
    ( appBar: AppBar(title:Text("Pig Latin")),
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
            child: Text("do it"),
          ),
        ],
      ),
    );
  }
}
