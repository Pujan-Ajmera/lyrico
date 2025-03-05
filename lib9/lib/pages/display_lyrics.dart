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
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) { setState(() { isOnline = results.contains(ConnectivityResult.wifi) || results.contains(ConnectivityResult.mobile); }); });
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
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade900,
                Colors.blue.shade900,
                Colors.blue.shade900,
                Colors.blue.shade900,
              ],
            ),
          ),
        ),
        elevation: 0, // No shadow for AppBar
        iconTheme: IconThemeData(color: Colors.white), // White back arrow
        title: Text(
          "${widget.full_title}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // White bold title text in AppBar
            fontSize: 20,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade900,
              Colors.blue.shade900,
              Colors.blue.shade900,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.header_image_thumbnail_url != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54.withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: isOnline
                        ? (widget.header_image_thumbnail_url != null && widget.header_image_thumbnail_url!.isNotEmpty
                        ? Image.network(
                      widget.header_image_thumbnail_url!,
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/ic_launcher.png',
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Image.asset(
                      'assets/ic_launcher.png',
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,
                    ))
                        : Image.asset(
                      'assets/ic_launcher.png',
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SizedBox(height: 20),
              Text(
                widget.full_title ?? "Unknown Title",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white, // White bold title text in body
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 10),
              Text(
                widget.artist_names ?? "Unknown Artist",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70, // White artist name text
                  fontSize: 18,
                  fontWeight: FontWeight.bold, // Artist name also bold now
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 24),
              Divider(color: Colors.white54, thickness: 0.8),
              SizedBox(height: 24),
              Text(
                textAlign: TextAlign.center,
                widget.lyr ?? "Lyrics not available",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Lyrics provided by Lyrico",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}