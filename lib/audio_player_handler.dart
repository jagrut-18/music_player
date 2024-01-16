// import 'package:just_audio/just_audio.dart';

// class AudioPlayerHandler extends BaseAudioHandler with SeekHandler, QueueHandler {
//   late AudioPlayer _player;
//   late YoutubeExplode _yt;
//   final List<NowPlayingSongModel> _queue = [];
//   int _currentPlayingIndex = -1;

//   AudioPlayerHandler() {
//     _player = AudioPlayer();
//     _yt = YoutubeExplode();
//     _init();
//   }

//   void _init() async {
//     final session = await AudioSession.instance;
//     await session.configure(const AudioSessionConfiguration.music());

//     // Propagate all events from the audio player to AudioService clients.
//     _player.playbackEventStream.listen(_broadcastState);
//   }

//   void setQueue(List<NowPlayingSongModel> songs) {
//     _queue.clear();
//     _queue.addAll(songs);
//     _currentPlayingIndex = 0;
//   }

//   void addToQueue(List<NowPlayingSongModel> songs) {
//     _queue.addAll(songs);
//   }

//   Future<void> setSong() async {
//     final song = _queue[_currentPlayingIndex];
//     final audioSrc = await _getAudioSource(song.videoId);
//     await _player.setAudioSource(
//       ProgressiveAudioSource(Uri.parse(audioSrc)),
//     );
//     mediaItem.add(song.toMediaItem(_player.duration ?? Duration.zero));
//   }

//   AudioPlayer get player => _player;
//   YoutubeExplode get yt => _yt;
//   int get currentPlayingIndex => _currentPlayingIndex;
//   List<NowPlayingSongModel> get myQueue => _queue;
//   bool get isCloseToFinish => _currentPlayingIndex == _queue.length - 3;
//   bool get isLastSongInQueue => _currentPlayingIndex == _queue.length - 1;
//   bool get hasEnoughSongs => _queue.length > 100;
//   bool get doesNotHaveEnoughSongs => _queue.length < 5;

//   @override
//   Future<void> play() => _player.play();

//   @override
//   Future<void> pause() => _player.pause();

//   @override
//   Future<void> seek(Duration position) => _player.seek(position);

//   @override
//   Future<void> stop() async {
//     _queue.clear();
//     _currentPlayingIndex = -1;
//     await _player.stop();
//     await playbackState.firstWhere(
//         (state) => state.processingState == AudioProcessingState.idle);
//   }

//   @override
//   Future<void> skipToNext() async {
//     if (_currentPlayingIndex < _queue.length - 1) {
//       _currentPlayingIndex++;
//       await setSong();
//       play();
//     }
//     if (hasEnoughSongs) return;
//     if (isCloseToFinish) _getWatchList();
//     if (isLastSongInQueue && doesNotHaveEnoughSongs) _getWatchList();
//   }

//   @override
//   Future<void> skipToPrevious() async {
//     if (_currentPlayingIndex >= 1) {
//       _currentPlayingIndex--;
//       setSong();
//       play();
//     }
//   }

//   /// Broadcasts the current state to all clients.
//   void _broadcastState(PlaybackEvent event) {
//     final playing = _player.playing;
//     final queueIndex = _currentPlayingIndex;
//     playbackState.add(playbackState.value.copyWith(
//       controls: [
//         MediaControl.skipToPrevious,
//         if (playing) MediaControl.pause else MediaControl.play,
//         MediaControl.skipToNext,
//       ],
//       systemActions: const {
//         MediaAction.seek,
//         MediaAction.seekForward,
//         MediaAction.seekBackward,
//       },
//       androidCompactActionIndices: const [0, 1, 3],
//       processingState: const {
//         ProcessingState.idle: AudioProcessingState.idle,
//         ProcessingState.loading: AudioProcessingState.loading,
//         ProcessingState.buffering: AudioProcessingState.buffering,
//         ProcessingState.ready: AudioProcessingState.ready,
//         ProcessingState.completed: AudioProcessingState.completed,
//       }[_player.processingState]!,
//       playing: playing,
//       updatePosition: _player.position,
//       bufferedPosition: _player.bufferedPosition,
//       speed: _player.speed,
//       queueIndex: queueIndex,
//     ));
//   }

//   // private methods

//   Future<String> _getAudioSource(String videoId) async {
//     final id = VideoId(videoId);
//     final manifest = await _yt.videos.streamsClient.getManifest(id);
//     final audio = manifest.audioOnly;
//     return audio.last.url.toString();
//   }

//   void _getWatchList() async {
//     ApiService api = ApiService();
//     final watchListItem = await api.playlist.getWatchList(videoId: _queue[_currentPlayingIndex].videoId);
//     if (watchListItem == null) return;
//     final tracks = watchListItem.tracks.sublist(1);
//     final songs = tracks.map((t) => t.toNowPlayingSongModel()).toList();
//     addToQueue(songs);
//   }
// }