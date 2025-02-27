import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restart_app/restart_app.dart';
import '../utility/colors.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Color _selectedColor = Colors.lightGreen;

  final List<Color> _colorOptions = [
    Colors.lightGreen,
    Colors.blue,
    Colors.green,
    Colors.pink,
    Colors.orange,
  ];

  @override
  void initState() {
    super.initState();
    _loadThemeColor();
  }

  void _loadThemeColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int colorValue = prefs.getInt('themeColor') ?? Colors.lightGreen.value;
    Color loadedColor = Color(colorValue);

    // Ensure the loaded color exists in the dropdown options
    if (!_colorOptions.contains(loadedColor)) {
      loadedColor = _colorOptions.first; // Default to first color in the list
    }

    setState(() {
      _selectedColor = loadedColor;
    });
  }

  void _changeThemeColor(Color color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeColor', color.value);
    Restart.restartApp(); // Restart the app after saving the color
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard(context, Icons.favorite, "Delete All Favourite Users", () {}, Colors.pinkAccent),
            SizedBox(height: 15),
            _buildCard(context, Icons.music_note, "Delete All Saved Songs", () {}, Colors.blueAccent),
            SizedBox(height: 15),
            _buildCard(context, Icons.warning_amber_rounded, "Solution to Your Issues", () {}, Colors.orangeAccent),
            SizedBox(height: 20),

            // Theme Color Dropdown
            Text("Select Theme Color", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: MyColors().color6,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<Color>(
                value: _selectedColor,
                items: _colorOptions.map((color) {
                  return DropdownMenuItem(
                    value: color,
                    child: Row(
                      children: [
                        CircleAvatar(backgroundColor: color, radius: 10),
                        SizedBox(width: 10),
                        Text(colorToString(color), style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (newColor) {
                  if (newColor != null) {
                    _changeThemeColor(newColor);
                  }
                },
                dropdownColor: MyColors().color6,
                underline: SizedBox(),
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              ),
            ),
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
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Icon(icon, color: iconColor, size: 28),
        title: Text(text, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        trailing: Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white, size: 28),
        onTap: onTap,
      ),
    );
  }

  String colorToString(Color color) {
    if (color == Colors.lightGreen) return "Light Green";
    if (color == Colors.blue) return "Blue";
    if (color == Colors.green) return "Green";
    if (color == Colors.pink) return "Pink";
    if (color == Colors.orange) return "Orange";
    return "Custom";
  }
}
