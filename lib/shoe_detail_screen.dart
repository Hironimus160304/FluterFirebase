import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'shoe_model.dart';

class ShoeDetailScreen extends StatefulWidget {
  final Shoe? shoe;
  ShoeDetailScreen({this.shoe});

  @override
  _ShoeDetailScreenState createState() => _ShoeDetailScreenState();
}

class _ShoeDetailScreenState extends State<ShoeDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.shoe != null) {
      _nameController.text = widget.shoe!.name;
      _brandController.text = widget.shoe!.brand;
      _priceController.text = widget.shoe!.price.toString();
      _imageUrlController.text = widget.shoe!.imageUrl;
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      if (widget.shoe == null) {
        await FirebaseFirestore.instance.collection('shoes').add({
          'name': _nameController.text,
          'brand': _brandController.text,
          'price': double.parse(_priceController.text),
          'imageUrl': _imageUrlController.text,
        });
      } else {
        await FirebaseFirestore.instance.collection('shoes').doc(widget.shoe!.id).update({
          'name': _nameController.text,
          'brand': _brandController.text,
          'price': double.parse(_priceController.text),
          'imageUrl': _imageUrlController.text,
        });
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shoe == null ? 'Tambah Sepatu' : 'Edit Sepatu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama Sepatu'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama sepatu tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _brandController,
                decoration: InputDecoration(labelText: 'Merek Sepatu'),
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Harga Sepatu'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'URL Gambar Sepatu'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text(widget.shoe == null ? 'Tambah Sepatu' : 'Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
