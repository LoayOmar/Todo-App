import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/modules/archive/arcvive_screen.dart';
import 'package:todo_app/modules/done/done_screen.dart';
import 'package:todo_app/modules/home/home_screen.dart';
import 'package:todo_app/modules/profile/profile_screen.dart';
import 'package:todo_app/modules/tasks/tasks_screen.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/states.dart';
import 'package:todo_app/shared/network/local/cache_helper.dart';
import 'package:todo_app/shared/styles/colors.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;



class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  DateTime date = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = (TimeOfDay.now()).replacing(hour: TimeOfDay.now().hour + 2);
  String timeZone = "GMT+6";


  void changeDate (DateTime newDate) {
    date = newDate;
    emit(ChangeDateState());
  }

  void changeStartTime (TimeOfDay newStartTime) {
    startTime = newStartTime;
    emit(ChangeStartTimeState());
  }

  void changeEndTime (TimeOfDay newEndTime) {
    endTime = newEndTime;
    emit(ChangeEndTimeState());
  }

  List<Widget> category = [

  ];

  void addCategoryItem (Widget widget) {
    category.insert(category.length - 1, widget);
    emit(AddCategoryState());
  }

  List<String> categoryNames = [];
  List<Color> categoryColors = [];

  Color categoryColor = first_orange_color;

  void changeCategoryColor (Color color) {
    categoryColor = color;
    emit(ChangeCategoryColorState());
  }

  List<bool> categoryColorBool = [true, false, false, false, false, false, false, false];

  void changeCategoryColorBool (index) {
    for (int i = 0 ; i<8 ; i++) {
      categoryColorBool[i] = false;
    }
    categoryColorBool[index] = true;
    emit(ChangeCategoryColorBoolState());
  }

  int currentIndex = 0;

  late Database database;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  bool isBottomSheetShown = false;

  List<Widget> screens = [
    HomeScreen(),
    TasksScreen(),
    DoneScreen(),
    ArchiveScreen(),
    ProfileScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  Clip clip = Clip.hardEdge;

  void changeCircularMenuClipType() {
    if(clip == Clip.none){
      clip = Clip.hardEdge;
    } else {
      clip = Clip.none;
    }
    emit(ChangeCircularMenuClipTypeState());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, uId TEXT, title TEXT, imageUrl TEXT, description TEXT, date TEXT, timeZone TEXT, startTime TEXT, endTime TEXT, category TEXT ARRAY, categoryColor TEXT ARRAY, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertDatabase({
    required String uId,
    required String title,
    required String description,
    required BuildContext context,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
          'INSERT INTO tasks(uId, title, imageUrl, description, date, timeZone, startTime, endTime, category, categoryColor, status) VALUES("$uId", "$title", "$taskImageUrl", "$description", "${DateFormat.yMMMd().format(date)}", "$timeZone", "${startTime.format(context).toString()}", "${endTime.format(context).toString()}", "$categoryNames", "$categoryColors", "new")')
          .then((value) {
        print('$value inserted successfully');
        taskImageUrl = null;
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });

      return null;
    });
  }

  void getDataFromDatabase(database) {
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      print(value);
      newTasks = [];
      doneTasks = [];
      archiveTasks = [];

      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      });

      emit(AppGetDatabaseState());
    });
  }

  void updateDate({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    required int id,
  }) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);

    getDataFromDatabase(database);

    emit(AppDeleteDatabaseState());
  }

  void changeBottomSheetState({required bool isShow}) {
    isBottomSheetShown = isShow;

    emit(AppChangeBottomSheetState());
  }

  bool isDark = false;

  void changeAppMode({bool? fromShared}){
    if(fromShared != null){
      isDark = fromShared;
      emit(AppChangeModeState());
    }else {
      isDark = !isDark;
      CacheHelper.saveData(key: 'isDark', value: isDark).then((value) => emit(AppChangeModeState()));
    }

  }

  UserModel? userModel;

  void getUserData() {
    emit(AppGetUserLoadingStates());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(AppGetUserSuccessStates());
    }).catchError((error) {
      emit(AppGetUserErrorStates(error.toString()));
    });
  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(AppProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(AppProfileImagePickedErrorState());
    }
  }

  void uploadProfileImage() {
    emit(AppUserUpdateProfileLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(SocialUploadProfileImageSuccessState());
        updateUser(image: value);
      }).catchError((error) {
        emit(AppUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(AppUploadProfileImageErrorState());
    });
  }

  void updateUser({
    String? image,
  }) {
    emit(AppUserUpdateLoadingState());

    UserModel model = UserModel(
      name: userModel!.name,
      phone: userModel!.phone,
      email: userModel!.email,
      image: image,
      uId: userModel!.uId,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      profileImage = null;
      getUserData();
    }).catchError((error) {
      emit(AppUserUpdateErrorState());
    });
  }

  File? taskImage;

  Future<void> getTaskImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      taskImage = File(pickedFile.path);
      emit(AppTaskImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(AppTaskImagePickedErrorState());
    }
  }

  String? taskImageUrl;

  void uploadTaskImage() {
    emit(AppUserUploadTaskImageLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('tasks/${Uri.file(taskImage!.path).pathSegments.last}')
        .putFile(taskImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        taskImageUrl = value;
        taskImage = null;
        emit(AppUploadTaskImageSuccessState());
      }).catchError((error) {
        emit(AppUploadTaskImageErrorState());
      });
    }).catchError((error) {
      emit(AppUploadTaskImageErrorState());
    });
  }
}
