part of 'todo_bloc.dart';

enum TodosStatus { initial, success, failure }

class TodoState extends Equatable {
  final TodosStatus status;
  final List<Todos> todoList;
  final List<Todos> incompleteTodoList;
  final List<Todos> completeTodoList;
  final bool isUpdated;

  const TodoState(
      {this.status = TodosStatus.initial,
      this.todoList = const <Todos>[],
      this.incompleteTodoList = const <Todos>[],
      this.completeTodoList = const <Todos>[],
      this.isUpdated = false});

  TodoState copyWith(
      {TodosStatus? status,
      List<Todos>? todoList,
      bool? isUpdated,
      List<Todos>? incompleteTodoList,
      List<Todos>? completeTodoList}) {
    return TodoState(
        status: status ?? this.status,
        todoList: todoList ?? this.todoList,
        incompleteTodoList: incompleteTodoList ?? this.incompleteTodoList,
        completeTodoList: completeTodoList ?? this.completeTodoList,
        isUpdated: isUpdated ?? this.isUpdated);
  }

  @override
  List<Object?> get props =>
      [status, todoList, incompleteTodoList, completeTodoList, isUpdated];
}
