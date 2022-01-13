import 'package:flutter/cupertino.dart';
import 'package:todo_app/modules/login/login_screen.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/network/local/cache_helper.dart';

void signOut(BuildContext context) {
  CacheHelper.removeData(key: 'uId').then((value) {
    if (value == true) {
      uId = '';
      navigateAndFinish(context, LoginScreen());
      AppCubit.get(context).changeIndex(0);
    }
  });
}

String? uId = '';

List<String> weekDates = [];