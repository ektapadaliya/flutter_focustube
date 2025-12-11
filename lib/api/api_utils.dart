class ApiUtils {
  static const domain = "www.focustube.co.in";

  static const baseUrl = "https://$domain/api/";
  static const authorizationToken = "Wxk82YrEOhSRSG5tgS7nWeT6ePufDtVNCoXBESoz";

  static const me = "${baseUrl}me";
  static const pages = "${baseUrl}pages";
  static const login = "${baseUrl}login";
  static const logout = "${baseUrl}logout";
  static const signup = "${baseUrl}signup";
  static const appInfo = "${baseUrl}app-info";
  static const verifyCode = "${baseUrl}verify-code";
  static const resendEmail = "${baseUrl}resend-email";
  static const resetPassword = "${baseUrl}reset-password";
  static const generateToken = "${baseUrl}generate-token";
  static const forgotPassword = "${baseUrl}forgot-password";
  static const signupVerifyCode = "${baseUrl}signup-verify-code";

  static const updateDailyLimit = "${baseUrl}update-daily-limit";
  static const updateNotificationPreference =
      "${baseUrl}update-notification-preference";

  static const interests = "${baseUrl}interests";
  static const updateInterest = "${baseUrl}update-interest";
  static const getUserInterests = "${baseUrl}get-user-interests";
  static const editProfile = "${baseUrl}edit-profile";

  static const changePassword = "${baseUrl}change-password";
  static const deleteAccount = "${baseUrl}delete-account";
}
