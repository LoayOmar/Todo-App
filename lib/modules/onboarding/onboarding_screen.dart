import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:todo_app/modules/login/login_screen.dart';
import 'package:todo_app/modules/register/register_screen.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/network/local/cache_helper.dart';
import 'package:todo_app/shared/styles/colors.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<BoardingModel> boarding = [
    BoardingModel(
      image: 'assets/images/manage.jpg',
      title: 'Manage Your Time',
      body:
          'It is very difficult to manage everything, find your virtual Manager today for manage your work & time.',
    ),
    BoardingModel(
      image: 'assets/images/virtual_manager.jpg',
      title: 'Your Virtual Manager',
      body:
          'It is very difficult to manage everything, find your virtual Manager today for manage your work & time.',
    ),
    BoardingModel(
      image: 'assets/images/work_on_time.jpg',
      title: 'Work On Time',
      body:
          'It is very difficult to manage everything, find your virtual Manager today for manage your work & time.',
    ),
    BoardingModel(
      image: 'assets/images/done.jpg',
      title: 'End Tasks',
      body:
          'It is very difficult to manage everything, find your virtual Manager today for manage your work & time.',
    ),
  ];

  PageController boardController = PageController();

  bool isLast = false;

  void submit(Widget widget){
    CacheHelper.saveData(key: 'onBoarding', value: true,).then((value) {
      if(value){
        navigateAndFinish(
          context,
          widget,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    defaultButton(
                      function: () {
                        submit(LoginScreen());
                      },
                      text: 'Skip',
                      textColor: HexColor("#FDFEFE"),
                      context: context,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          first_orange_color,
                          second_orange_color,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.only(
                      bottomEnd: Radius.circular(20),
                      bottomStart: Radius.circular(20),
                    ),
                    color: Colors.white.withOpacity(0.9),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          physics: BouncingScrollPhysics(),
                          onPageChanged: (index) {
                            if (index == boarding.length - 1) {
                              setState(() {
                                isLast = true;
                              });
                            } else {
                              setState(() {
                                isLast = false;
                              });
                            }
                          },
                          controller: boardController,
                          itemBuilder: (context, index) =>
                              buildBoardingItem(boarding[index]),
                          itemCount: boarding.length,
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: defaultCircleButton(
                          function: () {
                            if (isLast) {
                              submit(LoginScreen());
                            } else {
                              boardController.nextPage(
                                duration: Duration(
                                  milliseconds: 750,
                                ),
                                curve: Curves.fastLinearToSlowEaseIn,
                              );
                            }
                          },
                          icon: Icons.arrow_forward_outlined,
                          context: context,
                          radius: 55,
                          elevation: 20,
                          iconColor: Colors.white.withOpacity(0.8),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.red.withOpacity(0.4),
                              Colors.red,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: defaultButton(
                        function: () {
                          submit(RegisterScreen());
                        },
                        text: 'Sign Up',
                        context: context,
                        background: Colors.white,
                        textColor: second_Cyan_color,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: defaultButton(
                        function: () {
                          submit(LoginScreen());
                        },
                        text: 'Log in',
                        context: context,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            first_Cyan_color,
                            second_Cyan_color,
                          ],
                        ),
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
        children: [
          Expanded(
            flex: 3,
            child: Image(
              image: AssetImage('${model.image}'),
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    '${model.title}',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                  Text(
                    '${model.body}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          color: Colors.grey[500],
                          fontSize: 15,
                        ),
                  ),
                  SizedBox(height: 10,),
                  SmoothPageIndicator(
                    effect: ExpandingDotsEffect(
                      dotColor: second_Cyan_color.withOpacity(0.3),
                      activeDotColor: second_Cyan_color,
                      dotHeight: 7,
                      expansionFactor: 2,
                      dotWidth: 7,
                      spacing: 5,
                    ),
                    controller: boardController,
                    count: boarding.length,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}