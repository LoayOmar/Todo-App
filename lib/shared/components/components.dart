import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
import 'package:todo_app/shared/styles/colors.dart';

Widget defaultButton({
  double width = double.infinity,
  double elevation = 10,
  Color? background,
  double radius = 10.0,
  double textSize = 16.0,
  required var function,
  required String text,
  Color textColor = Colors.black,
  required BuildContext context,
  LinearGradient? gradient,
}) =>
    Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          color: background,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: MaterialButton(
          onPressed: function,
          child: Text(
            '${text}',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: textColor,
                  fontSize: textSize,
                ),
          ),
        ),
      ),
    );

defaultCircleButton({
  double elevation = 10,
  Color background = Colors.blue,
  required double radius,
  required var function,
  required IconData icon,
  Color iconColor = Colors.black,
  required BuildContext context,
  LinearGradient? gradient,
}) =>
    InkWell(
      onTap: function,
      child: Card(
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(radius),
            gradient: gradient,
          ),
          child: Center(
            child: Icon(
              icon,
              size: radius / 2,
              color: iconColor,
            ),
          ),
        ),
      ),
    );

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  bool isPassword = false,
  var onSubmit,
  var onTap,
  var onChanged,
  var suffixPressed,
  required var validate,
  required String? label,
  IconData? prefix,
  bool isClickable = true,
  IconData? suffix,
}) =>
    TextFormField(
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefix != null
              ? Icon(
                  prefix,
                )
              : null,
          suffixIcon: suffix != null
              ? IconButton(
                  icon: Icon(
                    suffix,
                  ),
                  onPressed: suffixPressed,
                )
              : null,
          border: OutlineInputBorder()),
      onTap: onTap,
      enabled: isClickable,
      validator: validate,
      onChanged: onChanged,
      keyboardType: type,
      controller: controller,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
    );

void showToast({
  required String text,
  required ToastStates state,
}) {
  Fluttertoast.showToast(
      msg: '${text}',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0);
}

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
  }

  return color;
}

Widget defaultTextButton({
  required var function,
  required String text,
}) =>
    TextButton(
      onPressed: function,
      child: Text(
        text.toUpperCase(),
      ),
    );

void navigateTo(context, widget) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (ctx) => widget,
    ));

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (route) => false,
    );

void showDialog(BuildContext context) {
  showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return ClassicGeneralDialogWidget(
        titleText: 'Title',
        contentText: 'content',
        onPositiveClick: () {
          Navigator.of(context).pop();
        },
        onNegativeClick: () {
          Navigator.of(context).pop();
        },
      );
    },
    animationType: DialogTransitionType.size,
    curve: Curves.fastOutSlowIn,
    duration: const Duration(seconds: 1),
  );
}

Widget dayCardItem(BuildContext context, String dayName, String date) => Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 65,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: DateFormat.yMMMd().format(DateTime.now()).toString() == date
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    first_orange_color,
                    second_orange_color,
                  ],
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              date.length == 11 ? date[4] : '${date[4]}${date[5]}',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontSize: 30,
                    color:
                        DateFormat.yMMMd().format(DateTime.now()).toString() ==
                                date
                            ? Colors.white
                            : Colors.black,
                  ),
            ),
            Text(
              dayName,
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    fontSize: 18,
                    color:
                        DateFormat.yMMMd().format(DateTime.now()).toString() ==
                                date
                            ? Colors.white
                            : Colors.black,
                  ),
            ),
          ],
        ),
      ),
    );

Widget buildCategoryItem(context, color, text) => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color.withOpacity(0.2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Text(
            '$text',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: color,
                ),
          ),
        ),
      ),
    );

