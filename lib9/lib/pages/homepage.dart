import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lyrico_main/pages/page_where_you_find_songs.dart';
import 'package:lyrico_main/pages/settings.dart';
import 'package:lyrico_main/pages/test.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utility/colors.dart';
import 'allsavedsongs.dart';

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
      extendBodyBehindAppBar: false, // Ensure body is not behind AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // No shadow for AppBar
        flexibleSpace: Container( // Apply gradient to AppBar
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade800, // Slightly lighter, still dark blue for the top
                Colors.blue.shade900, // Very dark blue for the bottom
              ],
            ),
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white), // White menu icon
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Text("Search Lyrics",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)), // White title text
        shadowColor: Colors.black54,
      ),
      body: Container( // Apply gradient to body
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade800, // Slightly lighter, still dark blue for the top
              Colors.blue.shade900, // Very dark blue for the bottom
            ],
          ),
        ),
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
class AboutMePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().color6,
      appBar: AppBar(
        backgroundColor: MyColors().color3,
        title: Text("About Me", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white), // Set back arrow color
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Developed by",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              "Pujan Ajmera",
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            SizedBox(height: 20),
            Text(
              "Contact",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                _launchURL('https://www.instagram.com/pujanajmera2');
              },
              child: Row(
                children: <Widget>[
                  Icon(Icons.person, color: Colors.white70),
                  SizedBox(width: 10),
                  Text(
                    "Instagram",
                    style: TextStyle(fontSize: 18, color: Colors.orangeAccent),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                _launchURL('https://www.reddit.com/user/Pujan_Ajmera/'); // Example Reddit profile link - replace with actual link if available
              },
              child: Row(
                children: <Widget>[
                  Icon(Icons.reddit, color: Colors.white70),
                  SizedBox(width: 10),
                  Text(
                    "Reddit",
                    style: TextStyle(fontSize: 18, color: Colors.orangeAccent),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                _launchEmail('ajmerapujan22@gmail.com');
              },
              child: Row(
                children: <Widget>[
                  Icon(Icons.email, color: Colors.white70),
                  SizedBox(width: 10),
                  Text(
                    "Email",
                    style: TextStyle(fontSize: 18, color: Colors.orangeAccent),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              "About Lyrico",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              "Lyrico is a simple app to find lyrics for your favorite songs. It's built with Flutter and uses public APIs for lyrics data.",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 20),
            Text(
              "Disclaimer",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              "This app is for personal use and educational purposes. Lyrics are sourced from public APIs and accuracy may vary. For any copyright concerns, please contact the respective API providers or music owners.",
              style: TextStyle(fontSize: 14, color: Colors.white54),
            ),
          ],
        ),
      ),
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
  void _launchEmail(String email) async {
    final Uri emailUri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch email app';
    }
  }
}