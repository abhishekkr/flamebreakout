import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

import '../flamebreakout.dart';

class AudioManager extends Component with HasGameReference<FlameBreakout> {
  AudioManager();

  bool audioOn = true;
  final String bgAudioFile = 'abk-bg-chill.mp3';

  initialize() async {
    await FlameAudio.audioCache.loadAll([
      bgAudioFile,
      'abk-clank.mp3',
      'abk-tock.mp3',
    ]);
    FlameAudio.bgm.initialize();
  }

  void play(String audioFile) {
    if (audioOn) {
      FlameAudio.play(audioFile);
    }
  }

  void toggleSound() {
    audioOn != audioOn;

    switch (audioOn) {
      case true:
        playBgMusic();
      case false:
        FlameAudio.bgm.stop();
    }
  }

  void playBgMusic() {
    FlameAudio.bgm.stop();
    FlameAudio.bgm.play(bgAudioFile);
  }
}
