import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/todo_layout_screen.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/modules/login/cubit/cubit.dart';
import 'package:todo_app/modules/login/cubit/states.dart';
import 'package:todo_app/modules/register/register_screen.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/network/local/cache_helper.dart';
import 'package:todo_app/shared/styles/colors.dart';

class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId);
            navigateAndFinish(context, TodoScreen(),);
          }

          if(state is LoginErrorState) {
            showToast(text: state.error.toString(), state: ToastStates.ERROR,);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Container(
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
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login',
                            style:
                                Theme.of(context).textTheme.headline4?.copyWith(
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
                                LoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            label: 'Password',
                            prefix: Icons.lock_outline,
                            suffix: LoginCubit.get(context).suffix,
                            suffixPressed: () {
                              LoginCubit.get(context).changePasswordVisibility();
                            },
                            isPassword: LoginCubit.get(context).isPassword,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          state is LoginLoadingState
                              ? Center(child: CircularProgressIndicator())
                              : Center(
                                  child: Container(
                                    width: 150,
                                    child: defaultButton(
                                      function: () {
                                        if (formKey.currentState!.validate()) {
                                          LoginCubit.get(context).userLogin(
                                            email: emailController.text,
                                            password: passwordController.text,
                                          );
                                        }
                                      },
                                      background: second_Cyan_color,
                                      text: 'Login',
                                      context: context,
                                      textColor: Colors.white,
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account?',
                              ),
                              defaultTextButton(
                                function: () {
                                  navigateAndFinish(context, RegisterScreen());
                                },
                                text: 'Register Now',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
