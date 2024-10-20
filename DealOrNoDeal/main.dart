import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_cubit.dart';

// Entry point of the application
void main() {
  runApp(DealOrNoDealApp());
}

// Main app widget using the BLoC pattern with a Cubit for state management
class DealOrNoDealApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deal or No Deal',
      home: BlocProvider(
        // Creating the GameCubit instance to provide state management
        create: (context) => GameCubit(),
        child: GameScreen(),
      ),
    );
  }
}

// Game screen widget where the main gameplay and UI are defined
class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // List of possible values for the suitcases
  final List<int> possibleValues = [1, 5, 10, 100, 1000, 5000, 10000, 100000, 500000, 1000000];
  // List of focus nodes to handle keyboard navigation between suitcases
  final List<FocusNode> focusNodes = List.generate(10, (_) => FocusNode());

  // Dispose of the focus nodes when the widget is removed from the widget tree
  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // Build method to define the UI layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Deal or No Deal')),
      // RawKeyboardListener to handle keyboard input
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (RawKeyEvent event) {
          // Handle keyboard input events (Deal, No Deal, and suitcase selection by number)
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.keyD) {
              _handleDeal(); // Handle "Deal" button
            } else if (event.logicalKey == LogicalKeyboardKey.keyN) {
              _handleNoDeal(); // Handle "No Deal" button
            } else if (event.logicalKey.keyLabel != null &&
                int.tryParse(event.logicalKey.keyLabel) != null) {
              int selectedIndex = int.parse(event.logicalKey.keyLabel);
              if (selectedIndex >= 0 && selectedIndex < focusNodes.length) {
                _handleSuitcaseSelection(selectedIndex); // Handle suitcase selection by number
              }
            }
          }
        },
        // Use BlocBuilder to rebuild UI based on GameCubit state changes
        child: BlocBuilder<GameCubit, GameState>(
          builder: (context, state) {
            if (state.isGameOver) {
              // Display winning message when the game is over
              return Center(
                child: Text(
                  'Game Over! You won \$${state.offer}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              );
            }

            // Main layout for the game screen with suitcase grid and dealer's offer panel
            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Suitcase grid area
                      Expanded(
                        flex: 3,
                        child: _buildSuitcaseGrid(context, state),
                      ),
                      // Dealer's offer panel, visible only when a deal is available
                      if (state.hasDeal) _buildOfferPanel(context, state),
                      // Display instructions or status message at the bottom
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          state.hasDeal
                              ? 'Will you take the deal? Press "d" for Deal, "n" for No Deal'
                              : 'Select a suitcase (0-9)',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                // Vertical list of remaining values on the right side of the screen
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildValueList(state),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Builds the grid of suitcases for the game
  Widget _buildSuitcaseGrid(BuildContext context, GameState state) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
      itemCount: state.suitcases.length,
      itemBuilder: (context, index) {
        final suitcase = state.suitcases[index];
        return GestureDetector(
          onTap: () {
            if (index != state.selectedSuitcase) {
              _handleSuitcaseSelection(index); // Handle suitcase selection by mouse click
            }
          },
          child: Focus(
            focusNode: focusNodes[index],
            child: Container(
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: _getSuitcaseColor(suitcase, index, state),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
                ],
              ),
              child: Center(
                child: Text(
                  suitcase.isRevealed ? '\$${suitcase.value}' : 'Case $index',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Determines the color of a suitcase based on its state (selected or revealed)
  Color _getSuitcaseColor(Suitcase suitcase, int index, GameState state) {
    if (state.selectedSuitcase == index) return Colors.red; // Highlight selected suitcase in red
    return suitcase.isRevealed ? Colors.grey : Colors.blue; // Grey for revealed, blue for unopened
  }

  // Handles the selection of a suitcase by keyboard or mouse click
  void _handleSuitcaseSelection(int index) {
    final state = context.read<GameCubit>().state;
    // If the suitcase is not revealed and no initial suitcase is selected
    if (!state.suitcases[index].isRevealed && state.selectedSuitcase == -1) {
      context.read<GameCubit>().selectSuitcase(index);
    } else if (!state.suitcases[index].isRevealed && !state.hasDeal && index != state.selectedSuitcase) {
      context.read<GameCubit>().revealSuitcase(index); // Reveal selected suitcase
    }
  }

  // Handles the "Deal" button press
  void _handleDeal() {
    if (context.read<GameCubit>().state.hasDeal) {
      context.read<GameCubit>().acceptDeal();
    }
  }

  // Handles the "No Deal" button press
  void _handleNoDeal() {
    if (context.read<GameCubit>().state.hasDeal) {
      context.read<GameCubit>().rejectDeal();
    }
  }

  // Builds the panel to show the dealer's offer and buttons for Deal/No Deal
  Widget _buildOfferPanel(BuildContext context, GameState state) {
    return Column(
      children: [
        Text(
          'Dealer\'s Offer: \$${state.offer}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _handleDeal,
              child: Text('Deal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: _handleNoDeal,
              child: Text('No Deal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Builds a vertical list of all possible suitcase values
  Widget _buildValueList(GameState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Remaining Values',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: possibleValues.length,
            itemBuilder: (context, index) {
              final value = possibleValues[index];
              // Check if the value has been revealed in any suitcase
              final isRevealed = state.suitcases.any((s) => s.isRevealed && s.value == value);

              return Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  '\$$value',
                  style: TextStyle(
                    color: isRevealed ? Colors.grey : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
