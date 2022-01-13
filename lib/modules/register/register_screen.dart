import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/todo_layout_screen.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/modules/login/login_screen.dart';
import 'package:todo_app/modules/register/cubit/cubit.dart';
import 'package:todo_app/modules/register/cubit/states.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/network/local/cache_helper.dart';
import 'package:todo_app/shared/styles/colors.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId);
            navigateAndFinish(context, MyApp(),);
          }
          if(state is RegisterErrorState){
            showToast(text: state.error.toString(), state: ToastStates.ERROR,);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.center,
                    colors: [
                      first_Background_color.withOpacity(0.2),
                      second_Background_color.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              navigateAndFinish(context, LoginScreen());
                            },
                            icon: Icon(
                              Icons.arrow_back,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Register',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      ?.copyWith(
                                        color: Colors.black,
                                      ),
                                ),
                                Text(
                                  'Login now to browse our hot offers',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                defaultTextFormField(
                                  controller: nameController,
                                  type: TextInputType.name,
                                  validate: (val) {
                                    if (val!.isEmpty) {
                                      return 'Name must not be empty';
                                    }

                                    return null;
                                  },
                                  label: 'Name',
                                  prefix: Icons.person,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultTextFormField(
                                  controller: emailController,
                                  type: TextInputType.emailAddress,
                                  validate: (val) {
                                    if (val!.isEmpty) {
                                      return 'email address must not be empty';
                                    }

                                    return null;
                                  },
                                  label: 'Email Address',
                                  prefix: Icons.email_outlined,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultTextFormField(
                                  controller: passwordController,
                                  type: TextInputType.visiblePassword,
                                  validate: (val) {
                                    if (val!.isEmpty) {
                                      return 'password must not be empty';
                                    }

                                    return null;
                                  },
                                  onSubmit: (val) {
                                    if (formKey.currentState!.validate()) {
                                      RegisterCubit.get(context).userRegister(
                                        name: nameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        phone: phoneController.text,
                                      );
                                    }
                                  },
                                  label: 'Password',
                                  prefix: Icons.lock_outline,
                                  suffix: RegisterCubit.get(context).suffix,
                                  suffixPressed: () {
                                    RegisterCubit.get(context)
                                        .changePasswordVisibility();
                                  },
                                  isPassword:
                                      RegisterCubit.get(context).isPassword,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultTextFormField(
                                  controller: phoneController,
                                  type: TextInputType.phone,
                                  validate: (val) {
                                    if (val!.isEmpty) {
                                      return 'Phone must not be empty';
                                    }

                                    return null;
                                  },
                                  label: 'Phone',
                                  prefix: Icons.phone,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                state is RegisterLoadingState
                                    ? Center(child: CircularProgressIndicator())
                                    : Center(
                                        child: Container(
                                          width: 150,
                                          child: defaultButton(
                                            function: () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                RegisterCubit.get(context)
                                                    .userRegister(
                                                  name: nameController.text,
                                                  email: emailController.text,
                                                  password:
                                                      passwordController.text,
                                                  phone: phoneController.text,
                                                );
                                              }
                                            },
                                            text: 'REGISTER',
                                            background: second_Cyan_color,
                                            context: context,
                                            textColor: Colors.white,
                                          ),
                                        ),
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
          );
        },
      ),
    );
  }
}
