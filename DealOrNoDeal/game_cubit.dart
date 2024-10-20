import 'package:flutter_bloc/flutter_bloc.dart';

// Class representing a suitcase with a value and its revealed status
class Suitcase {
  final int value; // Monetary value inside the suitcase
  bool isRevealed; // Whether the suitcase has been opened or not

  // Constructor to initialize a suitcase with a value and its revealed state (default is unrevealed)
  Suitcase(this.value, {this.isRevealed = false});
}

// Class representing the state of the game
class GameState {
  final List<Suitcase> suitcases; // List of all suitcases in the game
  final int selectedSuitcase; // Index of the player's selected suitcase
  final int offer; // Current offer made by the dealer
  final bool hasDeal; // Whether a deal is available for the player
  final bool isGameOver; // Whether the game has ended

  // Constructor to initialize the game state with default or provided values
  GameState({
    required this.suitcases,
    this.selectedSuitcase = -1,
    this.offer = 0,
    this.hasDeal = false,
    this.isGameOver = false,
  });

  // Copy method to create a new GameState instance with updated properties
  GameState copyWith({
    List<Suitcase>? suitcases,
    int? selectedSuitcase,
    int? offer,
    bool? hasDeal,
    bool? isGameOver,
  }) {
    return GameState(
      suitcases: suitcases ?? this.suitcases,
      selectedSuitcase: selectedSuitcase ?? this.selectedSuitcase,
      offer: offer ?? this.offer,
      hasDeal: hasDeal ?? this.hasDeal,
      isGameOver: isGameOver ?? this.isGameOver,
    );
  }
}

// Class that handles game logic and state updates using BLoC's Cubit
class GameCubit extends Cubit<GameState> {
  // Constructor to initialize the GameCubit with the initial game state
  GameCubit() : super(GameState(suitcases: _createSuitcases()));

  // Helper method to create a shuffled list of suitcases with assigned values
  static List<Suitcase> _createSuitcases() {
    final values = [1, 5, 10, 100, 1000, 5000, 10000, 100000, 500000, 1000000];
    values.shuffle(); // Shuffle the values to randomize suitcase contents
    return values.map((v) => Suitcase(v)).toList(); // Map values to Suitcase objects
  }

  // Method to set the player's selected suitcase
  void selectSuitcase(int index) {
    emit(state.copyWith(selectedSuitcase: index));
  }

  // Method to reveal a suitcase and update the state accordingly
  void revealSuitcase(int index) {
    final updatedSuitcases = List<Suitcase>.from(state.suitcases); // Create a copy of suitcases
    updatedSuitcases[index].isRevealed = true; // Mark the selected suitcase as revealed

    // Check if only the player's chosen case and one other case remain
    final unopenedCases = updatedSuitcases.where((s) => !s.isRevealed).toList();
    if (unopenedCases.length == 2) {
      // Player wins the value in their chosen suitcase
      final playerSuitcaseValue = updatedSuitcases[state.selectedSuitcase].value;
      emit(state.copyWith(
        suitcases: updatedSuitcases,
        offer: playerSuitcaseValue, // Display the amount won
        hasDeal: false,
        isGameOver: true,
      ));
    } else {
      // Continue the game if more than two cases remain
      emit(state.copyWith(suitcases: updatedSuitcases));
      _calculateOffer(); // Calculate and present a new offer
    }
  }

  // Method to calculate the dealer's offer based on remaining suitcases
  void _calculateOffer() {
    final remainingValues = state.suitcases
        .where((s) => !s.isRevealed) // Filter out revealed suitcases
        .map((s) => s.value) // Map to suitcase values
        .toList();

    // Calculate average value of remaining suitcases
    final average = remainingValues.reduce((a, b) => a + b) / remainingValues.length;
    // Dealer offers 90% of the average value, rounded to the nearest whole number
    final offer = (average * 0.9).round();

    // Update the state to show the dealer's offer and indicate a deal is available
    emit(state.copyWith(offer: offer, hasDeal: true));
  }

  // Method to accept the current deal and end the game
  void acceptDeal() {
    emit(state.copyWith(isGameOver: true));
  }

  // Method to reject the current deal and continue the game
  void rejectDeal() {
    emit(state.copyWith(hasDeal: false));
  }
}





