import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/services/todoDatabase.dart';
import 'package:todo/views/HomeScreen.dart';
import 'package:todo/views/addTask.dart';
import 'package:todo/views/updateTask.dart';
import 'package:todo/views/calenderScreen.dart';
import 'package:todo/views/addCategory.dart';
import 'package:todo/views/listCategories.dart';

int thisTaskId = 0;

class myViewTaskScreen extends StatelessWidget {
  myViewTaskScreen(int t) {
    thisTaskId = t;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbManager = DatabaseHelper();

  Future<void> _deleteItem(Database database, id) async {
    await database.transaction((txn) async {
      await txn.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => addCategory()));
                  },
                  child: Image(
                    image: AssetImage("assets/Images/folder-plus.png"),
                  ),
                ),
                Expanded(
                  
                  child: Container(
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image(
                      image: AssetImage("assets/Images/pandaBgRemove.png"),
                      width: 150,
                      height: 30,
                      )
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add your button functionality here
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => myCategoryScreen()));
                  },
                  child: Image(
                    image: AssetImage("assets/Images/grip.png"),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: MyTask(thisTaskId),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => myHomeScreen()));
              },
              child: Image(
                image: AssetImage("assets/Images/list.png"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddTaskForm()));
              },
              child: Image(
                image: AssetImage("assets/Images/plus-circle.png"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => calenderScreen()));
              },
              child: Image(
                image: AssetImage("assets/Images/calendar-days.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyTask extends StatefulWidget {
  MyTask(int id) {
    thisTaskId = id;
  }
  @override
  _TileListState createState() => _TileListState();
}

class _TileListState extends State<MyTask> {
  String title = "title";
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String Desc = "Desc";
  String status = "";
  String category = "";
  String priority = "";

  final dbManager = DatabaseHelper();

  Future<void> _deleteItem(Database database, id) async {
    await database.transaction((txn) async {
      await txn.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Single Data from SQLite Database'),
      // ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: DatabaseHelper.getRecordById(thisTaskId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('No data found.'));
          } else {
            Map<String, dynamic> data = snapshot.data!;
            return ListTile(
              // title: Text(data['name']),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        data['title'],
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "Start-Date :   ",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              data['startDate'],
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      )),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: 70,
                      ),
                      child: Text(
                        data['description'],
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30,),

                   Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "Status :   ",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              data['status'],
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      )),

                       Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "Category :   ",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              data['category'],
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      )),

                       Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "Priority :   ",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              data['priority'],
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      )),


                  SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateTaskForm(thisTaskId)));
                        },
                        child: Text("Update",
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Database database = await DatabaseHelper.initDb();
                          await _deleteItem(database, thisTaskId);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => myHomeScreen()),
                          );
                        },
                        child: Text("Delete",
                          style: TextStyle(
                            color: Color.fromARGB(255, 228, 90, 80),
                            
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
