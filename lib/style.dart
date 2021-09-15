import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/achrived_task.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';
import 'package:todo_app/done_tasks.dart';
import 'package:todo_app/new_task.dart';

import 'components.dart';
import 'constants.dart';

class HomePage extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDB(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles.elementAt(cubit.currentIndex)),
            ),
            body: cubit.screens.elementAt(cubit.currentIndex),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (value) {
                cubit.changeNavBar(value);
                /* setState(() {
              currentIndex = value;
            }); */
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_box_outlined),
                  label: 'New Task',
                  activeIcon: Icon(Icons.add_box_rounded),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outlined),
                    label: 'Done Task',
                    activeIcon: Icon(Icons.check_circle)),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: 'Done Task',
                    activeIcon: Icon(Icons.archive_rounded)),
              ],
            ),
            floatingActionButton: FloatingActionButton(
                child: Icon(cubit.iconFab),
                onPressed: () {
                  if (cubit.isOpened == false) {
                    cubit.floatingBtn(icon: Icons.add, isShowed: true);
                    /* setState(() {
                  iconFab = Icons.add;
                }); */
                    scaffoldKey.currentState!
                        .showBottomSheet((context) => Container(
                              height: 300,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Container(
                                          height: 7,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.black12),
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Form(
                                            key: formKey,
                                            child: Column(
                                              children: [
                                                defaultTextFormFiedl(
                                                    text: 'Task Title',
                                                    icon: Icons.title_outlined,
                                                    controller: titleController,
                                                    validator: (value) {
                                                      if (titleController
                                                          .text.isEmpty) {
                                                        return 'Task Title Must Be Not Empty';
                                                      }
                                                      return null;
                                                    }),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                defaultTextFormFiedl(
                                                  onClick: () {
                                                    showDatePicker(
                                                            context: context,
                                                            initialDate:
                                                                DateTime.now(),
                                                            firstDate:
                                                                DateTime.now(),
                                                            lastDate:
                                                                DateTime.parse(
                                                                    '2100-12-12'))
                                                        .then((value) {
                                                      dateController.text =
                                                          DateFormat()
                                                              .add_yMMMMd()
                                                              .format(value!);
                                                    });
                                                  },
                                                  validator: (value) {
                                                    if (titleController
                                                        .text.isEmpty) {
                                                      return 'Task Date Must Be Not Empty';
                                                    }
                                                    return null;
                                                  },
                                                  text: 'Task Date',
                                                  icon: Icons.calendar_today,
                                                  controller: dateController,
                                                  readOnly: true,
                                                  showCursor: false,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                defaultTextFormFiedl(
                                                    text: 'Task Time',
                                                    icon: Icons.watch,
                                                    controller: timeController,
                                                    readOnly: true,
                                                    showCursor: false,
                                                    onClick: () {
                                                      showTimePicker(
                                                              context: context,
                                                              initialTime:
                                                                  TimeOfDay
                                                                      .now())
                                                          .then((value) {
                                                        timeController.text =
                                                            value!.format(
                                                                context);
                                                      });
                                                    },
                                                    validator: (value) {
                                                      if (titleController
                                                          .text.isEmpty) {
                                                        return 'Task Time  Must Be Not Empty';
                                                      }
                                                      return null;
                                                    }),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ))
                        .closed
                        .then((value) {
                      
                        cubit.floatingBtn(icon: Icons.edit, isShowed: false);
                      /* setState(() {
                    iconFab = Icons.edit;
                  }); */
                    });
                  } else {
                    if (formKey.currentState!.validate()) {
                      cubit.insertDB(
                          title: titleController.text,
                          date: dateController.text,
                          time: timeController.text);
                      cubit.floatingBtn(icon: Icons.edit, isShowed: false);
                      Navigator.pop(context);
                    }
                    //cubit.getDB(database);
                  }
                }),
          );
        },
      ),
    );
  }

  /* void createDB() async {
    database = await openDatabase('tasks1.db', version: 1,
        onCreate: (database, version) {
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
    });
  }

  Future insertDB({required title, required date, required time}) async {
    await database.transaction((txn) => txn.rawInsert(
        'INSERT INTO tasks (title, date, time, status) VALUES ("$title", "$date", "$time", "new")'));
  }

  void getDB(database) async {
    tasks = await database.rawQuery('SELECT * FROM tasks');
    print(tasks);
  } */
}
