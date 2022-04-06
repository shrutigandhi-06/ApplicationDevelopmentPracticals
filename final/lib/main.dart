import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sharing_codelab/model/photos_library_api_model.dart';
import 'package:sharing_codelab/pages/home_page.dart';

void main() {
  final apiModel = PhotosLibraryApiModel();
  apiModel.signInSilently();
  runApp(
    ScopedModel<PhotosLibraryApiModel>(
      model: apiModel,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final ThemeData _theme = _buildTheme();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Field Trippa',
      theme: _theme,
      home: const HomePage(),
    );
  }
}

ThemeData _buildTheme() {
  final base = ThemeData.light().copyWith(
    primaryColor: Colors.white,
    primaryTextTheme: Typography.blackMountainView,
    primaryIconTheme: const IconThemeData(
      color: Colors.grey,
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
      primary: Colors.green[800], // foreground
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    )),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      primary: Colors.green[800],
    )),
    scaffoldBackgroundColor: Colors.white,
  );
  return base.copyWith(
      colorScheme: base.colorScheme.copyWith(secondary: Colors.green[800]));
}
