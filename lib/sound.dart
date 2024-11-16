import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sound_state.dart';

void main() {
  runApp(const SayWhat());
}

class SayWhat extends StatelessWidget {
  const SayWhat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Soundboard"
      home: MultiBlocProvider(
        providers: List.generate(
          5,
          (index) => BlocProvider(
            create: (context) => SoundCubit(),
          ),
        ),
        child: SayWhatBoard(),
      ),
    );
  }
}

class SayWhatBoard extends StatelessWidget {
  const SayWhatBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Soundboard")),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return SoundChannelWidget(channelIndex: index + 1);
        },
      ),
    );
  }
}

class SoundChannelWidget extends StatelessWidget {
  final int channelIndex;
  const SoundChannelWidget({super.key, required this.channelIndex});

  @override
  Widget build(BuildContext context) {
    final soundCubit = context.read<SoundCubit>();

    return BlocBuilder<SoundCubit, SoundState>(
      builder: (context, state) {
        return Column(
          children: [
            Text("Channel $channelIndex"),
            ElevatedButton(
              onPressed: state.isRecording
                  ? soundCubit.stopRecording
                  : soundCubit.startRecording,
              child: Text(state.isRecording ? "Stop Recording" : "Start Recording"),
            ),
            ElevatedButton(
              onPressed: soundCubit.playRecording,
              child: const Text("Play"),
            ),
            ElevatedButton(
              onPressed: soundCubit.stopPlaying,
              child: const Text("Stop Play"),
            ),
          ],
        );
      },
    );
  }
}


