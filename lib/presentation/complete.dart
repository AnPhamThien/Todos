import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/controller/bloc/todo_bloc.dart';
import 'package:todos/model/todos.dart';
import 'package:todos/presentation/todo_item.dart';

class CompleteScreen extends StatefulWidget {
  const CompleteScreen({Key? key}) : super(key: key);

  @override
  _CompleteScreenState createState() => _CompleteScreenState();
}

class _CompleteScreenState extends State<CompleteScreen> {
  @override
  void initState() {
    context.read<TodoBloc>().add(OnInitCompleteTodoFetched());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocListener<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state.isUpdated == true) {
            setState(() {
              context.read<TodoBloc>().add(OnInitCompleteTodoFetched());
            });
          }
        },
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            switch (state.status) {
              case TodosStatus.success:
                return Scaffold(
                  appBar: AppBar(
                    title: const Text("Completed Todos"),
                  ),
                  body: state.completeTodoList.isEmpty
                      ? const Center(
                          child: Text("No todos rightnow"),
                        )
                      : ListView.builder(
                          itemCount: state.completeTodoList.length,
                          itemBuilder: (context, index) {
                            final Todos todo = state.completeTodoList[index];
                            return TodoItem(todo: todo);
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
