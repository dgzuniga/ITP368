import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

void main() {
  runApp(LightsOutGame());
}

class LightsOutGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => LightsOutBloc(),
        child: HomePage(),
      ),
    );
  }
}

class LightsOutBloc extends Cubit<List<bool>> {
  LightsOutBloc() : super([]);

  void generateLights(int n) {
    emit(List.generate(n, (_) => Random().nextBool()));
  }

  void toggleLight(int index) {
    final lights = List.of(state);
    
    // Toggle the clicked light
    lights[index] = !lights[index];
    
    // Toggle the left neighbor if exists
    if (index > 0) {
      lights[index - 1] = !lights[index - 1];
    }

    // Toggle the right neighbor if exists
    if (index < lights.length - 1) {
      lights[index + 1] = !lights[index + 1];
    }

    emit(lights); // Update state with toggled lights
  }
}

class HomePage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lights Out')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter number of lights'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                int numLights = int.parse(_controller.text);
                if (numLights > 0) {
                  context.read<LightsOutBloc>().generateLights(numLights);
                }
              },
              child: Text('Generate Lights'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<LightsOutBloc, List<bool>>(
                builder: (context, lights) {
                  if (lights.isEmpty) return Text('Enter a number and click Generate');
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: lights.length,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: lights.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => context.read<LightsOutBloc>().toggleLight(index),
                        child: Container(
                          color: lights[index] ? Colors.yellow : Colors.black,
                          child: SizedBox.expand(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}









