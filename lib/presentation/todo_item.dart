import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/controller/bloc/todo_bloc.dart';
import 'package:todos/model/todos.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final Todos todo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(todo.content ?? ''),
      trailing: Checkbox(
        value: todo.isDone == 0 ? false : true,
        onChanged: (value) {
          final updatedTodo = Todos(
              id: todo.id,
              content: todo.content,
              isDone: value == true ? 1 : 0);
          context.read<TodoBloc>().add(TodoUpdate(updatedTodo));
        },
      ),
    );
  }
}
