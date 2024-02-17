import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/services/todoDatabase.dart';
import 'package:flutter/material.dart';
import 'package:todo/views/HomeScreen.dart';
// import 'package:provider/provider.dart';

// Mock database model
class Task {
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String category;
  final String priority;

  Task({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.category,
    required this.priority,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
      'category': category,
      'priority': priority
    };
  }
}

class AddTaskForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TaskForm(),
    );
  }
}

class TaskForm extends StatefulWidget {
  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  String _selectedStatus = 'Pending';
  String _selectedCategory = 'all';
  String _selectedPriority = 'low';


  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  List<String> _categories = ['all'];
  

  @override
  void initState() {
    super.initState();
    _populateNames();
  }

  Future<void> _populateNames() async {
    List<String> names = await DatabaseHelper.getGategoriesList();
    setState(() {
      _categories = _categories + names;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> names = [];
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, true),
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Start Date',
                          ),
                          controller: TextEditingController(
                              text:
                                  '${_startDate.day}/${_startDate.month}/${_startDate.year}'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, false),
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'End Date',
                          ),
                          controller: TextEditingController(
                              text:
                                  '${_endDate.day}/${_endDate.month}/${_endDate.year}'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text('Status'),
              DropdownButton<String>(
                value: _selectedStatus,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue!;
                  });
                },
                items: <String>['Pending', 'In Progress', 'Completed']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

              
              SizedBox(height: 16.0),
              Text('Category'),
              DropdownButton<String>(
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
               
                items: _categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),


              SizedBox(height: 16.0),
              Text('Priority'),
              DropdownButton<String>(
                value: _selectedPriority,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPriority = newValue!;
                  });
                },
                items: <String>['low', 'high', 'imp']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  // Implement your add task functionality here
                  // _startDate = _startDate.toString();
                  // _endDate = DateTime.parse(_endDate as String);

                  Task task = Task(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      startDate: _startDate,
                      endDate: _endDate,
                      status: _selectedStatus,
                      category: _selectedCategory,
                      priority: _selectedPriority);
                  Database database = await DatabaseHelper.initDb();
                  DatabaseHelper.insertTask(task.toMap());
                  await ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Data saved to SQLite')));

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => myHomeScreen()),
                  );
                },
                child: Text('Add Task',
                  style: TextStyle(
                    color: Colors.green,
                    
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
