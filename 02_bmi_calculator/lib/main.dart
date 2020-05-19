import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = "Enter your weight and height";

  void _resetFields() {
    weightController.text = "";
    heightController.text = "";
    setState(() {
      _infoText = "Enter your weight and height";
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calculate() {
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text) / 100;
    double bmi = weight / (height * height);
    setState(() {
      if (bmi < 18.5) {
        _infoText =
            "Underweight (${bmi.toStringAsPrecision(3)}). Please, go eat something";
      } else if (bmi >= 18.5 && bmi <= 24.9) {
        _infoText = "Normal weight (${bmi.toStringAsPrecision(3)}). Good!";
      } else if (bmi >= 25 && bmi <= 29.9) {
        _infoText =
            "Overweight (${bmi.toStringAsPrecision(3)}). Look your weight, eat less garbage!";
      } else if (bmi >= 30) {
        _infoText = "Obesity (${bmi.toStringAsPrecision(3)}). Go to the gym!";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("BMI Calculator"),
          centerTitle: true,
          backgroundColor: Colors.deepOrangeAccent,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _resetFields,
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(
                    Icons.person_outline,
                    size: 125.0,
                    color: Colors.deepOrangeAccent,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Weight (kg)",
                        labelStyle: TextStyle(color: Colors.deepOrangeAccent)),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.deepOrangeAccent, fontSize: 25.0),
                    controller: weightController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter your weight";
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Height (cm)",
                        labelStyle: TextStyle(color: Colors.deepOrangeAccent)),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.deepOrangeAccent, fontSize: 25.0),
                    controller: heightController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter your height";
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: Container(
                      height: 50.0,
                      child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _calculate();
                            }
                          },
                          child: Text("Calculate",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 25.0)),
                          color: Colors.deepOrangeAccent),
                    ),
                  ),
                  Text(_infoText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.deepOrangeAccent, fontSize: 25.0)),
                ],
              ),
            )));
  }
}
