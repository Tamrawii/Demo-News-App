import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/network/remote/dio_helper.dart';
import 'package:todo_app/news_app/cubit/cubit.dart';
import 'package:todo_app/news_app/cubit/states.dart';
import 'package:todo_app/theme/cubit/theme_mode_cubit.dart';
import 'bloc_observer.dart';
import 'news_app/layout.dart';
import 'style.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NewsAppCubit(),
        ),
        BlocProvider(create: (_) => ThemeModeCubit())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsAppCubit(),
      child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: state.themeMode,
            theme: ThemeData(
              textTheme: TextTheme(
                  bodyText1: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
              primarySwatch: Colors.deepOrange,
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: Colors.deepOrange),
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                  titleSpacing: 20.0,
                  systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Colors.white,
                      statusBarBrightness: Brightness.dark),
                  backgroundColor: Colors.white,
                  titleTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                  iconTheme: IconThemeData(color: Colors.black),
                  elevation: 0.0),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.deepOrange,
                unselectedItemColor: Colors.grey,
                elevation: 20.0,
                backgroundColor: Colors.white,
              ),
            ),
            darkTheme: ThemeData(
                scaffoldBackgroundColor: HexColor('1A1A2E'),
                primarySwatch: Colors.deepOrange,
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor: Colors.deepOrange),
                appBarTheme: AppBarTheme(
                    titleSpacing: 20.0,
                    systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarColor: HexColor('1A1A2E'),
                        statusBarBrightness: Brightness.light),
                    backgroundColor: HexColor('1A1A2E'),
                    titleTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                    iconTheme: IconThemeData(color: Colors.white),
                    elevation: 0.0),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.deepOrange,
                  unselectedItemColor: Colors.grey,
                  elevation: 20.0,
                  backgroundColor: HexColor('1A1A2E'),
                ),
                textTheme: TextTheme(
                    bodyText1: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600))),
            home: NewsApp(),
          );
        },
      ),
    );
  }
}
