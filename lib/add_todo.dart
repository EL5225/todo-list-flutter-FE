import 'package:flutter/material.dart';
import 'package:todo_list_app/services/api_calls.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final _formKey = GlobalKey<FormState>();

  String title = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Todo",
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.deepOrange[400],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        gapPadding: BorderSide.strokeAlignCenter,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: "Todo",
                    prefixIcon: Icon(Icons.add_task_sharp),
                    hintText: "Masukkan Todo hari ini",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  onChanged: (value) => {
                    setState(() {
                      title = value;
                    })
                  },
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
                            content: const Text("Todo harus diisi!"),
                            backgroundColor: Colors.red[600],
                          ),
                        )
                      }
                    else
                      {
                        await createTodo(title),
                        if (context.mounted)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Tambah Todo Berhasil!"),
                              backgroundColor: Colors.green[700],
                            ),
                          ),
                        if (context.mounted) Navigator.pop(context)
                      }
                  },
                  style: ButtonStyle(
                    textStyle: const MaterialStatePropertyAll(
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                  child: const Text("Tambah",
                      style: TextStyle(color: Colors.black)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
