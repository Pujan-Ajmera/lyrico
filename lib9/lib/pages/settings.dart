import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restart_app/restart_app.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
import '../database/saved.dart';
import '../utility/colors.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Color _selectedColor = Colors.lightGreen; // Keep if you want to restore theme later
  MyDatabase dbHelper = MyDatabase();

  final List<Map<String, String>> faqs = [
    {"question": "How to use this app?", "answer": "You can navigate through the menu to explore features and search for your favorite lyrics."},
    {"question": "Is this app free?", "answer": "Yes, this app is completely free to use! Enjoy unlimited access to lyrics and features."},
    {"question": "How do I seek Help?", "answer": "For any assistance or queries, you can reach out to me at ajmerapujan22@gmail.com. I'm here to help!"},
    {"question": "Is this app Open-Source?", "answer": "Yes, the app is Open Source! You can find the complete code and contribute at github.com/Pujan-Ajmera."},
  ];

  final List<Color> _colorOptions = [ // Keep if you want to restore theme later
    Colors.lightGreen,
    Colors.blue,
    Colors.green,
    Colors.pink,
    Colors.orange,
  ];

  @override
  void initState() {
    super.initState();
    _loadThemeColor(); // Keep if you want to restore theme later
  }

  void _loadThemeColor() async { // Keep if you want to restore theme later
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int colorValue = prefs.getInt('themeColor') ?? Colors.lightGreen.value;
    Color loadedColor = Color(colorValue);

    if (!_colorOptions.contains(loadedColor)) {
      loadedColor = _colorOptions.first;
    }

    setState(() {
      _selectedColor = loadedColor;
    });
  }

  void _changeThemeColor(Color color) async { // Keep if you want to restore theme later
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeColor', color.value);
    Restart.restartApp(); // Restart the app after saving the color
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
        title: Text("Settings", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
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
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildCard(context, Icons.delete_forever, "Delete All Saved Songs", () => _showDeleteConfirmationDialog(context), Colors.redAccent),
            SizedBox(height: 20),
            _buildCard(context, Icons.help_outline, "Troubleshooting & Help", () => _showSettingsPopup(context), Colors.orangeAccent),
            SizedBox(height: 25),
            Text("Frequently Asked Questions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),
            Accordion(
              headerBackgroundColorOpened: Colors.blueAccent.shade700, // Darker shade when opened
              headerBackgroundColor: Colors.blueGrey[700], // Darker background for headers
              paddingListHorizontal: 0,
              children: faqs.map((faq) {
                return AccordionSection(
                  header: Text(
                    faq['question']!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), // White header text
                  ),
                  content: Text(
                    faq['answer']!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]), // Lighter grey content text
                  ),
                  contentBackgroundColor: Colors.blueGrey[800], // Darker content background
                  headerPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Adjusted padding
                  contentHorizontalPadding: 16,
                  contentVerticalPadding: 12,
                  contentBorderWidth: 0,
                );
              }).toList(),
            ),
            SizedBox(height: 25),

            // --- New "About App" Section ---
            Text("About Lyrico", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueGrey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Lyrico", // App Name - You can customize this
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Your go-to app for discovering and exploring song lyrics. Find lyrics for millions of songs, save your favorites, and enjoy a seamless lyrics experience.",
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _rateApp, // Function to rate app
                        icon: Icon(Icons.star_rate_rounded, color: Colors.white),
                        label: Text("Rate App", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Example color
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _shareApp, // Function to share app
                        icon: Icon(Icons.share, color: Colors.white),
                        label: Text("Share App", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent, // Example color
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Add some space at the very bottom if needed
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String text, VoidCallback onTap, Color iconColor) {
    return Card(
      elevation: 3, // Reduced elevation
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Less rounded corners
      color: Colors.blueGrey[800], // Darker card color
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 10), // Adjusted padding
        leading: Icon(icon, color: iconColor, size: 26), // Slightly smaller icon
        title: Text(text, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)), // Adjusted text style
        trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20), // Changed icon and size
        onTap: onTap,
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey[900], // Darker dialog background
          title: Text("Confirm Deletion", style: TextStyle(color: Colors.white)), // White title text
          content: Text("Are you sure you want to delete all saved songs?", style: TextStyle(color: Colors.grey[300])), // Lighter content text
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.white)), // White button text
            ),
            TextButton(
              onPressed: () async {
                await dbHelper.deleteAllLyrics();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "All saved songs deleted",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    duration: Duration(milliseconds: 1500),
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
  }

  void _showSettingsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Less rounded dialog
        backgroundColor: Colors.blueGrey[900], // Darker dialog background
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.help_outline_rounded, color: Colors.orangeAccent, size: 40),
              SizedBox(height: 12),
              Text(
                "Troubleshooting Data Loading",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), // White title
              ),
              SizedBox(height: 12),
              Text(
                "Data loading may be slow due to internet connection or server load. This can affect the speed of retrieving songs and artists.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[400], fontSize: 14), // Lighter content text
              ),
              SizedBox(height: 12),
              Divider(color: Colors.grey.shade700), // Darker divider
              SizedBox(height: 12),
              Text(
                "Solution:",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), // White solution title
              ),
              SizedBox(height: 8),
              Text(
                "Save your favorite songs locally. This allows for instant access without network delays, improving your experience.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[400], fontSize: 14), // Lighter solution text
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent, // Changed button color
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Less rounded button
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Adjusted button padding
                ),
                onPressed: () => Navigator.pop(ctx),
                child: Text("Got It", style: TextStyle(color: Colors.blueGrey[900], fontSize: 16)), // Darker button text
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _rateApp() async {
    // Replace with your app's store URL
    final Uri appStoreUrl = Uri.parse('https://play.google.com/store/apps/details?id=your_app_id'); // Example for Google Play Store
    if (await canLaunchUrl(appStoreUrl)) {
      launchUrl(appStoreUrl, mode: LaunchMode.externalApplication);
    } else {
      // Handle error if URL can't be launched
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Could not launch app store.'),
      ));
    }
  }

  void _shareApp() async {
    // Replace with your app's sharing link or message
    String shareMessage = "Check out this awesome Lyrics app: [Your App Link Here]";
    // Use the share package for more advanced sharing options if needed
    // For simple sharing, you can use:
    final Uri shareUrl = Uri.parse(Uri.encodeFull("mailto:?subject=Check out Lyrico App&body=$shareMessage"));
    if (await canLaunchUrl(shareUrl)) {
      launchUrl(shareUrl); // Or use LaunchMode.externalApplication if needed
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Could not share the app.'),
      ));
    }
  }


  String colorToString(Color color) { // Keep if you want to restore theme later
    if (color == Colors.lightGreen) return "Light Green";
    if (color == Colors.blue) return "Blue";
    if (color == Colors.green) return "Green";
    if (color == Colors.pink) return "Pink";
    if (color == Colors.orange) return "Orange";
    return "Custom";
  }
}