AwesomeDialog myShowDialog({
  required context,
}) {
  TextEditingController controller = TextEditingController();

  return AwesomeDialog(
    context: context,
    title: 'Add Category',
    dialogType: DialogType.NO_HEADER,
    btnCancel: defaultButton(
        function: () {
          Navigator.pop(context);
        },
        text: 'Cancel',
        context: context),
    btnOk: defaultButton(
        function: () {
          AppCubit.get(context).addCategoryItem(buildCategoryItem(
            context,
            AppCubit.get(context).categoryColor,
            controller.text,
          ));
          AppCubit.get(context).categoryNames.add(controller.text);
          AppCubit.get(context)
              .categoryColors
              .add(AppCubit.get(context).categoryColor);
          Navigator.pop(context);
        },
        text: 'Add',
        context: context),
    body: BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) => Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Text(
                'Choose Color',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 25),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      AppCubit.get(context)
                          .changeCategoryColor(first_orange_color);
                      AppCubit.get(context).changeCategoryColorBool(0);
                    },
                    child: AppCubit.get(context).categoryColorBool[0]
                        ? CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.green,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: first_orange_color,
                            ),
                          )
                        : CircleAvatar(
                            radius: 10,
                            backgroundColor: first_orange_color,
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      AppCubit.get(context)
                          .changeCategoryColor(second_orange_color);
                      AppCubit.get(context).changeCategoryColorBool(1);
                    },
                    child: AppCubit.get(context).categoryColorBool[1]
                        ? CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.green,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: second_orange_color,
                            ),
                          )
                        : CircleAvatar(
                            radius: 10,
                            backgroundColor: second_orange_color,
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      AppCubit.get(context)
                          .changeCategoryColor(first_Cyan_color);
                      AppCubit.get(context).changeCategoryColorBool(2);
                    },
                    child: AppCubit.get(context).categoryColorBool[2]
                        ? CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.green,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: first_Cyan_color,
                            ),
                          )
                        : CircleAvatar(
                            radius: 10,
                            backgroundColor: first_Cyan_color,
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      AppCubit.get(context)
                          .changeCategoryColor(second_Cyan_color);
                      AppCubit.get(context).changeCategoryColorBool(3);
                    },
                    child: AppCubit.get(context).categoryColorBool[3]
                        ? CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.green,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: second_Cyan_color,
                            ),
                          )
                        : CircleAvatar(
                            radius: 10,
                            backgroundColor: second_Cyan_color,
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      AppCubit.get(context)
                          .changeCategoryColor(first_blue_color);
                      AppCubit.get(context).changeCategoryColorBool(4);
                    },
                    child: AppCubit.get(context).categoryColorBool[4]
                        ? CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.green,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: first_blue_color,
                            ),
                          )
                        : CircleAvatar(
                            radius: 10,
                            backgroundColor: first_blue_color,
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      AppCubit.get(context)
                          .changeCategoryColor(second_blue_color);
                      AppCubit.get(context).changeCategoryColorBool(5);
                    },
                    child: AppCubit.get(context).categoryColorBool[5]
                        ? CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.green,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: second_blue_color,
                            ),
                          )
                        : CircleAvatar(
                            radius: 10,
                            backgroundColor: second_blue_color,
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      AppCubit.get(context)
                          .changeCategoryColor(light_blue_color);
                      AppCubit.get(context).changeCategoryColorBool(6);
                    },
                    child: AppCubit.get(context).categoryColorBool[6]
                        ? CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.green,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: light_blue_color,
                            ),
                          )
                        : CircleAvatar(
                            radius: 10,
                            backgroundColor: light_blue_color,
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      AppCubit.get(context)
                          .changeCategoryColor(dark_blue_color);
                      AppCubit.get(context).changeCategoryColorBool(7);
                    },
                    child: AppCubit.get(context).categoryColorBool[7]
                        ? CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.green,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: dark_blue_color,
                            ),
                          )
                        : CircleAvatar(
                            radius: 10,
                            backgroundColor: dark_blue_color,
                          ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Category Name',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 25),
              ),
              defaultTextFormField(
                label: 'Enter Category Name',
                controller: controller,
                type: TextInputType.text,
                validate: (value) {},
              ),
            ],
          ),
        ),
      ),
    ),
  )..show();
}

