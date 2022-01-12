import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/controller/bloc/todo_bloc.dart';
import 'package:todos/database/db_helper.dart';

import 'complete.dart';
import 'incomplete.dart';
import 'todos.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int currentIndex = 0;
  final screen = [
    const TodosScreen(),
    const IncompleteScreen(),
    const CompleteScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => TodoBloc(DBHelper()),
        child: screen[currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() {
          currentIndex = index;
        }),
        items: const [
          BottomNavigationBarItem(
            label: 'Todos',
            icon: Icon(
              Icons.list_alt_rounded,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Incomplete',
            icon: Icon(
              Icons.access_time_rounded,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Completed',
            icon: Icon(
              Icons.checklist_rtl_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
