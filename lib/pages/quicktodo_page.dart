import 'package:flutter/material.dart';

class QuicktodoPage extends StatefulWidget {
  const QuicktodoPage({super.key});

  @override
  State<QuicktodoPage> createState() => _QuicktodoPageState();
}

class _QuicktodoPageState extends State<QuicktodoPage> {
  final List<Map<String, dynamic>> _todos=[
    {'task': 'hope it works', 'done': false},
    {'task': 'it will work surely', 'done': false},
  ];
  void _showAddTodoDialog() {
    TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context){
        return Center(
          child: AlertDialog(
            backgroundColor: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Center(
              child: Text(
                'Add New Task',
                style: TextStyle(color: Colors.white),
              ),
            ),
            content: TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter your task',
                hintStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            actions: [
              
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, child: Icon(Icons.close, color: Colors.red),
                  ),
              
                TextButton(
                    onPressed: () {
                      String task = _controller.text.trim();
                      if (task.isNotEmpty){
                        setState(() {
                          _todos.add({'task': task, 'done': false});
                        });
                      }
                      Navigator.pop(context);
                    },
                     child:Icon(Icons.check,color: Colors.green),
                     ),
               
            ],
          ),
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Center(
                  child: Text(
                    'Quick ToDo\'s',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
                ),
                Expanded(
                  child: _todos.isEmpty
                  ? Center(
                    child: Text(
                      'No tasks yet!',
                      style: TextStyle(color: Colors.white54,fontSize: 18),
                    ),
                  )
                  : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      final todo = _todos[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          todo['task'],
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      );
                    },
                  ),
                ),
            ],

          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: _showAddTodoDialog,
          child: Icon(Icons.add, color: Colors.black),
          ),


      );

    
  }
}