// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos/controller/bloc/todo_bloc.dart';
import 'package:todos/database/db_helper.dart';
import 'package:todos/model/todos.dart';

List<Todos> todosList = [
  Todos(id: 0, content: 'Todo0', isDone: 0),
  Todos(id: 1, content: 'Todo1', isDone: 1),
  Todos(id: 2, content: 'Todo2', isDone: 1),
  Todos(id: 3, content: 'Todo3', isDone: 0),
  Todos(id: 4, content: 'Todo4', isDone: 1),
  Todos(id: 5, content: 'Todo5', isDone: 0),
];
List<Todos> unDoneTodosList = [
  Todos(id: 0, content: 'Todo0', isDone: 0),
  Todos(id: 3, content: 'Todo3', isDone: 0),
  Todos(id: 5, content: 'Todo5', isDone: 0),
];
List<Todos> doneTodosList = [
  Todos(id: 1, content: 'Todo1', isDone: 1),
  Todos(id: 2, content: 'Todo2', isDone: 1),
  Todos(id: 4, content: 'Todo4', isDone: 1),
];

Todos mockUpTodo = Todos(id: 6, content: 'newly added todo', isDone: 0);

class MockTodos extends Mock implements Todos {}

class MockDBHelper extends Mock implements DBHelper {
  @override
  Future<Todos> save(Todos todo) async {
    return todo;
  }

  @override
  Future<List<Todos>> getAllTodos() async {
    return todosList;
  }

  @override
  Future<List<Todos>> getAllDoneTodos() async {
    return doneTodosList;
  }

  @override
  Future<int> update(Todos todo) async {
    return 1;
  }

  @override
  Future<List<Todos>> getAllUnDoneTodos() async {
    return unDoneTodosList;
  }
}

void main() {
  final MockDBHelper mockDBHelper = MockDBHelper();
  tearDown(() {});
  late TodoBloc todoBloc;

  setUp(() {
    EquatableConfig.stringify = true;
    todoBloc = TodoBloc(mockDBHelper);
  });

  group('TodoBloc', () {
    blocTest<TodoBloc, TodoState>(
        'emits [success status and a todo List] when OnInitTodoFetched is added.',
        build: () {
          return todoBloc;
        },
        act: (bloc) => {
              bloc.add(OnInitTodoFetched()),
            },
        expect: () => {
              TodoState(
                  status: TodosStatus.success,
                  todoList: todosList,
                  isUpdated: false)
            });
    blocTest<TodoBloc, TodoState>(
        'emits [success status and a imcomplete Todo List] when OnInitIncompleteTodoFetched is added.',
        build: () {
          return todoBloc;
        },
        act: (bloc) => {
              bloc.add(OnInitIncompleteTodoFetched()),
            },
        expect: () => {
              TodoState(
                  status: TodosStatus.success,
                  incompleteTodoList: unDoneTodosList,
                  isUpdated: false)
            });
    blocTest<TodoBloc, TodoState>(
        'emits [success status and a complete todo list] when OnInitCompleteTodoFetched is added.',
        build: () {
          return todoBloc;
        },
        act: (bloc) => {
              bloc.add(OnInitCompleteTodoFetched()),
            },
        expect: () => {
              TodoState(
                  status: TodosStatus.success,
                  completeTodoList: doneTodosList,
                  isUpdated: false)
            });
    blocTest<TodoBloc, TodoState>(
        'emits [success status and a isUpdated = true] when AddTodo is added.',
        build: () {
          return todoBloc;
        },
        act: (bloc) => {
              bloc.add(AddTodo('newly added todo')),
            },
        expect: () => {
              const TodoState(
                status: TodosStatus.success,
                isUpdated: true,
              )
            });

    blocTest<TodoBloc, TodoState>(
        'emits [success status and a isUpdated = true] when TodoUpdate is added.',
        build: () {
          return todoBloc;
        },
        act: (bloc) => {
              bloc.add(TodoUpdate(mockUpTodo)),
            },
        expect: () => {
              const TodoState(
                status: TodosStatus.success,
                isUpdated: true,
              )
            });
    blocTest<TodoBloc, TodoState>(
        'emits [isUpdated = false] when TodoUpdated is added.',
        build: () {
          return todoBloc;
        },
        setUp: () {
          todoBloc.add(TodoUpdate(mockUpTodo));
        },
        act: (bloc) => {
              bloc.add(TodoUpdated()),
            },
        expect: () => [
              const TodoState(
                status: TodosStatus.success,
                isUpdated: true,
              ),
              const TodoState(status: TodosStatus.success, isUpdated: false),
            ]);
  });
}