Widget buildTaskItem(Map model, BuildContext context) {
  String cat = model['category'];
  cat = cat.replaceAll('[', '');
  cat = cat.replaceAll(']', '');
  List<String> category = cat.split(',');

  String color = model['categoryColor'];
  color = color.replaceAll('[', '');
  color = color.replaceAll(']', '');
  color = color.replaceAll('Color(', '');
  color = color.replaceAll(')', '');
  List<String> colors = color.split(',');

  return Dismissible(
    key: UniqueKey(),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: double.infinity,
          height: 110,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (model['imageUrl'] != 'null')
                  Image(
                    image: NetworkImage('${model['imageUrl']}'),
                    fit: BoxFit.cover,
                    height: 100,
                    width: 85,
                  ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${model['title']}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${model['startTime']} - ${model['endTime']}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      if (model['category'] != '[]')
                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color(int.parse(colors[index]))
                                      .withOpacity(0.2),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Center(
                                  child: Text(
                                    category[index],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(fontSize: 15),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              width: 10,
                            ),
                            itemCount: category.length,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                model['status'] == 'done' ?
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: second_orange_color,
                      child: const Icon(Icons.check_outlined, color: Colors.white, size: 26,),
                    ):
                Column(
                  children: [
                    Row(
                      children: [
                        defaultCircleButton(
                          radius: 32,
                          function: () {
                            AppCubit.get(context)
                                .updateDate(status: 'new', id: model['id']);
                          },
                          icon: Icons.home_filled,
                          context: context,
                          iconColor: Colors.white,
                          background: second_Cyan_color,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        defaultCircleButton(
                          radius: 32,
                          function: () {
                            AppCubit.get(context)
                                .updateDate(status: 'done', id: model['id']);
                          },
                          icon: Icons.check_circle_outline_outlined,
                          context: context,
                          iconColor: Colors.white,
                          background: Colors.green,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        defaultCircleButton(
                          radius: 32,
                          function: () {
                            AppCubit.get(context).updateDate(
                                status: 'archive', id: model['id']);
                          },
                          icon: Icons.archive_outlined,
                          context: context,
                          iconColor: Colors.white,
                          background: second_orange_color,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        defaultCircleButton(
                          radius: 32,
                          function: () {
                            AppCubit.get(context).deleteData(id: model['id']);
                          },
                          icon: Icons.delete,
                          context: context,
                          iconColor: Colors.white,
                          background: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    onDismissed: (direction) {
      AppCubit.get(context).deleteData(id: model['id']);
    },
  );
}

Widget defaultCircularMenu(BuildContext context, Map model) => CircularMenu(
      toggleButtonColor: Colors.pink,
      alignment: Alignment.bottomRight,
      toggleButtonSize: 20,
      toggleButtonOnPressed: () {
        AppCubit.get(context).changeCircularMenuClipType();
      },
      items: [
        CircularMenuItem(
          iconSize: 20,
          onTap: () {
            AppCubit.get(context).deleteData(id: model['id']);
          },
          icon: Icons.delete,
          color: Colors.red,
        ),
        CircularMenuItem(
          iconSize: 20,
          onTap: () {
            AppCubit.get(context).updateDate(status: 'new', id: model['id']);
          },
          icon: Icons.home_filled,
          color: second_Cyan_color,
        ),
        CircularMenuItem(
          iconSize: 20,
          onTap: () {
            AppCubit.get(context)
                .updateDate(status: 'new', id: model['archive']);
          },
          icon: Icons.archive_outlined,
          color: second_orange_color,
        ),
        CircularMenuItem(
          iconSize: 20,
          onTap: () {
            AppCubit.get(context).updateDate(status: 'new', id: model['done']);
          },
          icon: Icons.check_circle_outline_outlined,
          color: Colors.green,
        ),
      ],
    );

Widget buildHeaderAccountData(BuildContext context) => Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello,',
              style: TextStyle(fontSize: 25, color: Colors.grey[600]),
            ),
            Text(
              '${AppCubit.get(context).userModel!.name}',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          width: 65,
          height: 70,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Image(
            fit: BoxFit.cover,
            image: NetworkImage(
              '${AppCubit.get(context).userModel!.image}',
            ),
          ),
        ),
      ],
    );
