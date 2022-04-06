import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _countryController = TextEditingController();

  addCountry() {
    FirebaseFirestore.instance
        .collection('students')
        .doc(_countryController.value.text)
        .set({'name': _countryController.value.text});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff13131B),
      appBar: AppBar(
        title: const Text('Firebase Demo'),
        backgroundColor: const Color(0xffF6265A),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextField(
                      cursorColor: Colors.white,
                      controller: _countryController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Color(0xffF6265A)),
                    onPressed: () {
                      addCountry();
                      _countryController.clear();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('students').snapshots(),
              builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Text("Loading");
                } else {
                  return ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((document) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          title: Text(
                            document['name'],
                            style: const TextStyle(color: Color(0xffF6265A)),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  print(document['name']);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        TextEditingController _controller =
                                            TextEditingController();
                                        return AlertDialog(
                                          backgroundColor:
                                              const Color(0xff13131B),
                                          content: Container(
                                            width: 260.0,
                                            height: 230.0,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              color: Color(0xFFFFFF),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0)),
                                            ),
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextField(
                                                    controller: _controller,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                    cursorColor: Colors.white,
                                                    decoration:
                                                        const InputDecoration(
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary: const Color(
                                                                0xffF6265A)),
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'students')
                                                          .doc(document['name'])
                                                          .update({
                                                        'name': _controller
                                                            .value.text
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Update'),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.grey),
                                onPressed: () {
                                  print(document['name']);
                                  FirebaseFirestore.instance
                                      .collection('countries')
                                      .doc(document['name'])
                                      .delete();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
