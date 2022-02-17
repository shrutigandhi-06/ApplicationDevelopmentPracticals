import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyThreeViews extends StatefulWidget {
  @override
  _MyThreeViewsState createState() => _MyThreeViewsState();
}

class _MyThreeViewsState extends State<MyThreeViews> {
  @override
  Widget build(BuildContext context) {
    ///This screen contains grid view of cards which consists images

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grid, Card, and Image Views'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: 4,
            itemBuilder: (BuildContext ctx, index) {
              return Card(
                color: Colors.transparent,
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: const [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Image(
                            image: AssetImage('images/sample_img.jpg'),
                          ),
                        ),
                      ),
                      //
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
