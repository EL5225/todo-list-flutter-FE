import 'package:flutter/material.dart';
import 'package:todo_list_app/add_todo.dart';
import 'package:todo_list_app/edit_todo.dart';
import 'package:todo_list_app/services/api_calls.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MaterialApp(
    home: TodoApp(),
  ));
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  late Future<dynamic> _getTodos;

  @override
  void initState() {
    super.initState();
    _getTodos = getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Todo List App",
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.deepOrange[400],
      ),
      body: FutureBuilder<dynamic>(
        future: _getTodos,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            final items = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 60),
              itemCount: items["data"].length!,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          items["data"][index]["title"],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              decoration: items["data"][index]['is_done']
                                  ? TextDecoration.lineThrough
                                  : null),
                        ),
                        Text(
                          items["data"][index]['is_done']
                              ? DateTime.tryParse(
                                      items["data"][index]["created_at"])
                                  .toString()
                                  .split(".")[0]
                                  .split(" ")[0]
                              : DateTime.tryParse(
                                      items["data"][index]["updated_at"])
                                  .toString()
                                  .split(".")[0]
                                  .split(" ")[0],
                          style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    leading: IconButton(
                      icon: Icon(
                        items["data"][index]['is_done']
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        size: 25,
                      ),
                      onPressed: () async {
                        await doneTodo(items["data"][index]['id']);
                        setState(() {
                          _getTodos = getTodos();
                        });
                      },
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            size: 25,
                          ),
                          onPressed: () async {
                            await deleteTodo(items["data"][index]['id']);
                            setState(() {
                              _getTodos = getTodos();
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            size: 25,
                          ),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EditTodo(id: items["data"][index]['id']),
                              ),
                            );
                            setState(() {
                              _getTodos = getTodos();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange[400],
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTodo()),
          );
          setState(() {
            _getTodos = getTodos();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
