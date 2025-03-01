
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lyrico/pages/page_where_you_find_songs.dart';
import 'package:lyrico/pages/settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'allsavedsongs.dart';
import 'test.dart';
import '../utility/colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  void initState() {
    super.initState();
    // Set the status bar color
  }
  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController songController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // this is the code where i am able to change the color of the status bar as the default color was black and i was not able to see the time and other icons

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Text("Search Lyrics",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        elevation: 4,
        shadowColor: Colors.black54,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextFormField(
                  controller: songController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a song name';
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    filled: true,
                    fillColor: Colors.grey[900],
                    hintText: 'Enter Song Name',
                    hintStyle: TextStyle(color: Colors.white54),
                  ),
                )
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors().color4,
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        var send = songController.text;
                        songController.text = "";
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AllSongs(send),
                          ),
                        );
                      }
                    },
                    child: const Text("Search",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black)),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      songController.text = "";
                      setState(() {});
                    },
                    child: const Text("Remove",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // region drawer
      drawer: Drawer(
        backgroundColor: MyColors().color6,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: MyColors().color6),
              // Background color
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28, // Adjust size
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage(
                            "assets/ic_launcher.png"), // Replace with your image
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Lyrico",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "2.0.8 .arm_neon",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Changelog",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      _launchURL(
                          'https://github.com/Pujan-Ajmera/Lyrics-Finder/releases');
                    },
                    child: Text(
                      "Check for update",
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              visualDensity: VisualDensity(vertical: -3),
              leading: Icon(
                Icons.library_music,
                color: Colors.orange,
              ),
              title: Text(
                'Discover',
                style: TextStyle(color: Colors.orange),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              visualDensity: VisualDensity(vertical: -3),
              leading: Icon(
                Icons.bookmark_border,
                color: MyColors().color7,
              ),
              title: Text(
                'Saved Songs',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Allsavedsongs()),
                );
              },
            ),
            Divider(),
            ListTile(
              visualDensity: VisualDensity(vertical: -3),
              leading: Icon(
                Icons.person,
                color: MyColors().color7,
              ),
              title: Text(
                'Find me on Instagram',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                _launchURL('https://www.instagram.com/pujanajmera2');
              },
            ),
            ListTile(
              visualDensity: VisualDensity(vertical: -3),
              leading: Icon(
                Icons.reddit,
                color: MyColors().color7,
              ),
              title: Text(
                'Find me on Reddit',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                _launchURL('https://www.reddit.com/');
              },
            ),
            Divider(),
            ListTile(
              visualDensity: VisualDensity(vertical: -3),
              leading: Icon(
                Icons.settings,
                color: MyColors().color7,
              ),
              title: Text(
                'Settings',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );
              },
            ),
            ListTile(
              visualDensity: VisualDensity(vertical: -3),// gives space bw 2 listview
              leading: Icon(
                Icons.info,
                color: MyColors().color7,
              ),
              title: Text(
                'About Me',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutMePage()),
                );
              },
            ),
            ListTile(
              visualDensity: VisualDensity(vertical: -3),
              leading: Icon(
                Icons.mail_outline_outlined,
                color: MyColors().color7,
              ),
              title: Text(
                'Feedback',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                openGmail();
              },
            ),
          ],
        ),
      ),
      // endregion
    );
  }
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void openGmail() async {
    String email = 'ajmerapujan22@gmail.com';
    String subject = Uri.encodeComponent('Hello!');
    String body = Uri.encodeComponent('I want to reach out...');

    final Uri emailUri = Uri.parse('mailto:$email?subject=$subject&body=$body');

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch Gmail';
    }
  }

}
