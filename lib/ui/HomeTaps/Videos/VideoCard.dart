import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raid/model/VideoData.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoCard extends StatefulWidget {
  VideoData videoData;
  VideoCard({this.videoData});
  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoData.url),
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
//    _idController = TextEditingController();
//    _seekToController = TextEditingController();
//    _videoMetaData = const YoutubeMetaData();
//    _playerState = PlayerState.unknown;
  }

  void listener() {
//    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
//      setState(() {
//        _playerState = _controller.value.playerState;
//        _videoMetaData = _controller.metadata;
//      });
//    }
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      // height: size.height / 3,
      child: Column(
        children: [
          Text(
            "${widget.videoData.title}",
            style: const TextStyle(
              //color: Colors.white,
              fontSize: 18.0,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            topActions: <Widget>[
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  _controller.metadata.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 25.0,
                ),
                onPressed: () {
//                log('Settings Tapped!');
                },
              ),
            ],
            onReady: () {
//            _isPlayerReady = true;
            },
            onEnded: (data) {
//            _controller
//                .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
//            _showSnackBar('Next Video Started!');
            },
          ),
        ],
      ),
    );
  }
}
