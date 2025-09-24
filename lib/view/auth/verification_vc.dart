import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/otp_field.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

class VerificationVC extends StatefulWidget {
  static const id = "/email-verification";
  const VerificationVC({super.key});

  @override
  State<VerificationVC> createState() => _VerificationVCState();
}

class _VerificationVCState extends State<VerificationVC> {
  String verificationCode = "";
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: customAppBar(context),
      body: ExpandedSingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Forgot your password!", style: AppTextStyle.title28),
            Text(
              "Verify your OTP and reset your password.",
              style: AppTextStyle.body18.copyWith(color: AppColor.gray),
            ),
            SizedBox(height: 25),
            Expanded(child: Container()),
            Center(
              child: Text(
                "One-time Password (OTP)",
                style: AppTextStyle.title20,
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                "Please enter 4 digit number sent to your email",
                style: AppTextStyle.body16.copyWith(color: AppColor.gray),
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
                  fillColor: AppColor.textFieldBackground,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.textFieldBorder,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.black, width: 2),
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
                TextSpan(
                  text: "Didn’t receive the OTP? ",
                  style: AppTextStyle.body16.copyWith(color: AppColor.gray),
                  children: [
                    TextSpan(
                      text: "Resend",
                      style: AppTextStyle.body16.copyWith(
                        color: AppColor.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(flex: 3, child: Container()),
            SizedBox(height: 30),
            AppButton(
              label: "Verify and Continue",
              backgroundColor: AppColor.black,
              onTap: () {
                resetPassword.replace(context);
              },
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
