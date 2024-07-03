// lib/main.dart

import 'package:flutter/material.dart';
import 'api_service.dart';
import 'crypto_model.dart';

void main() {
  runApp(CryptoPriceApp());
}

class CryptoPriceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Prices',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CryptoPriceScreen(),
    );
  }
}

class CryptoPriceScreen extends StatefulWidget {
  @override
  _CryptoPriceScreenState createState() => _CryptoPriceScreenState();
}

class _CryptoPriceScreenState extends State<CryptoPriceScreen> {
  late Future<List<Crypto>> futureCryptos;

  @override
  void initState() {
    super.initState();
    futureCryptos = ApiService().fetchCryptos();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Harga CRYPTO',
          style: TextStyle(
            color: Colors.grey[988],
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),),
      ),
      body: FutureBuilder<List<Crypto>>(
        future: futureCryptos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load cryptos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No cryptos found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Crypto crypto = snapshot.data![index];
                return ListTile(
                  title: Text(crypto.name),
                  subtitle: Text(crypto.symbol),
                  trailing: Text('\$${crypto.priceUsd.toStringAsFixed(2)}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
