class YoutubePlayerFlags {
  final bool hideControls;

  final bool controlsVisibleAtStart;

  final bool autoPlay;

  final bool mute;

  final bool isLive;

  final bool hideThumbnail;

  final bool disableDragSeek;

  final bool loop;

  final bool enableCaption;

  final String captionLanguage;

  final bool forceHD;

  final int startAt;

  final int? endAt;

  final bool useHybridComposition;

  final bool showLiveFullscreenButton;

  const YoutubePlayerFlags({
    this.hideControls = false,
    this.controlsVisibleAtStart = false,
    this.autoPlay = true,
    this.mute = false,
    this.isLive = false,
    this.hideThumbnail = false,
    this.disableDragSeek = false,
    this.enableCaption = true,
    this.captionLanguage = 'en',
    this.loop = false,
    this.forceHD = false,
    this.startAt = 0,
    this.endAt,
    this.useHybridComposition = true,
    this.showLiveFullscreenButton = true,
  });

  YoutubePlayerFlags copyWith({
    bool? hideControls,
    bool? autoPlay,
    bool? mute,
    bool? showVideoProgressIndicator,
    bool? isLive,
    bool? hideThumbnail,
    bool? disableDragSeek,
    bool? loop,
    bool? enableCaption,
    bool? forceHD,
    String? captionLanguage,
    int? startAt,
    int? endAt,
    bool? controlsVisibleAtStart,
    bool? useHybridComposition,
    bool? showLiveFullscreenButton,
  }) {
    return YoutubePlayerFlags(
      autoPlay: autoPlay ?? this.autoPlay,
      captionLanguage: captionLanguage ?? this.captionLanguage,
      disableDragSeek: disableDragSeek ?? this.disableDragSeek,
      enableCaption: enableCaption ?? this.enableCaption,
      hideControls: hideControls ?? this.hideControls,
      hideThumbnail: hideThumbnail ?? this.hideThumbnail,
      isLive: isLive ?? this.isLive,
      loop: loop ?? this.loop,
      mute: mute ?? this.mute,
      forceHD: forceHD ?? this.forceHD,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      controlsVisibleAtStart:
      controlsVisibleAtStart ?? this.controlsVisibleAtStart,
      useHybridComposition: useHybridComposition ?? this.useHybridComposition,
      showLiveFullscreenButton:
      showLiveFullscreenButton ?? this.showLiveFullscreenButton,
    );
  }
}
