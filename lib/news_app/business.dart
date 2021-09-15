import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:todo_app/news_app/cubit/cubit.dart';
import 'package:todo_app/news_app/cubit/states.dart';

import '../components.dart';

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsAppCubit, NewsAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = NewsAppCubit.get(context);
          var list = NewsAppCubit.get(context).business;
          return articleBuilder(list, _refresh, context, cubit);
        });
  }

  Future<void> _refresh() {
    return Future.delayed(Duration(seconds: 1));
  }
}
