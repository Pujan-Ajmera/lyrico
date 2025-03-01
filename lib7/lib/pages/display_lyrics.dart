
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:genius_lyrics/genius_lyrics.dart';
import 'package:genius_lyrics/models/song.dart';

import '../utility/colors.dart';

class DisplayLyrics extends StatefulWidget {
  final String? lyr;
  final String? artist_names;
  final String? full_title;
  final String? header_image_thumbnail_url;

  DisplayLyrics(this.lyr, {this.artist_names, this.full_title, this.header_image_thumbnail_url});

  @override
  State<DisplayLyrics> createState() => _DisplayLyricsState();
}

class _DisplayLyricsState extends State<DisplayLyrics> {
  bool isOnline = true;
  void initState() {
    super.initState();
    checkInternet();
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      setState(() {
        isOnline = results.contains(ConnectivityResult.wifi) || results.contains(ConnectivityResult.mobile);
      });
    });
  }


  Future<void> checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isOnline = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.full_title}", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.header_image_thumbnail_url != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: isOnline
                      ? (widget.header_image_thumbnail_url != null && widget.header_image_thumbnail_url!.isNotEmpty
                      ? Image.network(
                    widget.header_image_thumbnail_url!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/ic_launcher.png', // Show asset image if API image fails
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Image.asset(
                    'assets/ic_launcher.png', // Show asset if URL is null/empty
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ))
                      : Image.asset(
                    'assets/ic_launcher.png', // Show asset when offline
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 12),
              Text(
                widget.full_title ?? "Unknown Title",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                widget.artist_names ?? "Unknown Artist",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Divider(color: Colors.white38, thickness: 1),
              SizedBox(height: 16),
              Text(
                widget.lyr ?? "Lyrics not available",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}