import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.integration_test.audio',
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class AudioPlayerHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  String audioasset = "audio/siren_small.mp3";

  AudioPlayerHandler() {
    playbackState.add(playbackState.value.copyWith(
      controls: [MediaControl.play],
      processingState: AudioProcessingState.loading,
    ));
    _player.setSource(AssetSource(audioasset)).then((_) {
      playbackState.add(playbackState.value.copyWith(
        processingState: AudioProcessingState.ready,
      ));
    });
  }

  @override
  Future<void> play() async {
    playbackState.add(playbackState.value.copyWith(
      playing: true,
      controls: [MediaControl.pause],
    ));
    _player.play(AssetSource(audioasset));
  }

  @override
  Future<void> pause() async {
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      controls: [MediaControl.play],
    ));
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    // Release any audio decoders back to the system
    await _player.stop();

    // Set the audio_service state to `idle` to deactivate the notification.
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.idle,
    ));
  }
}
