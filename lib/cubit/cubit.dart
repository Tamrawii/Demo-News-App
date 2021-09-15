import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/cubit/states.dart';

import '../achrived_task.dart';
import '../done_tasks.dart';
import '../new_task.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  List<Widget> screens = [NewTasks(), DoneTasks(), ArchivedTasks()];
  int currentIndex = 0;

  void changeNavBar(value) {
    currentIndex = value;
    emit(AppNavBarChange());
  }

  bool isOpened = false;
  IconData iconFab = Icons.edit;

  void floatingBtn({required icon, required isShowed}) {
    iconFab = icon;
    isOpened = isShowed;
    emit(AppFloatingChange());
  }

  late Database database;

  void createDB() async {
    await openDatabase('tasks1.db', version: 1, onCreate: (database, version) {
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {
        print('database created successfully');
      }).catchError((error) {
        print('cannot create database, ${error.toString()}');
      });
    }, onOpen: (database) {
      getDB(database);
      print('database opened');
    }).then((value) {
      database = value;
      emit(AppCreateDB());
    });
  }

  Future insertDB({required title, required date, required time}) async {
    await database
        .transaction((txn) => txn.rawInsert(
            'INSERT INTO tasks (title, date, time, status) VALUES ("$title", "$date", "$time", "new")'))
        .then((value) {
      print(value);
      emit(AppInsertDB());
      getDB(database);
    });
  }

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void getDB(database) =>
      database.rawQuery('SELECT * FROM tasks').then((value) {
        newTasks = [];
        doneTasks = [];
        archivedTasks = [];
        value.forEach((element) {
          if (element['status'] == 'new') {
            newTasks.add(element);
          } else if (element['status'] == 'done') {
            doneTasks.add(element);
          } else {
            archivedTasks.add(element);
          }
        });
        emit(AppGettDB());
      });

  Future updateDb({required status, required id}) async {
    await database
        .rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', ['$status', id]);

    emit(AppUpdateDb());
    getDB(database);
  }

  Future deleteDb({required id}) async {
    await database
        .rawDelete('DELETE FROM tasks WHERE id = ?', [id]);

    emit(AppDeleteDb());
    getDB(database);
  }

}
