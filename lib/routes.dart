// David Zuniga
import "dart:io";
import "dart:math";
import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

TextStyle ts = const TextStyle(fontSize: 30);

class CounterState
{ int count;
  CounterState( this.count );
}
class CounterCubit extends Cubit<CounterState>
{
  CounterCubit() : super( CounterState(0) );

  void inc() { emit( CounterState(state.count+1) ); }
}

void main213()
{ runApp( RoutesDemo() ); }

class RoutesDemo extends StatelessWidget
{
  const RoutesDemo({super.key});

  @override
  Widget build( BuildContext context )
  { String title = "Routes Demo";
    return MaterialApp
    ( title: title,
      home: TopBloc(title:title)
    );
  }
}

class TopBloc extends StatelessWidget
{
  final String title;
  const TopBloc({required this.title, super.key});

  @override
  Widget build( BuildContext context )
  {
    return BlocProvider<CounterCubit>
    ( create: (context) => CounterCubit(),
      child: BlocBuilder<CounterCubit, CounterState>
      ( builder: (context,state) => Route1(title:title)
      ),
    );
  }
}

class Route1 extends StatelessWidget
{ final String title;
  const Route1({required this.title, super.key});

  @override
  Widget build( BuildContext context )
  { CounterCubit cc = BlocProvider.of<CounterCubit>(context);
    return Scaffold
    ( appBar: AppBar( title: Text( title, style: ts) ),
      body: Column
      ( children: 
        [ Text("page 1", style:ts),
          Text("${cc.state.count}",style:ts),
          ElevatedButton
          ( onPressed: () { cc.inc(); },
            child: Text("add 1",style:ts),
          ),
          ElevatedButton ( 
            onPressed: () { 
              Navigator.of(context).push ( 
                MaterialPageRoute ( 
                  builder: (context) => Route2(title:title, cc:cc)
                ),
              );
            },
            child: Text("go to page 2", style:ts),
          ),
        ],
      ),
    );
  }
}class Route2 extends StatelessWidget
{ final String title;
  final CounterCubit cc;
  const Route2({required this.title, required this.cc, super.key});

  @override
  Widget build( BuildContext context )
  { 
    return BlocProvider<CounterCubit>.value ( 
      value: cc,
      child: BlocBuilder<CounterCubit, CounterState> ( 
        builder: (context,state) { 
          return Scaffold ( 
            appBar: AppBar( 
              title: Text( title, style: ts) 
            ),
            body: Column
            ( children: 
              [ Text("page 2", style:ts),
                Text("${cc.state.count}",style:ts),
                ElevatedButton
                ( onPressed: (){ cc.inc(); },
                  child: Text("add 1", style:ts),
                ),
                ElevatedButton
                ( onPressed: (){ Navigator.of(context).pop(); },
                  child: Text("go back",style:ts),
                ),
                ElevatedButton ( 
                  onPressed: () { 
                    Navigator.of(context).push ( 
                      MaterialPageRoute ( 
                        builder: (context) => Route3(title:title, cc:cc)
                      ),
                    );
                  },
                  child: Text("go to page 3", style:ts),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
class Route3 extends StatelessWidget
{ final String title;
  final CounterCubit cc;
  const Route3({required this.title, required this.cc, super.key});

  @override
  Widget build( BuildContext context )
  { 
    return BlocProvider<CounterCubit>.value
    ( value: cc,
      child: BlocBuilder<CounterCubit, CounterState>
      ( builder: (context,state)
        { return Scaffold
           ( appBar: AppBar( title: Text( title, style: ts) ),
            body: Column
            ( children: 
              [ Text("page 3", style:ts),
                Text("${cc.state.count}",style:ts),
                ElevatedButton
                ( onPressed: (){ cc.inc(); },
                  child: Text("add 1", style:ts),
                ),
                ElevatedButton
                ( onPressed: (){ Navigator.of(context).pop(); },
                  child: Text("go back",style:ts),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

