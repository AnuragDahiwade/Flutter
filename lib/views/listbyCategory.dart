import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/services/todoDatabase.dart';
import 'package:todo/views/HomeScreen.dart';
import 'package:todo/views/addTask.dart';
import 'package:todo/views/updateTask.dart';
import 'package:todo/views/calenderScreen.dart';
import 'package:todo/views/addCategory.dart';
import 'package:todo/views/listCategories.dart';

String categoryName = ""; 
class myListByCategory extends StatelessWidget {
  myListByCategory(String name){
    categoryName = name;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Column(
        children: [
          Row(
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6.0, 0, 6.0, 0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.blueGrey,
                        width: 4.0,
                      )),
                    ),
                  ),
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
          SizedBox(
            height: 8,
          ),
         Container(
          child: Text(
            " >> $categoryName", 
            textAlign: TextAlign.left, 
            style: TextStyle(
              fontSize: 22,
              
            ),
          ),
          alignment: Alignment.topLeft,
          ),
          Expanded(
            
            child: TileList(),
            
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                // Add your button functionality here
                Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => myHomeScreen()),
                    );
              },
              child: Image(
                image: AssetImage("assets/Images/list.png"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Add your button functionality here
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddTaskForm()));
              },
              child: Image(
                image: AssetImage("assets/Images/plus-circle.png"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Add your button functionality here
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

class TileList extends StatefulWidget {
  @override
  _TileListState createState() => _TileListState();
}

class _TileListState extends State<TileList> {
  List<String> _data = [
    'Item 1',
  ]; // Initial data


  final dbManager = DatabaseHelper();

  Future<void> _deleteItem(Database database, id) async {
    await database.transaction((txn) async {
      await txn.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: DatabaseHelper.getRecordByCategory(categoryName), // Fetch data from database
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final dataList = snapshot.data ?? [];

            return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final data = dataList[index];
                int thisTaskId = data['id'];
                DateTime startDate = DateTime.parse(data['startDate']);
                // String endDate = DateTime.parse(data['startDate']) as String;
                String Desc = data['description'];

                return ListTile(
                  title: Text(data['title']),
                  // subtitle: Text(startDate.toIso8601String()),
                  subtitle: Row(
                    children: [
                      Text("$Desc"),
                      SizedBox(width: 15,),
                      Text(startDate.toIso8601String(),
                      textAlign: TextAlign.right,
                      )

                    ]
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      Database database = await DatabaseHelper.initDb();
                      await _deleteItem(database, thisTaskId);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      // SnackBar(content: Text('Item deleted')));

                      // HomePage();
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => myHomeScreen()),
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateTaskForm(thisTaskId)),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
