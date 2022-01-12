part of 'todo_bloc.dart';

class TodoEvent {}

class OnInitTodoFetched extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String todo;

  AddTodo(this.todo);
}

class OnInitIncompleteTodoFetched extends TodoEvent {}

class OnInitCompleteTodoFetched extends TodoEvent {}

class TodoUpdated extends TodoEvent {}

class TodoUpdate extends TodoEvent {
  final Todos todo;

  TodoUpdate(this.todo);
}
