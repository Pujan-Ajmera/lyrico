import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database/saved.dart';
import '../utility/colors.dart';
import 'display_lyrics.dart';

class Allsavedsongs extends StatefulWidget {
  const Allsavedsongs({super.key});
  @override
  State<Allsavedsongs> createState() => _AllsavedsongsState();
}

class _AllsavedsongsState extends State<Allsavedsongs> {
  final MyDatabase dbHelper = MyDatabase();
  bool isOnline = true;
  void initState() {
    super.initState();
    checkInternet();
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) { setState(() { isOnline = results.contains(ConnectivityResult.wifi) || results.contains(ConnectivityResult.mobile); }); });

  }
  Future<void> checkInternet() async {
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isOnline = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade800,
                Colors.blue.shade900,
              ],
            ),
          ),
        ),
        title: Text("Saved Songs", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade800,
              Colors.blue.shade900,
            ],
          ),
        ),
        child: FutureBuilder(
          future: dbHelper.selectAllLyrics(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.white,)); // White color for indicator
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(color: Colors.white),)); // White error text
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No saved songs available", style: TextStyle(color: Colors.white),)); // White no data text
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var lyric = snapshot.data![index]["lyrics_id"];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0), // Reduced horizontal padding
                    child: GestureDetector(
                      onTap: ()  async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.purple,
                            content: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Loading lyrics :)",
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.only(bottom: 30, left: 50, right: 50),
                          ),
                        );
                        ScaffoldMessenger.of(context).clearSnackBars();
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DisplayLyrics(snapshot.data![index]["lyrics"],artist_names: snapshot.data![index]["artist_names"],full_title: snapshot.data![index]["full_title"],header_image_thumbnail_url:snapshot.data![index]["header_image_thumbnail_url"],),
                            ));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Padding for the list item content
                        margin: EdgeInsets.symmetric(vertical: 0), // Reduced vertical margin between items
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.blueGrey.shade700, width: 0.5)), // Separator line
                          color: Colors.blueGrey[800], // Background color for each list item
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: isOnline?Image.network(
                                snapshot.data![index]["header_image_thumbnail_url"],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Icon(Icons.image, size: 60, color: Colors.grey),
                              ): Image.asset(
                                'assets/ic_launcher.png',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data![index]["full_title"],
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    snapshot.data![index]["artist_names"],
                                    style: TextStyle(fontSize: 14, color: Colors.grey[400]), // Lighter grey color
                                  ),
                                ],
                              ),
                            ),
                            IconButton(onPressed: (){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.blueGrey[900], // Darker background for AlertDialog
                                    title: Text("Confirm Delete", style: TextStyle(color: Colors.white)), // White title
                                    content: Text("Are you sure you want to delete this Song?", style: TextStyle(color: Colors.grey[300])), // Lighter content text
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Cancel", style: TextStyle(color: Colors.white)), // White cancel button
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          dbHelper.deleteLyrics(snapshot.data![index]["lyrics_id"]);
                                          setState(() {});
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.redAccent,
                                              content: Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Song deleted",
                                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                                ),
                                              ),
                                              duration: Duration(milliseconds: 1000),
                                              behavior: SnackBarBehavior.floating,
                                              margin: EdgeInsets.only(bottom: 30, left: 50, right: 50),
                                            ),
                                          );
                                        },
                                        child: Text("Delete", style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },icon: Icon(Icons.delete,color: Colors.redAccent,),) // Changed delete icon color to redAccent
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },),
      ),
    );
  }
  void openYouTube(String songName) async {
    String query = Uri.encodeComponent(songName);
    Uri url = Uri.parse("https://www.youtube.com/results?search_query=$query");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}