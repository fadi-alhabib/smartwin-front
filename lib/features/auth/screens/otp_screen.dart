import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sw/common/components/button_animated.dart' hide ScaleAnimation;
import 'package:sw/common/components/logo.dart';
import 'package:sw/features/auth/cubit/auth_cubit.dart';
import 'package:sw/features/home/screens/main_screen.dart';
import 'package:sw/common/constants/colors.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../common/components/helpers.dart';

class OTPScreen extends HookWidget {
  final String phoneNumber;
  const OTPScreen({
    super.key,
    required this.phoneNumber,
  });
  @override
  Widget build(BuildContext context) {
    final pin = useState<String>('');

    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth * 0.8;
    const totalSpacing = 5 * 10; // 5 spaces between 6 boxes
    final totalBoxWidth = availableWidth - totalSpacing;
    final boxWidth = totalBoxWidth / 6;

    useEffect(() {
      log('used the effect !!');
      context.read<AuthCubit>().sendOtp(phoneNumber);
      return () {};
    }, []);

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
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
                  "التحقق من رمز OTP",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  "يرجى إدخال رمز OTP الذي أرسلناه إلى رقم هاتفك.",
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
                  height: getScreenSize(context).height * 0.2,
                  child: Center(
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: PinCodeTextField(
                        appContext: context,
                        length: 6,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: boxWidth,
                          activeFillColor: Colors.white,
                          inactiveFillColor: Colors.white,
                          selectedFillColor: Colors.white,
                          activeColor: AppColors.primaryColor,
                          inactiveColor: Colors.grey,
                          selectedColor: AppColors.primaryColor,
                        ),
                        animationDuration: const Duration(milliseconds: 300),
                        backgroundColor: Colors.transparent,
                        enableActiveFill: true,
                        onCompleted: (pinValue) {
                          pin.value = pinValue;
                        },
                        onChanged: (value) {
                          pin.value = value;
                        },
                        keyboardType: TextInputType.number,
                        autoFocus: false,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: getScreenSize(context).width,
                  child: BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthVerifyOTPSuccess) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => MainScreen()),
                            (route) => false);
                      }
                      if (state is AuthVerifyOTPError) {
                        Fluttertoast.showToast(
                          msg: state.error,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: AppColors.greyColor,
                          textColor: AppColors.redColor,
                          fontSize: 16.0,
                        );
                      }
                    },
                    builder: (context, state) {
                      return AnimatedButton(
                        scaleAnimation: false,
                        translateAnimation: false,
                        onTap: pin.value.length == 6 &&
                                state is! AuthVerifyOTPLoading
                            ? () {
                                context
                                    .read<AuthCubit>()
                                    .verifyOtp(phoneNumber, pin.value);
                              }
                            : null,
                        margin: const EdgeInsets.all(20),
                        child: state is AuthVerifyOTPLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Center(
                                child: Text(
                                  'تحقق',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                      );
                    },
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "لم تتلقَ الرمز؟",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthCubit>().sendOtp(phoneNumber);
                        },
                        child: const Text(
                          "إعادة الإرسال",
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
