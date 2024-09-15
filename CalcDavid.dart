import 'package:flutter/material.dart';

void main() {
  runApp(const Calc()); // Replace 'YourName' with your actual name
}

class Calc extends StatelessWidget {
  const Calc({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Converter App',
      home: ConversionHome(),
    );
  }
}

class ConversionHome extends StatefulWidget {
  const ConversionHome({super.key});

  @override
  State<ConversionHome> createState() => _ConversionHomeState();
}

class _ConversionHomeState extends State<ConversionHome> {
  String input = ''; // input value by user
  String output = ''; // output after conversion
  String selectConversion = ''; // conversion selected by user

  // this function will add a number to the input when that number is pressed
  void pressNumber (String number) {
    setState(() {
      input += number;
    });
  }

  // just adds a negative sign to the front of the number
  void negativeSign() {
    setState(() {
      if (!input.startsWith('-')) {
        input = '-$input'; // adds negative sign if there is no negative sign present
      }
    });
  }

  // deletes last number in the input
  void delete() {
    setState(() {
      // first checks if the input is not empty
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      }
    });
  }

  // clears the whole input
  void clear() {
    setState(() {
      input = '';
      output = '';
    });
  }

  // function used for all the conversion stuff
  void convert(String conversionType) {
    setState(() {
      double inputValue = double.tryParse(input) ?? 0.0; // Parse the input string to a double
      switch (conversionType) {
        case 'F->C':
          output = ((inputValue - 32) * 5 / 9).toStringAsFixed(2); // F to C
          break;
        case 'C->F':
          output = ((inputValue * 9 / 5) + 32).toStringAsFixed(2); // C to F
          break;
        case 'lb->kg':
          output = (inputValue * 0.453592).toStringAsFixed(2); // lb to kg
          break;
        case 'kg->lb':
          output = (inputValue / 0.453592).toStringAsFixed(2); // kg to lb
          break;
      }
      selectConversion = conversionType;
    });
  }

  // Widget for the buttons displaying different numbers
  Widget numberButton(String number) {
    return Expanded(
      child: FloatingActionButton(
        onPressed: () => pressNumber(number),
        child: Text(number, style: const TextStyle(fontSize: 24)),
        mini: true,
      ),
    );
  }

  Widget conversion(String label) {
    return Expanded(
      child: FloatingActionButton(
        onPressed: () => convert(label),
        child: Text(label, style: const TextStyle(fontSize: 20)),
        mini: true, // smaller floatingactionbutton
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Converter"),
      ),
      body: Column(
        children: [
          // Display input and output areas
          Padding(
            padding: const EdgeInsets.all(16.0), // Padding around the input-output area
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black), // Black border around the input box
                    ),
                    child: Text(
                      input,
                      style: const TextStyle(fontSize: 24), // font size for input text
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black), // Black border around the output box
                    ),
                    child: Text(
                      output,
                      style: const TextStyle(fontSize: 24), // font size for output text
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Conversion buttons
          Column(
            children: [
              Row(
                children: [
                  conversion("F->C"),
                ],
              ),
              Row(
                children: [
                  conversion("C->F"),
                ],
              ),
              Row(
                children: [
                  conversion("lb->kg"),
                ],
              ),
              Row(
                children: [
                  conversion("kg->lb"),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20), // space between conversion buttons and number pad

          // Number pad
          Expanded(
            child: Column(
              children: [
                // first row
                Row(
                  children: [
                    numberButton("1"),
                    numberButton("2"),
                    numberButton("3"),
                  ],
                ),
                // second row
                Row(
                  children: [
                    numberButton("4"),
                    numberButton("5"),
                    numberButton("6"),
                  ],
                ),
                // third row
                Row(
                  children: [
                    numberButton("7"),
                    numberButton("8"),
                    numberButton("9"),
                  ],
                ),
                // fourth row
                Row(
                  children: [
                    numberButton("0"),
                    numberButton("."),
                    Expanded(
                      child: FloatingActionButton(
                        onPressed: negativeSign, // Add negative sign when clicked
                        child: const Text("(-)", style: TextStyle(fontSize: 24)),
                        mini: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: FloatingActionButton(
                        onPressed: delete, // Delete last number from input
                        child: const Text("DEL", style: TextStyle(fontSize: 24)),
                        mini: true,
                      ),
                    ),
                    Expanded(
                      child: FloatingActionButton(
                        onPressed: clear, // clear the input and output fields
                        child: const Text("CLEAR", style: TextStyle(fontSize: 24)),
                        mini: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}






