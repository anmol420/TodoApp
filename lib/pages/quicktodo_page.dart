import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/components/floating_navigation.dart';
import 'package:todoapp/components/hamburger.dart';


class QuickToDo extends StatefulWidget {
  const QuickToDo({super.key});

  @override
  State<QuickToDo> createState() => _QuickToDoState();
}

class _QuickToDoState extends State<QuickToDo> {
  final List<Map<String, dynamic>> _todos = [];
  final TextEditingController _todoController = TextEditingController();
  bool _showCompleted = false;

  

  // Function to add a new task (adds to the top of the list)
  void _addTodo(String task) {
    if (task.trim().isEmpty) return;
    setState(() {
      DateTime now = DateTime.now();
      // Insert the new task at the beginning of the list
      _todos.insert(0, {
        'task': task.trim(),
        'done': false,
        'createdAt': now,
        'editedAt': null,
      });
      _todoController.clear();
    });
    Navigator.pop(context);
  }

  // Function to toggle the task's status (done or undone)
  void _toggleTodoStatus(int index) {
    setState(() {
      _todos[index]['done'] = !_todos[index]['done'];
      _todos[index]['editedAt'] = DateTime.now();  // Update edit time
    });
  }

  // Function to delete a task
  void _deleteTodo(int index) {
    final deletedTodo = _todos[index];
    setState(() {
      _todos.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Task deleted 🗑️"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _todos.insert(index, deletedTodo);
            });
          },
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Function to show the bottom sheet for adding a task
  void _showAddTodoBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.95),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(255, 182, 193, 0.3),
                  blurRadius: 30,
                  offset: Offset(0, -10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _todoController,
                  decoration: InputDecoration(
                    labelText: "What's on your mind? 💭",
                    labelStyle: TextStyle(color: Colors.lightBlueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () => _addTodo(_todoController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    foregroundColor: Colors.white,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  ),
                  child: Text("Add", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedTodos = _todos.where((todo) => todo['done']).toList();
    final incompleteTodos = _todos.where((todo) => !todo['done']).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      
      drawer: buildHamburgerDrawer(context),
     appBar: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  iconTheme: IconThemeData(color: Colors.deepOrange),
  centerTitle: true,
  title: Padding(
    padding: const EdgeInsets.only(top:8.0,bottom: 9.0),
    child: Image.asset(
     'lib/images/Todologo.png', // replace with your image path
      height: 150,
    ),
  ),
),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFFFF3E0)], // Pastel gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Text(
                  "QuickToDo",
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.deepOrangeAccent,
                  ),
                ),
                SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    children: [
                      ...incompleteTodos.map((todo) =>
                          _buildTodoTile(todo, _todos.indexOf(todo))),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showCompleted = !_showCompleted;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              _showCompleted
                                  ? Icons.keyboard_arrow_down_rounded
                                  : Icons.keyboard_arrow_right_rounded,
                              color: Colors.teal,
                              size: 28,
                            ),
                            Text(
                              "Completed (${completedTodos.length})",
                              style: GoogleFonts.quicksand(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: _showCompleted
                            ? Column(
                                key: ValueKey(true),
                                children: completedTodos
                                    .map((todo) => _buildTodoTile(todo, _todos.indexOf(todo)))
                                    .toList(),
                              )
                            : SizedBox.shrink(key: ValueKey(false)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoBottomSheet,
        backgroundColor: Colors.lightBlueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(Icons.add, color: Colors.white, size: 28),
      ),
      
        bottomNavigationBar: CustomBottomNavBar(),
         
        
    );
  }

  Widget _buildTodoTile(Map<String, dynamic> todo, int index) {
    return Dismissible(
      key: Key(todo.toString()),
      direction: DismissDirection.startToEnd,  // Swipe from left to right
      onDismissed: (_) => _deleteTodo(index),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        color: Colors.orangeAccent,
        child: Icon(Icons.delete_forever, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: () => _editTodo(index),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 6),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.85),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: todo['done']
                    ? Color.fromRGBO(0, 200, 180, 0.2)
                    : Color.fromRGBO(255, 105, 180, 0.15),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: todo['done'] ? Colors.teal : Colors.orangeAccent,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _toggleTodoStatus(index),
                    child: Icon(
                      todo['done']
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      color: todo['done'] ? Colors.teal : Colors.orangeAccent,
                      size: 26,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      todo['task'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: todo['done'] ? Colors.teal : Colors.black87,
                        decoration:
                            todo['done'] ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    "Created: ${DateFormat('yMMMd').format(todo['createdAt'])}",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  if (todo['editedAt'] != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "(Edited: ${DateFormat('yMMMd').format(todo['editedAt'])})",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to edit the task
  void _editTodo(int index) {
    _todoController.text = _todos[index]['task'];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.95),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(255, 182, 193, 0.3),
                  blurRadius: 30,
                  offset: Offset(0, -10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _todoController,
                  decoration: InputDecoration(
                    labelText: "Edit Task",
                    labelStyle: TextStyle(color: Colors.lightBlueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    if (_todoController.text.trim().isNotEmpty) {
                      setState(() {
                        _todos[index]['task'] = _todoController.text;
                        _todos[index]['editedAt'] = DateTime.now(); // Update edit time
                      });
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    foregroundColor: Colors.white,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  ),
                  child: Text("Update", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

