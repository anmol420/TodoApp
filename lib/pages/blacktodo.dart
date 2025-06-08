import 'package:flutter/material.dart';
import 'package:todoapp/components/bottom_navigation.dart';
import 'package:todoapp/components/hamburger.dart';
import 'package:todoapp/pages/category_todo.dart';
import 'package:todoapp/services/todo_service.dart';

class Blacktodo extends StatefulWidget {
  const Blacktodo({super.key});

  @override
  State<Blacktodo> createState() => _QuicktodoPageState();
}

class _QuicktodoPageState extends State<Blacktodo> {
  final List<Map<String, dynamic>> _todos = [];
  bool _showCompleted = false;
  Map<String, dynamic>? _recentlyDeleted;
  int _recentlyDeletedIndex = -1;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    try {
      final fetched = await TodoService.fetchTodos();
      setState(() {
        _todos
          ..clear()
          ..addAll([...fetched['notCompleted']!, ...fetched['completed']!]);
      });
    } catch (e) {
      throw("Error loading todos: $e");
    }
  }

  void _showAddTodoBottomSheet(
    BuildContext context,
    Function(Map<String, dynamic>) onAdd,
  ) {
    TextEditingController controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2E2E2E), Color(0xFF1C1C1C)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 25,
                    offset: Offset(0, -12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Text(
                    '📝 Add New Task',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter your task...',
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Color(0xFF2C2C2C),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          Icons.check_circle_rounded,
                          color: Colors.greenAccent,
                        ),
                        onPressed: () async {
                          String task = controller.text.trim();
                          if (task.isEmpty) return;
                          try {
                            final newTodo = await TodoService.createTodo(
                              task,
                              "",
                            );
                            onAdd({
                              'id': newTodo['id'],
                              'task': newTodo['task'],
                              'done': newTodo['done'],
                            });
                            if (context.mounted) Navigator.pop(context);
                          } catch (_) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Failed to add task"),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> get _incompleteTodos =>
      _todos.where((todo) => !todo['done']).toList();
  List<Map<String, dynamic>> get _completedTodos =>
      _todos.where((todo) => todo['done']).toList();

  void _toggleTodoStatus(int index, bool isCompletedList) async {
    final list = isCompletedList ? _completedTodos : _incompleteTodos;
    final todo = list[index];
    final newStatus = !todo['done'];
    try {
      await TodoService.toggleTodoStatus(todo['id'], newStatus);
      setState(() {
        todo['done'] = newStatus;
        _todos.sort((a, b) => a['done'] ? 1 : -1);
      });
    } catch (_) {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to toggle status"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _deleteTodo(Map<String, dynamic> todo) async {
    try {
      await TodoService.deleteTodo(todo['id']);
      setState(() {
        _recentlyDeletedIndex = _todos.indexOf(todo);
        _recentlyDeleted = todo;
        _todos.remove(todo);
      });
      if(!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task deleted'),
          action: SnackBarAction(
            label: 'UNDO',
            textColor: Colors.amber,
            onPressed: () {
              if (_recentlyDeleted != null) {
                setState(() {
                  _todos.insert(_recentlyDeletedIndex, _recentlyDeleted!);
                });
              }
            },
          ),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showEditTodoDialog(Map<String, dynamic> todo) {
    TextEditingController controller = TextEditingController(
      text: todo['task'],
    );
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Color(0xFF1C1C1C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Center(
              child: Text('Edit Task', style: TextStyle(color: Colors.white)),
            ),
            content: TextField(
              controller: controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Update your task',
                hintStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: Colors.redAccent),
              ),
              IconButton(
                onPressed: () async {
                  try {
                    await TodoService.updateTodo(
                      todo['id'],
                      controller.text.trim(),
                      "",
                    );
                    setState(() {
                      todo['task'] = controller.text.trim();
                    });
                    Navigator.pop(context);
                  } catch (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Failed to update"),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
                icon: Icon(Icons.check, color: Colors.greenAccent),
              ),
            ],
          ),
    );
  }

  Widget _buildTodoTile(
    Map<String, dynamic> todo,
    bool isCompletedList,
    int index,
  ) {
    return GestureDetector(
      onTap: () => _showEditTodoDialog(todo),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: todo['done'] ? Colors.greenAccent : Colors.redAccent,
            width: 2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                todo['task'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  decoration: todo['done'] ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            SizedBox(width: 12),
            GestureDetector(
              onTap: () => _toggleTodoStatus(index, isCompletedList),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                transitionBuilder:
                    (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                child: Icon(
                  todo['done']
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked,
                  key: ValueKey(todo['done']),
                  color: todo['done'] ? Colors.greenAccent : Colors.white38,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickTodosView() {
    final incomplete = _incompleteTodos;
    final completed = _completedTodos;

    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Quick ToDo\'s',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child:
                _todos.isEmpty
                    ? Center(
                      child: Text(
                        'No tasks yet!',
                        style: TextStyle(color: Colors.white54, fontSize: 18),
                      ),
                    )
                    : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        children: [
                          ReorderableListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: incomplete.length,
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                if (newIndex > oldIndex) newIndex -= 1;
                                final item = incomplete.removeAt(oldIndex);
                                incomplete.insert(newIndex, item);
                                _todos
                                  ..removeWhere((t) => !t['done'])
                                  ..insertAll(0, incomplete);
                              });
                            },
                            itemBuilder: (context, index) {
                              final todo = incomplete[index];
                              return Dismissible(
                                key: ValueKey(todo['task']),
                                direction: DismissDirection.startToEnd,
                                onDismissed: (_) => _deleteTodo(todo),
                                background: Container(
                                  padding: EdgeInsets.only(left: 20),
                                  alignment: Alignment.centerLeft,
                                  color: Colors.redAccent,
                                  child: Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                child: _buildTodoTile(todo, false, index),
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          if (completed.isNotEmpty)
                            ExpansionTile(
                              initiallyExpanded: _showCompleted,
                              onExpansionChanged:
                                  (expanded) =>
                                      setState(() => _showCompleted = expanded),
                              backgroundColor: Color(0xFF1E1E1E),
                              collapsedBackgroundColor: Color(0xFF2C2C2C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: Text(
                                'Completed Tasks (${completed.length})',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              children:
                                  completed
                                      .asMap()
                                      .entries
                                      .map(
                                        (entry) => _buildTodoTile(
                                          entry.value,
                                          true,
                                          entry.key,
                                        ),
                                      )
                                      .toList(),
                            ),
                        ],
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFF121212),
        drawer: buildHamburgerDrawer(context),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.deepOrange),
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 9.0),
            child: Image.asset('lib/images/Todologo.png', height: 150),
          ),
          bottom: TabBar(
            indicatorColor: Colors.deepOrangeAccent,
            labelColor: Colors.deepOrangeAccent,
            unselectedLabelColor: Colors.white60,
            tabs: [Tab(text: 'Quick Todos'), Tab(text: 'Category Todos')],
          ),
        ),
        body: TabBarView(children: [_buildQuickTodosView(), CategoryTodo()]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            _showAddTodoBottomSheet(context, (todo) {
              setState(() {
                _todos.insert(0, todo);
              });
            });
          },
          child: Icon(Icons.add, color: Colors.black),
        ),
        bottomNavigationBar: buildBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}
