import 'package:flutter/material.dart';
import '../utility/colors.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: MyColors().color2,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard(context, Icons.favorite, "Delete All Favourite Users", _deleteArtists, Colors.pinkAccent),
            SizedBox(height: 15),
            _buildCard(context, Icons.music_note, "Delete All Saved Songs", _deleteSongs, Colors.blueAccent),
            SizedBox(height: 15),
            _buildCard(context, Icons.warning_amber_rounded, "Solution to Your Issues",
                    () => _showSettingsPopup(context), Colors.orangeAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String text, VoidCallback onTap, Color iconColor) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: MyColors().color6,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [MyColors().color6.withOpacity(0.8), MyColors().color6.withOpacity(1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          leading: Icon(icon, color: iconColor, size: 28),
          title: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white, size: 28),
            onPressed: onTap,
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  void _deleteArtists() {
    // Handle artist delete logic
  }

  void _deleteSongs() {
    // Handle song delete logic
  }

  void _showSettingsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.black,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.orangeAccent, size: 40),
              SizedBox(height: 12),
              Text(
                "Why is the data taking time to load?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                "Fetching data can be slow due to a weak internet connection or high server load. This affects how quickly your favorite songs and artists are retrieved.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
              SizedBox(height: 12),
              Divider(color: Colors.white24),
              SizedBox(height: 12),
              Text(
                "Solution:",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                "To avoid delays, save your favorite songs and artists locally so they can be accessed instantly without waiting for a network request.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: Text("Got It", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
