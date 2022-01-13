import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
import 'package:todo_app/shared/styles/colors.dart';

class DoneScreen extends StatelessWidget {
  List<String> days = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  first_Background_color.withOpacity(0.2),
                  second_Background_color.withOpacity(0.1),
                ],
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildHeaderAccountData(context),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 120,
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {

                            return dayCardItem(context, days[index], weekDates[index]);
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 10,
                          ),
                          itemCount: 7,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadiusDirectional.only(
                        topStart: Radius.circular(30),
                        topEnd: Radius.circular(30),
                      ),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: defaultButton(
                                  function: () {},
                                  text: 'Today',
                                  textColor: Colors.white,
                                  textSize: 22,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      first_Cyan_color,
                                      second_Cyan_color,
                                    ],
                                  ),
                                  context: context,
                                  radius: 30,
                                ),
                                width: 120,
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
                          Expanded(
                            child: ListView.separated(
                              clipBehavior: AppCubit.get(context).clip,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                if(AppCubit.get(context).doneTasks[index]['uId'] == uId) {
                                  return buildTaskItem(AppCubit.get(context).doneTasks[index], context);
                                }
                                return const SizedBox(width: 0, height: 0,);
                              },
                              separatorBuilder: (context, index) => const SizedBox(height: 10,),
                              itemCount: AppCubit.get(context).doneTasks.length,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}