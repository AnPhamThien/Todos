import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/database/db_helper.dart';
import 'package:todos/model/todos.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc(this.dbHelper) : super(const TodoState()) {
    on<OnInitTodoFetched>(_initTodoFetched);
    on<OnInitIncompleteTodoFetched>(_initIncompleteTodoFetched);
    on<OnInitCompleteTodoFetched>(_initCompleteTodoFetched);
    on<AddTodo>(_addTodo);
    on<TodoUpdated>(_todoUpdated);
    on<TodoUpdate>(_updateTodo);
  }

  TodoState get initialState => const TodoState(status: TodosStatus.initial);

  final DBHelper dbHelper;

  Future<TodoState> _initTodoFetched(
      OnInitTodoFetched event, Emitter<TodoState> emit) async {
    TodoState _state = const TodoState(status: TodosStatus.failure);
    try {
      final List<Todos>? todoList = await dbHelper.getAllTodos();
      if (todoList != null) {
        emit(state.copyWith(
          status: TodosStatus.success,
          todoList: todoList,
          isUpdated: false,
        ));
        _state = const TodoState(status: TodosStatus.success);
      } else {
        throw Exception('fetch error');
      }
    } catch (_) {
      log(_.toString());
      if (_.toString() == 'fetch error') {
        emit(const TodoState(status: TodosStatus.failure));
      }
    }
    return _state;
  }

  void _initIncompleteTodoFetched(
      OnInitIncompleteTodoFetched event, Emitter<TodoState> emit) async {
    try {
      final List<Todos> _incompleteTodoList =
          await dbHelper.getAllUnDoneTodos();
      emit(
        state.copyWith(
          status: TodosStatus.success,
          incompleteTodoList: _incompleteTodoList,
          isUpdated: false,
        ),
      );
    } catch (_) {
      log(_.toString());
      emit(const TodoState(status: TodosStatus.failure));
    }
  }

  void _initCompleteTodoFetched(
      OnInitCompleteTodoFetched event, Emitter<TodoState> emit) async {
    try {
      final List<Todos> _completeTodoList = await dbHelper.getAllDoneTodos();
      emit(
        state.copyWith(
          status: TodosStatus.success,
          completeTodoList: _completeTodoList,
          isUpdated: false,
        ),
      );
    } catch (_) {
      log(_.toString());
      emit(const TodoState(status: TodosStatus.failure));
    }
  }

  void _addTodo(AddTodo event, Emitter<TodoState> emit) async {
    try {
      final Todos todo = Todos(id: null, content: event.todo, isDone: 0);
      final addedTodo = await dbHelper.save(todo);
      if (addedTodo.content == todo.content) {
        emit(state.copyWith(
          status: TodosStatus.success,
          isUpdated: true,
        ));
      }
    } catch (_) {
      log(_.toString());
      emit(const TodoState(status: TodosStatus.failure));
    }
  }

  void _updateTodo(TodoUpdate event, Emitter<TodoState> emit) async {
    try {
      final Todos todo = event.todo;
      final todoUpdated = await dbHelper.update(todo);
      if (todoUpdated == 1) {
        emit(state.copyWith(
          status: TodosStatus.success,
          isUpdated: true,
        ));
      }
    } catch (_) {
      log(_.toString());
      emit(const TodoState(status: TodosStatus.failure));
    }
  }

  void _todoUpdated(TodoUpdated event, Emitter<TodoState> emit) async {
    try {
      if (state.isUpdated == false) {
        return;
      } else {
        emit(state.copyWith(status: TodosStatus.success, isUpdated: false));
      }
    } catch (_) {
      log(_.toString());
      emit(const TodoState(status: TodosStatus.failure));
    }
  }
}
