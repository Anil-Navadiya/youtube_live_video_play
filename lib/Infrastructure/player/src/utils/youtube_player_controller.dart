import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../enums/playback_rate.dart';
import '../enums/player_state.dart';
import '../utils/youtube_meta_data.dart';
import '../widgets/progress_bar.dart';
import 'youtube_player_flags.dart';

class YoutubePlayerValue {
  YoutubePlayerValue({
    this.isReady = false,
    this.isControlsVisible = false,
    this.hasPlayed = false,
    this.position = const Duration(),
    this.buffered = 0.0,
    this.isPlaying = false,
    this.isFullScreen = false,
    this.volume = 100,
    this.playerState = PlayerState.unknown,
    this.playbackRate = PlaybackRate.normal,
    this.playbackQuality,
    this.errorCode = 0,
    this.webViewController,
    this.isDragging = false,
    this.metaData = const YoutubeMetaData(),
  });

  final bool isReady;

  final bool isControlsVisible;

  final bool hasPlayed;

  final Duration position;

  final double buffered;

  final bool isPlaying;

  final bool isFullScreen;

  final int volume;

  final PlayerState playerState;

  final double playbackRate;

  final int errorCode;

  final InAppWebViewController? webViewController;

  bool get hasError => errorCode != 0;

  final String? playbackQuality;

  final bool isDragging;

  final YoutubeMetaData metaData;

  YoutubePlayerValue copyWith({
    bool? isReady,
    bool? isControlsVisible,
    bool? isLoaded,
    bool? hasPlayed,
    Duration? position,
    double? buffered,
    bool? isPlaying,
    bool? isFullScreen,
    int? volume,
    PlayerState? playerState,
    double? playbackRate,
    String? playbackQuality,
    int? errorCode,
    InAppWebViewController? webViewController,
    bool? isDragging,
    YoutubeMetaData? metaData,
  }) {
    return YoutubePlayerValue(
      isReady: isReady ?? this.isReady,
      isControlsVisible: isControlsVisible ?? this.isControlsVisible,
      hasPlayed: hasPlayed ?? this.hasPlayed,
      position: position ?? this.position,
      buffered: buffered ?? this.buffered,
      isPlaying: isPlaying ?? this.isPlaying,
      isFullScreen: isFullScreen ?? this.isFullScreen,
      volume: volume ?? this.volume,
      playerState: playerState ?? this.playerState,
      playbackRate: playbackRate ?? this.playbackRate,
      playbackQuality: playbackQuality ?? this.playbackQuality,
      errorCode: errorCode ?? this.errorCode,
      webViewController: webViewController ?? this.webViewController,
      isDragging: isDragging ?? this.isDragging,
      metaData: metaData ?? this.metaData,
    );
  }

  @override
  String toString() {
    return '$runtimeType('
        'metaData: ${metaData.toString()}, '
        'isReady: $isReady, '
        'isControlsVisible: $isControlsVisible, '
        'position: ${position.inSeconds} sec. , '
        'buffered: $buffered, '
        'isPlaying: $isPlaying, '
        'volume: $volume, '
        'playerState: $playerState, '
        'playbackRate: $playbackRate, '
        'playbackQuality: $playbackQuality, '
        'errorCode: $errorCode)';
  }
}

class YoutubePlayerController extends ValueNotifier<YoutubePlayerValue> {
  final String initialVideoId;

  final YoutubePlayerFlags flags;

  YoutubePlayerController({
    required this.initialVideoId,
    this.flags = const YoutubePlayerFlags(),
  }) : super(YoutubePlayerValue());

  static YoutubePlayerController? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedYoutubePlayer>()
        ?.controller;
  }

  _callMethod(String methodString) {
    if (value.isReady) {
      value.webViewController?.evaluateJavascript(source: methodString);
    } else {
      print('The controller is not ready for method calls.');
    }
  }

  // ignore: use_setters_to_change_properties
  void updateValue(YoutubePlayerValue newValue) => value = newValue;

  void play() => _callMethod('play()');

  void pause() => _callMethod('pause()');

  void load(String videoId, {int startAt = 0, int? endAt}) {
    var loadParams = 'videoId:"$videoId",startSeconds:$startAt';
    if (endAt != null && endAt > startAt) {
      loadParams += ',endSeconds:$endAt';
    }
    _updateValues(videoId);
    if (value.errorCode == 1) {
      pause();
    } else {
      _callMethod('loadById({$loadParams})');
    }
  }

  void _updateValues(String id) {
    if (id.length != 11) {
      updateValue(
        value.copyWith(
          errorCode: 1,
        ),
      );
      return;
    }
    updateValue(
      value.copyWith(errorCode: 0, hasPlayed: false),
    );
  }

  void mute() => _callMethod('mute()');

  void unMute() => _callMethod('unMute()');

  void setVolume(int volume) =>
      volume >= 0 && volume <= 100
          ? _callMethod('setVolume($volume)')
          : throw Exception("Volume should be between 0 and 100");

  void seekTo(Duration position, {bool allowSeekAhead = true}) {
    _callMethod('seekTo(${position.inMilliseconds / 1000},$allowSeekAhead)');
    play();
    updateValue(value.copyWith(position: position));
  }

  void setSize(Size size) =>
      _callMethod('setSize(${size.width}, ${size.height})');

  void fitWidth(Size screenSize) {
    var adjustedHeight = 9 / 16 * screenSize.width;
    setSize(Size(screenSize.width, adjustedHeight));
    _callMethod(
      'setTopMargin("-${((adjustedHeight - screenSize.height) / 2 * 100)
          .abs()}px")',
    );
  }

  void fitHeight(Size screenSize) {
    setSize(screenSize);
    _callMethod('setTopMargin("0px")');
  }

  void setPlaybackRate(double rate) => _callMethod('setPlaybackRate($rate)');

  void toggleFullScreenMode() {
    updateValue(value.copyWith(isFullScreen: !value.isFullScreen));
    if (value.isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  YoutubeMetaData get metadata => value.metaData;

  void reload() => value.webViewController?.reload();

  void reset() =>
      updateValue(
        value.copyWith(
          isReady: false,
          isFullScreen: false,
          isControlsVisible: false,
          playerState: PlayerState.unknown,
          hasPlayed: false,
          position: Duration.zero,
          buffered: 0.0,
          errorCode: 0,
          isLoaded: false,
          isPlaying: false,
          isDragging: false,
          metaData: const YoutubeMetaData(),
        ),
      );
}

class InheritedYoutubePlayer extends InheritedWidget {
  const InheritedYoutubePlayer({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  final YoutubePlayerController controller;

  @override
  bool updateShouldNotify(InheritedYoutubePlayer oldPlayer) =>
      oldPlayer.controller.hashCode != controller.hashCode;
}
