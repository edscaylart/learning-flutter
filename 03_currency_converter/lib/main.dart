import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key={{YOUR_KEY}}";

void main() async {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData(
        hintColor: Colors.deepPurple,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.deepPurple,
            )),
            hintStyle: TextStyle(color: Colors.deepPurple)),
      )));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final libraController = TextEditingController();

  double dolar;
  double euro;
  double libra;

  void _clearAll() {
    realController.text = '';
    dolarController.text = '';
    euroController.text = '';
    libraController.text = '';
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
    libraController.text = (real / libra).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = ((dolar * this.dolar) / euro).toStringAsFixed(2);
    libraController.text = ((dolar * this.dolar) / libra).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = ((euro * this.euro) / dolar).toStringAsFixed(2);
    libraController.text = ((euro * this.euro) / libra).toStringAsFixed(2);
  }

  void _libraChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double libra = double.parse(text);
    realController.text = (libra * this.libra).toStringAsFixed(2);
    euroController.text = ((libra * this.libra) / euro).toStringAsFixed(2);
    dolarController.text = ((libra * this.libra) / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Currency Converter",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              size: 25.0,
              color: Colors.white,
            ),
            onPressed: _clearAll,
          )
        ],
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Loading... please wait",
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Ooops.. something went wrong -__-",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              Map currencies = snapshot.data['results']['currencies'];
              dolar = currencies['USD']['buy'];
              euro = currencies['EUR']['buy'];
              libra = currencies['GBP']['buy'];

              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Currency(
                            price: dolar,
                            title: 'USD DÓLAR',
                          ),
                          Currency(
                            price: euro,
                            title: 'EUR EURO',
                          ),
                          Currency(
                            price: libra,
                            title: 'GBP LIBRA',
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(Icons.monetization_on,
                          size: 150.0, color: Colors.deepPurple),
                    ),
                    buildTextField(
                        "Real", "R\$ ", realController, _realChanged),
                    Divider(),
                    buildTextField(
                        "US Dollar", "\$ ", dolarController, _dolarChanged),
                    Divider(),
                    buildTextField("Euro", "€ ", euroController, _euroChanged),
                    Divider(),
                    buildTextField("GBP", "£ ", libraController, _libraChanged),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController ctlr, Function fn) {
  return TextField(
    controller: ctlr,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.deepPurple),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(fontSize: 25.0),
    onChanged: fn,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}

class Currency extends StatelessWidget {
  String title;
  double price;

  Currency({this.title, this.price});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          "R\$ ${price.toStringAsPrecision(3)}",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        Text(title)
      ],
    );
  }
}
