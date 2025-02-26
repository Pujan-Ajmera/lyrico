
import 'dart:convert';
import 'package:html/parser.dart' as parser;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utility/colors.dart';
import 'display_lyrics.dart';
import 'model.dart';

class AllSongs extends StatefulWidget {
  late Dio _dio;
  String? song;
  AllSongs(this.song){
    BaseOptions options = new BaseOptions(
      connectTimeout: Duration(milliseconds: 20*10000),
      receiveTimeout: Duration(milliseconds: 20*10000),
    );
    _dio = new Dio(options);
  }
  @override
  _AllSongsState createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {
  List<Model> model = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }
  Future<void> fetchProducts() async {
    String songgot = widget.song!;

    final response = await http.get(
      Uri.parse('https://api.genius.com/search?q=${songgot}'),
      headers: {
        'Authorization': 'Bearer IRgGbgFS8LuaU0ef31lOsdvmsZBXvPOK_F8AUewUhR-CJpDQY25Se3vz1Cj7VPDK',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      List<dynamic> hits = jsonData["response"]["hits"];

      setState(() {
        model = hits.map((data) => Model.fromJson(data["result"])).toList();
      });
    } else {
      print("Failed to load data: ${response.statusCode}");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors().color2,
        title: Text('Song List',style: TextStyle(color: Colors.black),),
      ),
      body: ListView.builder(
        itemCount: model.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: GestureDetector(
              onTap: ()  async {
                String lyr = await getSongLyricsFromLink(model[index].url);
                print(lyr);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DisplayLyrics(lyr,artist_names: model[index].artist_names,full_title: model[index].full_title,header_image_thumbnail_url: model[index].header_image_thumbnail_url,),
                ));
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                shadowColor: Colors.black26,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                    // gradient: LinearGradient(
                    //   colors: [Colors.grey.shade100, Colors.white], // Subtle gradient
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    // ),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          model[index].header_image_thumbnail_url,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.image, size: 60, color: Colors.grey),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model[index].full_title,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            Text(
                              model[index].artist_names,
                              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey[700]), // Arrow indicator
                    ],
                  ),
                ),
              ),
            ),
          );
          // return buildSongTile(model[index],context);
        },
      ),
    );
  }

  Future<String> getSongLyricsFromLink(String link) async {
    String songUrl = link;
    print(songUrl);
    var response = await widget._dio.get(songUrl);
    String htmlText = response.data;
    var parsedDoc = parser.parse(htmlText);

    var elements = parsedDoc
        .getElementsByTagName("div")
        .where((element) =>
        element.attributes.containsKey("data-lyrics-container"))
        .toList();

    if (elements.isNotEmpty) {
      String lyricsText = "";
      elements.forEach((element) {
        var x = element;
        x.innerHtml = x.innerHtml.replaceAll("<br>", "\n");
        lyricsText += x.text;
      });
      return lyricsText;
    } else {
      throw Exception("No Lyrics Found");
    }
  }
}


