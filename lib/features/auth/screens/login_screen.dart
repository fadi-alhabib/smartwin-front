import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sw/common/components/button_animated.dart';
import 'package:sw/common/components/logo.dart';
import 'package:sw/common/components/text_field.dart';
import 'package:sw/features/auth/screens/register_screen.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sw/features/auth/screens/otp_screen.dart';
import 'package:sw/common/constants/colors.dart';

import '../../../common/components/helpers.dart';

class LoginScreen extends HookWidget {
  LoginScreen({super.key});
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var phoneController = useTextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Logo(
                  width: getScreenSize(context).width,
                  height: getScreenSize(context).height * 0.25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: getScreenSize(context).height * 0.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "تسجيل الدخول",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "سجل دخولك للمتابعة للتطبيق",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: AppColors.greyColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MyTextField(
                          controller: phoneController,
                          prefix: const Icon(Icons.phone),
                          lable: const Text(
                            "رقم الهاتف",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 45,
                ),
                SizedBox(
                  width: getScreenSize(context).width / 1.4,
                  child: AnimatedButton(
                      scaleAnimation: false,
                      translateAnimation: false,
                      onTap: () {
                        if (formkey.currentState!.validate()) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => OTPScreen(
                                    phoneNumber: phoneController.text.trim(),
                                  )));
                        }
                      },
                      margin: const EdgeInsets.symmetric(),
                      child: const Center(
                        child: Text(
                          'تسجيل دخول',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "لا تملك حساب ؟",
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
                                  builder: (context) =>
                                      const RegisterScreen()));
                        },
                        child: const Text(
                          "انشاء حساب",
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
        ),
      ),
    );
  }
}
