
import 'package:flutter/material.dart';
import 'package:genius_lyrics/genius_lyrics.dart';
import 'package:genius_lyrics/models/song.dart';

import '../utility/colors.dart';

class DisplayLyrics extends StatelessWidget {
  final String? lyr;
  final String? artist_names;
  final String? full_title;
  final String? header_image_thumbnail_url;

  DisplayLyrics(this.lyr, {this.artist_names, this.full_title, this.header_image_thumbnail_url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lyrics", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (header_image_thumbnail_url != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    header_image_thumbnail_url!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 12),
              Text(
                full_title ?? "Unknown Title",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                artist_names ?? "Unknown Artist",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Divider(color: Colors.white38, thickness: 1),
              SizedBox(height: 16),
              Text(
                lyr ?? "Lyrics not available",
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
