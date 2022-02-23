import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData.dark().copyWith(
      primaryColor: const Color(0xffF6265A),
      scaffoldBackgroundColor: const Color(0xff13131B),
    ),
    home: AgeCalculator(),
  ));
}

class AgeCalculator extends StatefulWidget {
  const AgeCalculator({Key? key}) : super(key: key);

  @override
  _AgeCalculatorState createState() => _AgeCalculatorState();
}

class _AgeCalculatorState extends State<AgeCalculator> {
  int chosenDate = 0, chosenMonth = 0, chosenYear = 0;
  String day = "", month = "", year = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Age Calculator"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
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
                findAge();
              },
              child: const Text("Choose Date"),
            ),
            const SizedBox(
              height: 25.0,
            ),
            Text(
              year + " " + month + " " + day,
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Future findAge() async {
    var date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    setState(() {
      chosenDate = int.parse(DateFormat("dd").format(date!));
      chosenMonth = int.parse(DateFormat("MM").format(date));
      chosenYear = int.parse(DateFormat("yyyy").format(date));

      int currDate = int.parse(DateFormat("dd").format(DateTime.now()));
      int currMonth = int.parse(DateFormat("MM").format(DateTime.now()));
      int currYear = int.parse(DateFormat("yyyy").format(DateTime.now()));

      int numberOfDays = findDays(currMonth, currYear);

      if (currDate - chosenDate >= 0) {
        day = (currDate - chosenDate).toString() + " days";
      } else {
        day = (currDate + numberOfDays - chosenDate).toString() + " days";
        currMonth--;
      }

      if (currMonth - chosenMonth >= 0) {
        month = (currMonth - chosenMonth).toString() + " months";
      } else {
        month = (currMonth + 12 - chosenMonth).toString() + " months";
        currYear--;
      }

      year = (currYear - chosenYear).toString() + " years";
    });
  }

  int findDays(int currMonth, int currYear) {
    if (currMonth == 1 ||
        currMonth == 3 ||
        currMonth == 5 ||
        currMonth == 7 ||
        currMonth == 8 ||
        currMonth == 10 ||
        currMonth == 12) {
      return 31;
    } else if (currMonth == 4 ||
        currMonth == 6 ||
        currMonth == 9 ||
        currMonth == 11) {
      return 30;
    } else {
      if (checkYear(currYear)) {
        return 29;
      } else {
        return 28;
      }
    }
  }

  bool checkYear(int year) {
    if (year % 400 == 0) return true;

    if (year % 100 == 0) return false;

    if (year % 4 == 0) return true;
    return false;
  }
}
