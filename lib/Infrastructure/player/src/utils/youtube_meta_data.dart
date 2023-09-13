class YoutubeMetaData {
  final String videoId;

  final String title;

  final String author;

  final Duration duration;

  const YoutubeMetaData({
    this.videoId = '',
    this.title = '',
    this.author = '',
    this.duration = const Duration(),
  });

  factory YoutubeMetaData.fromRawData(dynamic rawData) {
    final data = rawData as Map<String, dynamic>;
    final durationInMs = ((data['duration'] ?? 0).toDouble() * 1000).floor();
    return YoutubeMetaData(
      videoId: data['videoId'],
      title: data['title'],
      author: data['author'],
      duration: Duration(milliseconds: durationInMs),
    );
  }

  @override
  String toString() {
    return '$runtimeType('
        'videoId: $videoId, '
        'title: $title, '
        'author: $author, '
        'duration: ${duration.inSeconds} sec.)';
  }
}
