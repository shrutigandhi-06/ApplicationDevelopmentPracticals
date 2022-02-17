import 'package:flutter/material.dart';
import 'package:prac7/stack.dart';
import 'package:prac7/threeview.dart';
import 'package:prac7/tabview.dart';
import 'package:prac7/webview.dart';

void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> views = [
    'GridView, CardView, and ImageView',
    'TabView',
    'WebView',
    'Stack'
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/TabView': (context) => TabView(),
        '/MyThreeViews': (context) => MyThreeViews(),
        '/webView': (context) => webView(),
        '/stack': (context) => stack(),
      },
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xffF6265A),
        scaffoldBackgroundColor: const Color(0xff13131B),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Flutter Views')),
          backgroundColor: const Color(0xffF6265A),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),

          ///ListView Implementation
          child: ListView.builder(
            itemCount: views.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    switch (views[index]) {
                      case "TabView":
                        Navigator.pushNamed(context, '/TabView');
                        break;
                      case 'GridView, CardView, and ImageView':
                        Navigator.pushNamed(context, '/MyThreeViews');
                        break;
                      case 'WebView':
                        Navigator.pushNamed(context, '/webView');
                        break;
                      case 'Stack':
                        Navigator.pushNamed(context, '/stack');
                        break;
                    }
                  },
                  child: Text(views[index]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
