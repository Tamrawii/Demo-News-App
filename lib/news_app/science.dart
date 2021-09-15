import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import '../components.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ScienceScreen extends StatelessWidget {
  const ScienceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsAppCubit, NewsAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = NewsAppCubit.get(context);
          var list = NewsAppCubit.get(context).science;
          return articleBuilder(list, _refresh, context, cubit);
        });
  }

  Future<void> _refresh() {
    return Future.delayed(Duration(seconds: 1));
  }
}
