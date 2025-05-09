
import 'package:bca_project/models/videos.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class VideoCart extends StatefulWidget {
  final Videos video;
  const VideoCart({
    super.key,
    required this.video
  });

  @override
  State<VideoCart> createState() => _VideoCartState();
}

class _VideoCartState extends State<VideoCart> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          spacing: 10,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                "http://10.0.2.2:1337${widget.video.coverUrl}",
                fit: BoxFit.cover,
              ),
            ),
            InkWell(
              onTap: () {},
              child: Text(
                widget.video.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 0, 15),
              child: Row(
                spacing: 15,
                children: [
                  Icon(Icons.alarm),
                  Text(timeago.format(widget.video.publishedAt)
                    ,
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
