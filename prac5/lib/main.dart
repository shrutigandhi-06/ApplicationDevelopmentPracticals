import 'package:flutter/material.dart';
import 'ApiClient.dart';
import 'DropDown.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xffF6265A),
        scaffoldBackgroundColor: const Color(0xff13131B),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Instance of API Client
  ApiClient client = ApiClient();

  // Function to call API

  @override
  void initState() {
    super.initState();
    (() async {
      List<String> list = await client.getCurrencies();
      setState(() {
        currencies = list;
      });
    })();
  }

  //Setting the variables
  List<String> currencies = ["INR", "USD"];
  String from = "INR";
  String to = "USD";

  //variables for exchange rate
  double rate = 1;
  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 18.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200,
                child: const Text(
                  "Currency Converter",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        onChanged: (value) async {
                          rate = await client.getRate(from, to);
                          setState(() {
                            result =
                                (rate * double.parse(value)).toStringAsFixed(3);
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Input amount to convert",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18.0,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                        style: TextStyle(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customDropDown(currencies, from, (val) {
                            setState(() {
                              from = val;
                            });
                          }),
                          FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                String temp = from;
                                from = to;
                                to = temp;
                              });
                            },
                            child: const Icon(Icons.swap_horiz),
                            elevation: 0.0,
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          customDropDown(currencies, to, (val) {
                            setState(() {
                              to = val;
                            });
                          }),
                        ],
                      ),
                      const SizedBox(height: 50.0),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          children: [
                            Text(
                              result,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 36.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
