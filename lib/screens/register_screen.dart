import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartwin/components/button_animated.dart' hide ScaleAnimation;
import 'package:smartwin/components/logo.dart';
import 'package:smartwin/components/text_field.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smartwin/cubit/auth/auth_cubit.dart';
import 'package:smartwin/screens/login_screen.dart';
import 'package:smartwin/screens/main_screen.dart';
import 'package:smartwin/screens/otp_screen.dart';
import 'package:smartwin/theme/colors.dart';

import '../components/helpers.dart';

class RegisterScreen extends HookWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var fullNameController = useTextEditingController();
    var phoneController = useTextEditingController();

    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Logo(
              width: getScreenSize(context).width,
              height: getScreenSize(context).height * 0.25,
            ),
            const Text(
              "إنشاء حساب",
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              "عليك انشاء حساب للمتابعة للتطبيق",
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Color.fromARGB(255, 183, 183, 183),
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: getScreenSize(context).height * 0.3,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 350),
                    childAnimationBuilder: (widget) => ScaleAnimation(
                      scale: 0.0,
                      child: widget,
                    ),
                    children: [
                      MyTextField(
                        controller: fullNameController,
                        prefix: const Icon(Icons.person),
                        lable: const Text(
                          "الاسم الكامل",
                        ),
                      ),
                      MyTextField(
                        controller: phoneController,
                        prefix: const Icon(Icons.phone),
                        lable: const Text(
                          "رقم الهاتف",
                        ),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              width: getScreenSize(context).width,
              child: AnimatedButton(
                  scaleAnimation: false,
                  translateAnimation: false,
                  onTap: () {
                    context.read<AuthCubit>().register(
                          fullName: fullNameController.text.trim(),
                          phone: phoneController.text.trim(),
                        );
                  },
                  margin: const EdgeInsets.all(20),
                  child: Center(
                    child: BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is AuthSuccess) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OTPScreen(
                                        phoneNumber:
                                            phoneController.text.trim(),
                                      )),
                              (route) => false);
                        } else if (state is AuthError) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Error'),
                              content: Text(state.error),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return const Text(
                            'إنشاء',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          );
                        }
                      },
                    ),
                  )),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "لديك حساب بالفعل؟",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: const Text(
                      "تسجيل الدخول",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
