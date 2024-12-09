import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'shoe_model.dart';
import 'shoe_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Toko Sepatu"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShoeDetailScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore.collection('shoes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Tidak ada sepatu tersedia.'));
          }

          // Konversi dokumen Firestore ke model `Shoe`
          var shoes = snapshot.data!.docs
              .map((doc) => Shoe.fromFirestore(doc))
              .toList();

          return ListView.builder(
            itemCount: shoes.length,
            itemBuilder: (ctx, index) {
              return ListTile(
                title: Text(shoes[index].name),
                subtitle: Text("${shoes[index].brand} - \$${shoes[index].price}"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShoeDetailScreen(shoe: shoes[index]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
