import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/network/remote/dio_helper.dart';
import 'package:todo_app/news_app/business.dart';
import 'package:todo_app/news_app/cubit/states.dart';
import 'package:todo_app/news_app/science.dart';
import 'package:todo_app/news_app/settings.dart';
import 'package:todo_app/news_app/sport.dart';

class NewsAppCubit extends Cubit<NewsAppStates> {
  NewsAppCubit() : super(AppInitialState());

  static NewsAppCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [
    BusinessScreen(),
    SportScreen(),
    ScienceScreen(),
  ];

  int currenIndex = 0;

  void changeNavBar(index) {
    currenIndex = index;
    if (index == 1) {
      getSports();
    }
    if (index == 2) {
      getSience();
    }
    emit(AppChangeNavBar());
  }

  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Business'),
    BottomNavigationBarItem(icon: Icon(Icons.sports), label: 'Sports'),
    BottomNavigationBarItem(icon: Icon(Icons.science), label: 'Science'),
  ];

  List<dynamic> business = [];

  void getBusiness() {
    emit(NewsBusinesGetLoadingState());

    DioHelper.getData(url: 'v2/top-headlines', query: {
      'country': 'us',
      'category': 'business',
      'apiKey': 'b5a4025f9ec84bad9425de78c46e07ed',
    }).then((value) {
      //print(value.data['articles'][0]['title']);
      business = value.data['articles'];
      print(business[0]['title']);
      emit(NewsBusinesGetSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(NewsBusinesGetErrorState(error.toString()));
    });
  }

  List<dynamic> sports = [];

  void getSports() {
    emit(NewsSportsGetLoadingState());

    if (sports.length == 0) {
      DioHelper.getData(url: 'v2/top-headlines', query: {
        'country': 'us',
        'category': 'sports',
        'apiKey': 'b5a4025f9ec84bad9425de78c46e07ed',
      }).then((value) {
        sports = value.data['articles'];
        print(sports[0]['title']);
        emit(NewsSportsGetSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(NewsSportsGetErrorState(error.toString()));
      });
    } else {
      emit(NewsSportsGetSuccessState());
    }
  }

  List<dynamic> science = [];

  void getSience() {
    emit(NewsScienceGetLoadingState());

    if (science.length == 0) {
      DioHelper.getData(url: 'v2/top-headlines', query: {
        'country': 'us',
        'category': 'science',
        'apiKey': 'b5a4025f9ec84bad9425de78c46e07ed',
      }).then((value) {
        science = value.data['articles'];
        print(science[0]['title']);
        emit(NewsScienceGetSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(NewsScienceGetErrorState(error.toString()));
      });
    } else {
      emit(NewsScienceGetSuccessState());
    }
  }

  bool isDark = true;

  void changeMode() {
    isDark = !isDark;
    emit(NewsChangeMode());
  }
}
