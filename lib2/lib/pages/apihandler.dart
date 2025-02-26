// import 'dart:convert';
// // import 'package:api/utils/api2cardscreen.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:lyrics_app/pages/model.dart';
//
// // import '../model/api2model.dart';
//
// class ProductListScreen extends StatefulWidget {
//   @override
//   _ProductListScreenState createState() => _ProductListScreenState();
// }
//
// class _ProductListScreenState extends State<ProductListScreen> {
//   List<Model> model = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();
//   }
//
//   Future<void> fetchProducts() async {
//     // you can replace your api link with this link
//     final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));
//     if (response.statusCode == 200) {
//       List<dynamic> jsonData = json.decode(response.body);
//       setState(() {
//         model = jsonData.map((data) => Model.fromJson(data)).toList();
//       });
//     } else {
//       // Handle error if needed
//     }
//   }
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Product List'),
//       ),
//       body: ListView.builder(
//         // this give th length of item
//         itemCount: products.length,
//         itemBuilder: (context, index) {
//           // here we card the card widget
//           // which is in utils folder
//           return ProductCard(product: products[index]);
//         },
//       ),
//     );
//   }
// }
