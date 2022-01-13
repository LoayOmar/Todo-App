import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
import 'package:todo_app/shared/styles/colors.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  first_Background_color.withOpacity(0.2),
                  second_Background_color.withOpacity(0.1),
                ],
              )
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat.yMMMd().format(DateTime.now()),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,),
                      ),
                      const Spacer(),
                      defaultCircleButton(
                        radius: 35,
                        function: () {},
                        icon: Icons.arrow_back_ios_outlined,
                        context: context,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      defaultCircleButton(
                        radius: 35,
                        function: () {},
                        icon: Icons.arrow_forward_ios_outlined,
                        context: context,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.separated(
                      clipBehavior: AppCubit.get(context).clip,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        if(AppCubit.get(context).newTasks[index]['uId'] == uId) {
                          if(AppCubit.get(context).newTasks[index]['date'] == DateFormat.yMMMd().format(DateTime.now())) {
                            return buildTaskItem(
                                AppCubit.get(context).newTasks[index], context);
                          }
                        }
                        return const SizedBox(width: 0, height: 0,);
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 10,),
                      itemCount: AppCubit.get(context).newTasks.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
