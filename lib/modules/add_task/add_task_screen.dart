import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:todo_app/layout/todo_layout_screen.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
import 'package:todo_app/shared/styles/colors.dart';

class AddTaskScreen extends StatelessWidget {
  TextEditingController taskNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        File? taskImage = cubit.taskImage;
        if (cubit.category.isEmpty) {
          cubit.category.add(InkWell(
            onTap: () {
              myShowDialog(
                context: context,
              );
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.add,
                color: second_Cyan_color,
                size: 28,
              ),
            ),
          ));
        }
        return SafeArea(
          child: Scaffold(
            body: Container(
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
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Card(
                          child: IconButton(
                            onPressed: () {
                              AppCubit.get(context).category = [];
                              AppCubit.get(context).categoryColors = [];
                              AppCubit.get(context).categoryColorBool = [
                                true,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false
                              ];
                              navigateAndFinish(context, TodoScreen());
                            },
                            icon: const Icon(Icons.arrow_back_ios_outlined),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Create New Task',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 1,
                            child: IconButton(
                              onPressed: () async {
                                if (taskNameController.text.isEmpty ||
                                    descriptionController.text.isEmpty) {
                                  showToast(
                                      text: 'Please fill all field',
                                      state: ToastStates.ERROR);
                                } else {
                                  AppCubit.get(context).insertDatabase(
                                    uId: uId!,
                                    title: taskNameController.text,
                                    description: descriptionController.text,
                                    context: context,
                                  );
                                }
                                navigateAndFinish(context, TodoScreen());
                              },
                              icon: const Icon(
                                Ionicons.save,
                              ),
                              color: second_Cyan_color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Task Name',
                            style:
                                Theme.of(context).textTheme.bodyText1?.copyWith(
                                      color: second_Cyan_color,
                                      fontSize: 20,
                                    ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          defaultTextFormField(
                            controller: taskNameController,
                            type: TextInputType.text,
                            validate: (value) {},
                            label: 'Enter Task Name',
                          ),
                          Text(
                            'Description',
                            style:
                                Theme.of(context).textTheme.bodyText1?.copyWith(
                                      color: second_Cyan_color,
                                      fontSize: 20,
                                    ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          defaultTextFormField(
                            controller: descriptionController,
                            type: TextInputType.text,
                            validate: (value) {},
                            label: 'Enter The Description',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              if (taskImage != null)
                                Container(
                                  width: 100,
                                  height: 60,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image(
                                    fit: BoxFit.cover,
                                    image: FileImage(taskImage),
                                  ),
                                ),
                              const Spacer(),
                              if (taskImage != null)
                                state is AppUserUploadTaskImageLoadingState ? const Expanded(child: Center(child: CircularProgressIndicator())) : defaultButton(
                                  function: () {
                                    cubit.uploadTaskImage();
                                  },
                                  text: 'Save',
                                  background: second_orange_color,
                                  textColor: Colors.white,
                                  context: context,
                                ),
                              defaultButton(
                                function: () {
                                  cubit.getTaskImage();
                                },
                                text: 'Upload Photo',
                                background: second_Cyan_color,
                                textColor: Colors.white,
                                context: context,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadiusDirectional.only(
                                  topStart: Radius.circular(30),
                                  topEnd: Radius.circular(30),
                                ),
                                color: Colors.grey.withOpacity(0.2),
                              ),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    showDatePicker(
                                                      context: context,
                                                      initialDate: cubit.date,
                                                      firstDate: DateTime.now(),
                                                      lastDate: DateTime.parse(
                                                          '2022-05-03'),
                                                    ).then((value) {
                                                      cubit.changeDate(value!);
                                                    });
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .date_range_outlined,
                                                        color:
                                                            second_Cyan_color,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            DateFormat.yMMMd()
                                                                .format(
                                                                    cubit.date),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1
                                                                ?.copyWith(
                                                                  color:
                                                                      second_Cyan_color,
                                                                ),
                                                          ),
                                                          const Text(
                                                            'Date',
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Ionicons.earth,
                                                        color: Colors.red,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'GMT+6',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1
                                                                ?.copyWith(
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                          ),
                                                          const Text(
                                                            'Time Zone',
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          cubit.startTime,
                                                    ).then((value) {
                                                      cubit.changeStartTime(
                                                          value!);
                                                    });
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .access_time_rounded,
                                                        color:
                                                            second_orange_color,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            cubit.startTime
                                                                .format(context)
                                                                .toString(),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1
                                                                ?.copyWith(
                                                                  color:
                                                                      second_orange_color,
                                                                ),
                                                          ),
                                                          const Text(
                                                            'Task End',
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          cubit.endTime,
                                                    ).then((value) {
                                                      cubit.changeEndTime(
                                                          value!);
                                                    });
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .access_time_rounded,
                                                        color: first_blue_color,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            cubit.endTime
                                                                .format(context)
                                                                .toString(),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1
                                                                ?.copyWith(
                                                                  color:
                                                                      first_blue_color,
                                                                ),
                                                          ),
                                                          const Text(
                                                            'Task Start',
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Category',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
                                              fontSize: 24,
                                              color: Colors.grey,
                                            ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 50,
                                              child: ListView.separated(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemBuilder: (context, index) =>
                                                    cubit.category[index],
                                                separatorBuilder:
                                                    (context, index) =>
                                                        const SizedBox(
                                                  width: 10,
                                                ),
                                                itemCount:
                                                    cubit.category.length,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
