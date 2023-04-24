import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:io';

import 'dart:convert';
import 'dart:io';
import 'dart:async';

//import '../utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        //title: 'Startup Name Generato',
        theme: new ThemeData(
          // Add the 3 lines from here...
          primaryColor: Colors.white,
        ), // ... to here.
        home: new TableBasicsExample(),
        routes: {
          'add': (context) {
            return AddPage();
          },
          // 'list': (context) {
          //  return
          //}
        });
  }
}

class AddPage extends StatefulWidget {
  @override
  State<AddPage> createState() => AddPageState();
}

class AddPageState extends State<AddPage> {
  late String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Record a New Exercise"),
        ),
        body: Center(
            child: Column(
          children: [
            ElevatedButton.icon(
              //button 1: search API list
              onPressed: () {
                navigateAndDisplaySelection(context);
                //print('Good');
              },
              icon: Icon(
                Icons.search,
                size: 24.0,
              ),
              label: Text('Choose a type'), // <-- Text
            ),
            SizedBox(
              height: 20, // <-- SEE HERE
            ),
            SizedBox(
              // <-- SEE HERE
              width: 200,
              child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter time (minutes)',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (String value) {
                    setState(() {
                      text = value;
                      print(text);
                    });
                  }),
            ),
            SizedBox(
              height: 20, // <-- SEE HERE
            ),
            ElevatedButton.icon(
              //button 2: receive API response
              onPressed: () {},
              icon: Icon(
                Icons.calculate,
                size: 24.0,
              ),
              label: Text('Click to calculate'), // <-- Text
            ),
          ],
        )));
  }

  void navigateAndDisplaySelection(BuildContext context) async {
    String result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ScreenList()));
    print(result);

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$result has been chosen!')));
    // After list returns a result, hide any previous snackbars and show the new result.
  }
}

class ScreenList extends StatefulWidget {
  @override
  State<ScreenList> createState() => ScreenListState();
}

class ScreenListState extends State<ScreenList> {
  late List<String> books;

  void initState() {
    super.initState();
    books = [];
    getExercises();
  }

  void updateList(String book) {
    setState(() {
      books.add(book);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Choose an Exercise"),
        ),
        body: ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            if (index.isOdd) {
              return new Divider();
            }

            return ListTile(
                title: Text(books[index]),
                onTap: () {
                  Navigator.pop(
                      context, books[index]); //Tap a list will pop back
                });
          },
        ));
  }

  Future<void> getExercises() async {
    final url =
        Uri.parse('https://api.api-ninjas.com/v1/caloriesburnedactivities');
    final response = await http.get(url, headers: {
      //HttpHeaders.authorizationHeader:
      "X-Api-Key": 'uRjfZZXLL9spD046C1KZxI30ZaI3CFESdPORSuRp'
    });
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      final activities = jsonResponse['activities'];
      for (int i = 0; i < activities.length; i++) {
        try {
          String title = activities[i];
          updateList(title);
        } catch (e) {
          print('Exception thrown: $e');
        }
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}

class TableBasicsExample extends StatefulWidget {
  @override
  TableBasicsExampleState createState() => TableBasicsExampleState();
}

class TableBasicsExampleState extends State<TableBasicsExample> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TableCalendar - Basics'),
        actions: <Widget>[
          // Add 3 lines from here...
          new IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, 'add');
            },
          ),
          //onPressed: addNew), //list icon to push next page
        ], // ... to here.
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2022, 10, 1),
        lastDay: DateTime.utc(2023, 10, 1),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          // Use `selectedDayPredicate` to determine which day is currently selected.
          // If this returns true, then `day` will be marked as selected.

          // Using `isSameDay` is recommended to disregard
          // the time-part of compared DateTime objects.
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            // Call `setState()` when updating the selected day
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            // Call `setState()` when updating calendar format
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          _focusedDay = focusedDay;
        },
      ),
    );
  }

/*  void addNew() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        // Add 20 lines from here...
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
            (WordPair pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return new Scaffold(
            // Add 6 lines from here...
            appBar: new AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          ); // ... to here.
        },
      ), // ... to here.
    );
  }*/
}
