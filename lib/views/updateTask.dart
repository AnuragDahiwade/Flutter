

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
      'title' : title,
      'description' : description,
      'startDate' : startDate.toIso8601String(),
      'endDate' : endDate.toIso8601String(),
      'status' : status,
      'category' : category,
      'priority' : priority
    };
  }
}

int? thisId;

class UpdateTaskForm extends StatefulWidget {
  UpdateTaskForm(int thisTaskId){
    thisId = thisTaskId;
  }

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<UpdateTaskForm> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  String _selectedStatus = 'Pending';
  String _selectedCategory = 'Work';
  String _selectedPriority = 'low';

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Call the method to fetch the record by its ID
    fetchRecordById(thisId!);
  }

  void fetchRecordById(int id) async {
    // Call the database helper method to get the record by its ID
    Map<String, dynamic>? record = await DatabaseHelper.getRecordById(id);
    if (record != null) {
      // Update the form fields with the fetched data
      setState(() {
        _titleController.text = record['title'];
        _descriptionController.text = record['description'];
        _startDate = record['startDate'];
      });
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Task'),
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
                              text: '${_startDate.day}/${_startDate.month}/${_startDate.year}'),
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
                              text: '${_endDate.day}/${_endDate.month}/${_endDate.year}'),
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
                items: <String>['Work', 'Personal', 'Study']
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

                  Task task = Task(title: _titleController.text, description: _descriptionController.text, startDate: _startDate, endDate: _endDate, status: _selectedStatus, category: _selectedCategory, priority: _selectedPriority);
                  Database database = await DatabaseHelper.initDb();
                      DatabaseHelper.updateTask(task.toMap());
                      await ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Data saved to SQLite')));
                      
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => myHomeScreen()),
                    );
                },
                child: Text('Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}