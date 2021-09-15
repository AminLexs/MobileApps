import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:laba3/models/locale.modal.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';


class VideoScreen extends StatefulWidget {
  final String videoUrl;

  VideoScreen({@required this.videoUrl}) : super();

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    videoPlayerController.initialize();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
          appBar: AppBar(
            title: Text(Provider.of<LocaleModel>(context).getString("video_screen")),
          ),
          body:videoPlayerController != null ? Chewie(
            controller: ChewieController(
              videoPlayerController: videoPlayerController,
              autoPlay: true,
              looping: false,
            ),
          ) : null,
        ));
  }
}
