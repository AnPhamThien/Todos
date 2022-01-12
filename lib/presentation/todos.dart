import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/controller/bloc/todo_bloc.dart';
import 'package:todos/model/todos.dart';
import 'package:todos/presentation/todo_item.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({Key? key}) : super(key: key);

  @override
  _TodosScreenState createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  @override
  void initState() {
    context.read<TodoBloc>().add(OnInitTodoFetched());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocListener<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state.isUpdated == true) {
            setState(() {
              context.read<TodoBloc>().add(OnInitTodoFetched());
            });
          }
        },
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            switch (state.status) {
              case TodosStatus.success:
                return Scaffold(
                  appBar: AppBar(
                    title: const Text("All Todos"),
                    actions: [
                      IconButton(
                        onPressed: _showDialog,
                        icon: const Icon(Icons.add_box_rounded),
                      ),
                    ],
                  ),
                  body: state.todoList.isEmpty
                      ? const Center(
                          child: Text("No todos rightnow"),
                        )
                      : ListView.builder(
                          itemCount: state.todoList.length,
                          itemBuilder: (context, index) {
                            final Todos todo = state.todoList[index];
                            return TodoItem(
                              todo: todo,
                            );
                          },
                        ),
                );
              case TodosStatus.failure:
                return const Center(
                  child: Text("something went wrong"),
                );
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      );
    });
  }

  Future<String?> _showDialog() {
    TextEditingController controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext _) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actionsAlignment: MainAxisAlignment.center,
        title: const Text('Adding a new todo',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 23,
                color: Colors.black87,
                letterSpacing: 1.25,
                fontWeight: FontWeight.w500)),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * .9,
          child: TextFormField(
            controller: controller,
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              context.read<TodoBloc>().add(AddTodo(controller.text));
              Navigator.of(context).pop();
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
