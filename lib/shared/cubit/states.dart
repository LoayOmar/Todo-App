abstract class AppStates{}

class AppInitialState extends AppStates{}

class AppChangeBottomNavBarState extends AppStates{}

class AppCreateDatabaseState extends AppStates{}

class AppGetDatabaseState extends AppStates{}

class AppGetDatabaseLoadingState extends AppStates{}

class AppInsertDatabaseState extends AppStates{}

class AppUpdateDatabaseState extends AppStates{}

class AppDeleteDatabaseState extends AppStates{}

class AppChangeBottomSheetState extends AppStates{}

class AppChangeModeState extends AppStates {}

class AddCategoryState extends AppStates {}

class ChangeCategoryColorState extends AppStates {}

class ChangeDateState extends AppStates {}

class ChangeStartTimeState extends AppStates {}

class ChangeEndTimeState extends AppStates {}

class ChangeCategoryColorBoolState extends AppStates {}

class ChangeCircularMenuClipTypeState extends AppStates {}

class AppGetUserLoadingStates extends AppStates {}

class AppGetUserSuccessStates extends AppStates {}

class AppGetUserErrorStates extends AppStates {
  final String error;

  AppGetUserErrorStates(this.error);
}

class AppProfileImagePickedSuccessState extends AppStates {}

class AppProfileImagePickedErrorState extends AppStates {}

class AppUserUpdateProfileLoadingState extends AppStates {}

class AppUploadProfileImageSuccessState extends AppStates {}

class AppUploadProfileImageErrorState extends AppStates {}

class AppUserUpdateLoadingState extends AppStates {}

class AppUserUpdateErrorState extends AppStates {}

class AppTaskImagePickedSuccessState extends AppStates {}

class AppTaskImagePickedErrorState extends AppStates {}

class AppUserUploadTaskImageLoadingState extends AppStates {}

class AppUploadTaskImageSuccessState extends AppStates {}

class AppUploadTaskImageErrorState extends AppStates {}