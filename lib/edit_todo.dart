import 'package:flutter/material.dart';
import 'package:todo_list_app/services/api_calls.dart';

class EditTodo extends StatefulWidget {
  const EditTodo({super.key, required this.id});

  final String id;

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  final _formKey = GlobalKey<FormState>();

  late Future<dynamic> _todo;

  String title = "";

  @override
  void initState() {
    super.initState();
    _todo = getTodoById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Todo",
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.deepOrange[400],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Form(
            key: _formKey,
            child: FutureBuilder(
              future: _todo,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final todo = snapshot.data!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        initialValue: todo["data"]["title"],
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              gapPadding: BorderSide.strokeAlignCenter,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          labelText: "Todo",
                          prefixIcon: Icon(Icons.add_task_sharp),
                          hintText: "Masukkan Todo hari ini",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onChanged: (value) => {title = value},
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async => {
                          if (title == "")
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      const Text("Todo harus ada perubahan!"),
                                  backgroundColor: Colors.red[600],
                                ),
                              )
                            }
                          else
                            {
                              await updateTodo(widget.id, title),
                              if (context.mounted)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text("Edit Todo Berhasil!"),
                                    backgroundColor: Colors.green[700],
                                  ),
                                ),
                              if (context.mounted) Navigator.pop(context)
                            }
                        },
                        style: ButtonStyle(
                          textStyle: const MaterialStatePropertyAll(
                            TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.deepOrange[400]),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          padding: const MaterialStatePropertyAll(
                              EdgeInsets.fromLTRB(25, 15, 25, 15)),
                        ),
                        child: const Text("Edit",
                            style: TextStyle(color: Colors.black)),
                      )
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
