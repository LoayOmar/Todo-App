import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/modules/login/login_screen.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
import 'package:todo_app/shared/network/local/cache_helper.dart';
import 'package:todo_app/shared/styles/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        UserModel? userModel = cubit.userModel;
        File? profileImage = cubit.profileImage;

        return SafeArea(
          child: Scaffold(
            body: Container(
              width: double.infinity,
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
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if(cubit.profileImage != null)
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 1,
                          child: IconButton(
                            onPressed: () {
                              cubit.uploadProfileImage();
                            },
                            icon: const Icon(
                              Ionicons.save,
                            ),
                            color: second_Cyan_color,
                          ),
                        ),
                      ],
                    ),
                    if(cubit.profileImage == null)
                    const SizedBox(
                      height: 40,
                    ),
                    Column(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          child: Stack(
                            children: [
                              Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: Image(
                                  fit: BoxFit.cover,
                                  image: profileImage == null ? NetworkImage('${userModel!.image}') : FileImage(profileImage) as ImageProvider,
                                ),
                              ),
                              Align(
                                child: defaultCircleButton(
                                  radius: 30,
                                  function: () {
                                    cubit.getProfileImage();
                                  },
                                  icon: Icons.edit,
                                  background: Colors.white,
                                  context: context,
                                ),
                                alignment: AlignmentDirectional.bottomEnd,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${userModel!.name}',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadiusDirectional.only(
                            topStart: Radius.circular(30),
                            topEnd: Radius.circular(30),
                          ),
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                child: defaultButton(
                                  function: () {
                                    signOut(context);
                                  },
                                  text: 'Sign Out',
                                  context: context,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
