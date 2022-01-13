import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/bloc_observer.dart';
import 'package:todo_app/layout/todo_layout_screen.dart';
import 'package:todo_app/modules/login/login_screen.dart';
import 'package:todo_app/modules/onboarding/onboarding_screen.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
import 'package:todo_app/shared/network/local/cache_helper.dart';
import 'package:todo_app/shared/styles/colors.dart';

import 'http_overrides.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await CacheHelper.init();

  uId = CacheHelper.getData(key: 'uId');
  print('Cache $uId');

  HttpOverrides.global = MyHttpOverrides();

  DateTime date = DateTime.now();
  int start = 7 - date.weekday;
  int end = date.weekday;
  if(end == 7 || weekDates.isEmpty){
    for(int i = 0 ; i < start ; i++){
      weekDates.add(DateFormat.yMMMd().format(date).replaceAll(date.day.toString(), (date.day - start + i).toString()));
    }
    for(int i = 0 ; i < end ; i++){
      weekDates.add(DateFormat.yMMMd().format(date).replaceAll(date.day.toString(), (date.day + i).toString()));
    }
    print(weekDates);
  }

  BlocOverrides.runZoned(
        () => runApp(const MyApp()),
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool? onBoarding = CacheHelper.getData(key: 'onBoarding');

    return BlocProvider(
      create: (context) => AppCubit()..getUserData()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                titleSpacing: 20,
                backgroundColor: Colors.white,
                elevation: 0,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Jannah',
                  fontWeight: FontWeight.bold,
                ),
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.white,
                    statusBarIconBrightness: Brightness.dark),
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: defaultColor,
                unselectedItemColor: Colors.grey,
                elevation: 20,
                backgroundColor: Colors.white,
              ),
              primarySwatch: defaultColor,
              textTheme: const TextTheme(
                bodyText1: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                subtitle1: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),
              fontFamily: 'Jannah'
          ),
          home: onBoarding == null ? const OnBoardingScreen() : uId == null ? LoginScreen() : const TodoScreen(),
        );
        },
      ),
    );
  }
}


