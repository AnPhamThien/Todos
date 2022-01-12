import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/controller/bloc/todo_bloc.dart';
import 'package:todos/model/todos.dart';
import 'package:todos/presentation/todo_item.dart';

class IncompleteScreen extends StatefulWidget {
  const IncompleteScreen({Key? key}) : super(key: key);

  @override
  _IncompleteScreenState createState() => _IncompleteScreenState();
}

class _IncompleteScreenState extends State<IncompleteScreen> {
  @override
  void initState() {
    context.read<TodoBloc>().add(OnInitIncompleteTodoFetched());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocListener<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state.isUpdated == true) {
            setState(() {
              context.read<TodoBloc>().add(OnInitIncompleteTodoFetched());
            });
          }
        },
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            switch (state.status) {
              case TodosStatus.success:
                return Scaffold(
                  appBar: AppBar(
                    title: const Text("Incomplete Todos"),
                  ),
                  body: state.incompleteTodoList.isEmpty
                      ? const Center(
                          child: Text("No todos rightnow"),
                        )
                      : ListView.builder(
                          itemCount: state.incompleteTodoList.length,
                          itemBuilder: (context, index) {
                            final Todos todo = state.incompleteTodoList[index];
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
}
