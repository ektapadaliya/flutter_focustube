import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/otp_field.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:intl/intl.dart';

class VerificationVC extends StatefulWidget {
  static const id = "/email-verification";
  static const forgotPasswordId = "/forgot-password-verification";
  final bool isFromForgotPassword;
  const VerificationVC({super.key, this.isFromForgotPassword = false});

  @override
  State<VerificationVC> createState() => _VerificationVCState();
}

class _VerificationVCState extends State<VerificationVC> {
  Timer? resendOTPtimer;

  String verificationCode = "";
  int timerTick = 00;
  void startTimer() {
    timerTick = 60;
    resendOTPtimer = Timer.periodic(Duration(seconds: 1), (timer) {
      timerTick -= 1;
      if (timerTick <= 0) {
        timer.cancel();
        resendOTPtimer = null;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: customAppBar(context),
      body: ExpandedSingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: FormScreenBoundries(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isFromForgotPassword
                    ? "Forgot your password!"
                    : "Verify your email address!",
                style: AppTextStyle.title28(),
              ),
              Text(
                "Verify your OTP and ${widget.isFromForgotPassword ? 'reset your password' : 'confirm your email'}.",
                style: AppTextStyle.body18(color: AppColor.gray),
              ),
              SizedBox(height: 25),
              Expanded(child: Container()),
              Center(
                child: Text(
                  "One-time Password (OTP)",
                  style: AppTextStyle.title20(),
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: Text(
                  "Please enter 4 digit number sent to your email",
                  style: AppTextStyle.body16(color: AppColor.gray),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 60,
                child: AnimatedOtpInput(
                  length: 4,
                  fieldWidth: 60,
                  theme: OtpInputTheme(
                    fillColor: AppColor.tileBackground,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColor.borderColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.primary, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      verificationCode = value;
                    });
                    if (value.length == 4) {
                      // Press Enter after filling last digit
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text.rich(
                  (timerTick > 0)
                      ? TextSpan(
                          text: "Resend OTP in ",
                          style: AppTextStyle.body16(color: AppColor.gray),
                          children: [
                            TextSpan(
                              text: DateFormat(
                                "mm:ss",
                              ).format(DateTime(1990, 1, 1, 0, 0, timerTick)),
                              style: AppTextStyle.body16(),
                            ),
                          ],
                        )
                      : TextSpan(
                          text: "Didn’t receive the OTP? ",
                          style: AppTextStyle.body16(color: AppColor.gray),
                          children: [
                            TextSpan(
                              text: "Resend",
                              style: AppTextStyle.body16().copyWith(
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = timerTick == 0
                                    ? () async {
                                        startTimer();
                                      }
                                    : null,
                            ),
                          ],
                        ),
                ),
              ),
              Expanded(flex: 3, child: Container()),
              SizedBox(height: 30),
              AppButton(
                label: "Verify and Continue",
                backgroundColor: AppColor.primary,
                onTap: () {
                  if (widget.isFromForgotPassword) {
                    resetPassword.replace(context);
                  } else {
                    chooseYourInteres.go(context);
                  }
                },
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
