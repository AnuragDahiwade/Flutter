import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/services/todoDatabase.dart';
import 'package:todo/views/HomeScreen.dart';
import 'package:todo/views/listCategories.dart';

class Category {
  final String categoryname;

  Category({required this.categoryname});

  Map<String, dynamic> toMap() {
    return {'categoryname': categoryname};
  }
}


class addCategory extends StatefulWidget {
  @override
  _addCategoryForm createState() => _addCategoryForm();
}


class _addCategoryForm extends State<addCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                  Category task = Category(categoryname: _nameController.text);

                  Database database = await DatabaseHelper.initDb();
                      DatabaseHelper.insertCategory(task.toMap());
                      await ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Data saved to SQLite')));

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => myCategoryScreen()),
                  );
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}

