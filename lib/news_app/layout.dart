import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/network/remote/dio_helper.dart';
import 'package:todo_app/news_app/cubit/states.dart';

import 'cubit/cubit.dart';

class NewsApp extends StatelessWidget {
  const NewsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => NewsAppCubit()..getBusiness(),
        child: BlocConsumer<NewsAppCubit, NewsAppStates>(
            listener: (context, state) {
          /* if (state is NewsChangeMode) {
            print('Hello');
          } */
        }, builder: (context, state) {
          var cubit = NewsAppCubit.get(context);
          bool test = NewsAppCubit.get(context).isDark;
          return Scaffold(
              appBar: AppBar(
                title: Text('News App'),
                actions: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                  IconButton(
                      onPressed: () {
                        NewsAppCubit.get(context).changeMode();
                      },
                      icon: Icon(Icons.brightness_4_outlined)),
                ],
              ),
              body: cubit.screens[cubit.currenIndex],
              bottomNavigationBar: BottomNavigationBar(
                items: cubit.items,
                currentIndex: cubit.currenIndex,
                onTap: (index) {
                  cubit.changeNavBar(index);
                },
              ));
        }));
  }
}
