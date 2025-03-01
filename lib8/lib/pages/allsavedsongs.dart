import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database/saved.dart';
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
        appBar: AppBar(title: Text("Saved"),),
      body: FutureBuilder(
        future: dbHelper.selectAllLyrics(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data available"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var lyric = snapshot.data![index]["lyrics_id"];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: GestureDetector(
                    onTap: ()  async {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.purple,
                          content: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Searching for lyrics :)",
                              style: TextStyle(fontSize: 16),
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
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      shadowColor: Color.fromRGBO(64, 24, 32, 1),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 0.8),
                          borderRadius: BorderRadius.circular(15),
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
                                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(onPressed: (){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Confirm Delete"),
                                    content: Text("Are you sure you want to delete this Song?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context), // Cancel action
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context); // Close the dialog
                                          dbHelper.deleteLyrics(snapshot.data![index]["lyrics_id"]);
                                          setState(() {

                                          });
                                        },
                                        child: Text("Delete", style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },icon: Icon(Icons.delete,color: Colors.red,),)
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
      },),
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
