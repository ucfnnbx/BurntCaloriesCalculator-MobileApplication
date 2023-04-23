import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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
          }
        });
  }
}

class AddPage extends StatefulWidget {
  @override
  State<AddPage> createState() => AddPageState();
}

class AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Record a New Exercise"),
      ),
      /* body: Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'third');
                },
                child: Text('Go forward!')))*/
    );
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
