import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:io';

import 'dart:convert';
import 'dart:async';
//import 'home.dart';

import 'globals.dart' as globals;
import 'package:path_provider/path_provider.dart';

//import '../utils.dart';

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  String resultt = 's'; //initialize?

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Record a New Exercise"),
        ),
        body: Center(
            child: Column(
          children: [
            SizedBox(
              height: 20, // <-- SEE HERE
            ),
            ElevatedButton.icon(
              //button 1: search API list
              onPressed: () {
                navigateAndDisplaySelection(context);
              },
              icon: Icon(
                Icons.search,
                size: 24.0,
              ),
              label: Text(
                "Choose a type",
                style: TextStyle(fontSize: 18.0),
              ),
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
                      globals.gText = value;
                      print(text);
                    });
                  }),
            ),
            SizedBox(
              height: 20, // <-- SEE HERE
            ),
            ElevatedButton.icon(
              //button 2: receive API response
              onPressed: () {
                getCalories();
              },
              icon: Icon(
                Icons.calculate,
                size: 24.0,
              ),
              label: Text(
                "Click to calculate",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            SizedBox(
              height: 70, // <-- SEE HERE
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(width: 5, color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: const Text(
                "                               Reminder\nPlease follow the sequence:\n1. Choose a type\n2. Enter exercise time in mins\n3. Click to calculate calories burned\n4. Save the record and go back to home page",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        saveRecord(
                            globals.dayy, globals.gExercise, globals.gCalories);
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.save,
                        size: 24.0,
                      ),
                      label: Text(
                        "Save",
                        style: TextStyle(fontSize: 30.0),
                      ), // <-- Text
                    ))),
            SizedBox(
              height: 20, // <-- SEE HERE
            ),
          ],
        )));
  }

  void saveRecord(String day, String exercise, int calo) async {
    List<Player> players = [];
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    String filePath = '${appDocDir.path}/record.json';
    print(filePath);

    //  new File(filePath).readAsString().then((String contents) {
    //    print(contents);
    //  });

    final File file = File(filePath); //load the json file
    globals.gFile = file;
    Player newPlayer = Player(
        //add a new item to data list
        day,
        exercise,
        calo);

    players.add(newPlayer);
    print(players.length);

    players //convert list data  to json
        .map(
          (player) => player.toJson(),
        )
        .toList();

    file.writeAsStringSync(
      json.encode(players),
    );
    //     mode: FileMode.append); //write (the whole list) to json file
  }

  Future<void> getCalories() async {
    print(resultt);
    final url = Uri.parse(
        'https://api.api-ninjas.com/v1/caloriesburned?activity=$resultt&duration=$text');
    final response = await http.get(url,
        headers: {"X-Api-Key": 'uRjfZZXLL9spD046C1KZxI30ZaI3CFESdPORSuRp'});
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      int calories = jsonResponse[0]['total_calories'];
      print(calories);
      globals.gCalories = calories;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("Calculation Finished"),
                content: Text("Your burned calories are $calories kcal."),
                actions: [
                  TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ]);
          });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void navigateAndDisplaySelection(BuildContext context) async {
    //connect API to get list to select
    String result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ScreenList()));
    if (!mounted) return;
    globals.gExercise = result;
    resultt = result[0];
    print(result);

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$result is chosen!')));
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
      //  print(jsonResponse);
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
        title: Text('Burn It Up'),
        leading: IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Text("Instructions"),
                      content: Text(
                          "To start with, please select a date and press '+' to record a new exercise.\n\nWhen finished recording, click on the date will show you the record."),
                      actions: [
                        TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ]);
                });
          },
          icon: Icon(Icons.help),
        ),
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
          // globals.dayy = "$day";
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            // Call `setState()` when updating the selected day
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              //   print(selectedDay);
              globals.dayy = "$selectedDay";
              // print(globals.dayy);
              readRecord(globals.gFile);
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

  Future<void> readRecord(File file) async {
    String contents = await file.readAsString();
    // print('$contents');
    var jsonResponse = jsonDecode(contents);
    print(jsonResponse);

    for (var p in jsonResponse) {
      if (p['date'] == globals.dayy) {
        String k = p['date'];
        int i = globals.gCalories;
        String j = globals.gExercise;
        String h = globals.gText;

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text("On $k:"),
                  content: Text(
                      "Your burned $i kcal by doing $j for $h minutes. Well done!"),
                  actions: [
                    TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ]);
            });
        //print(p['date']);
      }
      //  Player player = Player(p['date'], p['exercise'], p['calories']);
      //   print(p['date']); //, p['exercise'], p['calories']);
      //players.add(player);
    }
  }
}

class Player {
  late String date;
  late String exercise;
  late int calories;

  Player(
    this.date,
    this.exercise,
    this.calories,
  );

  Player.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    exercise = json['exercise'];
    calories = json['calories'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['exercise'] = this.exercise;
    data['calories'] = this.calories;

    return data;
  }
}

/*late UsersPodo _usersPodo; // Users object to store users from json

// A function that converts a response body into a UsersPodo
UsersPodo parseJson(String responseBody) {
  final parsed = json.decode(responseBody);
  return UsersPodo.fromJson(parsed);
}

class Demo extends StatefulWidget {
  @override
  _Demo createState() => _Demo();
}

class _Demo extends State<Demo> {
  final String localJson = '''
  {
    "users": [
        {
            "id": 1,
            "username": "steve",
            "password": "captainamerica"
        }
    ]
}'''; // local json string

  Future<UsersPodo> fetchJSON() async {
    return compute(parseJson, localJson);
  }

  Widget body() {
    return FutureBuilder<UsersPodo>(
      future: fetchJSON(),
      builder: (context, snapshot) {
        return snapshot.hasError
            ? Center(child: Text(snapshot.error.toString()))
            : snapshot.hasData
                ? _buildBody(usersList: snapshot.data)
                : Center(child: Text("Loading"));
      },
    );
  }

  Widget _buildBody({UsersPodo usersList}) {
    _usersPodo = usersList;

    _usersPodo.users.add(new Users(
        id: 1,
        username: "omishah",
        password: "somepassword")); // add new user to users array////////////////////////////////////

    return Text(
        _usersPodo.users[1].toJson().toString()); // just for the demo output

    // use _usersPodo.toJson() to convert the users object to json
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff3f3f3),
        appBar: AppBar(backgroundColor: Colors.red[900], title: Text("DEMO")),
        body: body());
  }
}

// PODO Object class for the JSON mapping
class UsersPodo {
  late List<Users> users;
  UsersPodo({required this.users});

  UsersPodo.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = new List.filled<Users>();
      json['users'].forEach((v) {
        users.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  late int id;
  late String username;
  late String password;

  Users({required this.id, required this.username, required this.password});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['password'] = this.password;
    return data;
  }
}*/
