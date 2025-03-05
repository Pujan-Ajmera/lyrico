import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMePage extends StatelessWidget {
  AboutMePage({super.key});
  final List<String> artistImages = [
    'assets/theweeeknd.png',
    'assets/lana.png',
    'assets/doja.png',
    'assets/uzi.png',
    'assets/drake.png'
  ];

  final List<String> webSeriesImages = [
    'assets/money_heist.png',
    'assets/stranger_things.png',
    'assets/dark.png',
    'assets/got.png',
    'assets/breaking_bad.png'
  ];

  final List<String> artists = [
    'The Weeknd',
    'Lana Del Rey',
    'Doja Cat',
    'Lil Uzi Vert',
    'Drake'
  ];

  final List<String> webSeries = [
    'Money Heist',
    'Stranger Things',
    'Dark',
    'Game of Thrones',
    'Breaking Bad'
  ];
  final String url = "https://en.wikipedia.org/wiki/Cicada_3301";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Me', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Avatar
            GestureDetector(
              onTap: () => _launchURL(url),
              child:const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/cicida.png'), // Corrected filename
              ),
            ),
            const SizedBox(height: 16.0),
            // Personal Info
            _buildFullWidthCard('Full Name', 'Pujan Mukeshbhai Ajmera'),
            _buildFullWidthCard('Interests', 'Cinephile, Music Lover, Web Series Enthusiast'),
            _buildFullWidthCard('Gaming', 'Enjoys watching, not playing'),
            _buildFullWidthCard('Born in', 'Savarkundla, Gujarat'),
            _buildFullWidthCard('Education', 'Studied at Saint Thomas School'),

            // Favorite Web Series Section
            _buildSectionTitle('Favorite Web Series'),
            _buildWebSeriesList(),

            // Favorite Artists Section
            _buildSectionTitle('Favorite Artists'),
            _buildArtistList(),
          ],
        ),
      ),
      backgroundColor: Colors.orange[50],
    );
  }

  // Method to create full-width info cards
  Widget _buildFullWidthCard(String title, String content) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const SizedBox(height: 8.0),
            Text(
              content,
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  // Method to create section title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style:const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrange),
      ),
    );
  }

  // Method to build Web Series List
  Widget _buildWebSeriesList() {
    return Column(
      children: List.generate(webSeries.length, (index) => Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          width: double.infinity,
          height: 120,  // Increased height for better visibility
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  webSeriesImages[index],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  webSeries[index],
                  style:const TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  // Method to build Artist List
  Widget _buildArtistList() {
    return Column(
      children: List.generate(artists.length, (index) => Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin:const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(artistImages[index]),
                radius: 40,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  artists[index],
                  style:const TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      )),
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
}
