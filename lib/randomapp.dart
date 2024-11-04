// Barrett Koster 2024
// Demo of fetching TV shows from TMDb API using keyword search

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

void main909909() {
  runApp(const TvShowApp());
}

class TvShowApp extends StatelessWidget {
  const TvShowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TV Show Search",
      home: Scaffold(
        appBar: AppBar(title: const Text("TV Show Search")),
        body: const TvShowPage(),
      ),
    );
  }
}

// Holds the TV show list and status message
class TvShowState {
  final String message;
  final List<dynamic> tvShows;
  TvShowState(this.message, this.tvShows);
}

// TvShowCubit to manage API call and state changes
class TvShowCubit extends Cubit<TvShowState> {
  TvShowCubit() : super(TvShowState("Enter a keyword to search for TV shows", []));

  // Updates the state with a new message and list of TV shows
  void updateShows(String newMessage, List<dynamic> shows) {
    emit(TvShowState(newMessage, shows));
  }
}

class TvShowPage extends StatelessWidget {
  const TvShowPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return BlocProvider<TvShowCubit>(
      create: (context) => TvShowCubit(),
      child: BlocBuilder<TvShowCubit, TvShowState>(
        builder: (context, tvShowState) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(labelText: 'Enter a keyword to search TV shows'),
                  onSubmitted: (keyword) async {
                    String responseMessage;
                    List<dynamic> shows;
                    try {
                      shows = await fetchTvShows(keyword);
                      responseMessage = shows.isEmpty
                          ? "No TV shows found for '$keyword'"
                          : "Results for '$keyword'";
                    } catch (e) {
                      shows = [];
                      responseMessage = "Failed to fetch TV shows";
                    }
                    context.read<TvShowCubit>().updateShows(responseMessage, shows);
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  String keyword = searchController.text;
                  String responseMessage;
                  List<dynamic> shows;
                  try {
                    shows = await fetchTvShows(keyword);
                    responseMessage = shows.isEmpty
                        ? "No TV shows found for '$keyword'"
                        : "Results for '$keyword'";
                  } catch (e) {
                    shows = [];
                    responseMessage = "Failed to fetch TV shows";
                  }
                  context.read<TvShowCubit>().updateShows(responseMessage, shows);
                },
                child: const Text("Search TV Shows"),
              ),
              const SizedBox(height: 20),
              Text(tvShowState.message, style: const TextStyle(fontSize: 18)),
              Expanded(
                child: ListView.builder(
                  itemCount: tvShowState.tvShows.length,
                  itemBuilder: (context, index) {
                    final show = tvShowState.tvShows[index];
                    return ListTile(
                      title: Text(show['name']),
                      subtitle: Text("Rating: ${show['vote_average']}"),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Function to call the TMDb API using a search keyword
  Future<List<dynamic>> fetchTvShows(String keyword) async {
    const String apiKey = 'cdb3e4f7066d77eeb1c0f51fbabc34f9'; // Replace with your TMDb API key
    final Uri apiUri = Uri.parse(
        'https://api.themoviedb.org/3/search/tv?api_key=$apiKey&query=$keyword');

    final response = await http.get(apiUri);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      return jsonData['results'] as List<dynamic>;
    } else {
      throw Exception("Failed to fetch TV shows");
    }
  }
}
