
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:todo_app/cubit/cubit.dart';

Widget defaultTextFormFiedl({
  required String text,
  required IconData icon,
  required var controller,
  bool readOnly = false,
  bool showCursor = true,
  var onClick,
  required var validator,
}) =>
    TextFormField(
      onTap: onClick,
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: text,
        prefixIcon: Icon(icon),
      ),
      controller: controller,
      readOnly: readOnly,
      showCursor: showCursor,
    );

Widget defaultTasksItems(Map modal, context) => Dismissible(
      key: Key(modal['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteDb(id: modal['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              child: Text(
                '${modal['time']}',
                style: TextStyle(fontSize: 13),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${modal['title']}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${modal['date']}',
                    style: TextStyle(color: Colors.grey[400], fontSize: 13),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 15,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateDb(id: modal['id'], status: 'done');
                },
                icon: Icon(
                  Icons.check_box,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateDb(id: modal['id'], status: 'achrived');
                },
                icon: Icon(
                  Icons.archive_rounded,
                  color: Colors.grey[400],
                )),
          ],
        ),
      ),
    );

Widget buildArticles(article, context) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                  image: NetworkImage(
                      '${article['urlToImage']}'),
                  fit: BoxFit.cover),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Container(
              height: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      '${article['title']}',
                      style:
                          Theme.of(context).textTheme.bodyText1,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${article['publishedAt']}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );

Widget articleBuilder(list, _refresh, context, cubit) => Conditional.single(
              context: context,
              conditionBuilder: (cotext) =>
                  list.length > 0,
              widgetBuilder: (cotext) => RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) => buildArticles(list[index], context),
                        separatorBuilder: (index, context) => Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 20, end: 20),
                              child: Container(
                                height: 1,
                                width: double.infinity,
                                color: Colors.grey[300],
                              ),
                            ),
                        itemCount: cubit.business.length),
                  ),
              fallbackBuilder: (BuildContext context) => Center(
                    child: CircularProgressIndicator(),
                  ));
