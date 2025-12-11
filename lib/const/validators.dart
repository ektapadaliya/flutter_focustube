class Validators {
  static const emailValidation = "Please enter valid email";
  static passwordValidation({String field = "Password"}) =>
      "$field must be at least 8 characters long, contain at least one uppercase letter, one lowercase letter, one number, and one special character.";
  static nameValidation(String field) =>
      "$field must be at least 2 characters long and at most 20 characters long.";
  static const codeValidation = "OTP must be 4 characters long.";
}

extension ValidatorsExtension on String {
  //Email Validator
  bool get isEmail => RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  ).hasMatch(this);

  //Password Validator
  bool get isPassword => RegExp(
    r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$",
  ).hasMatch(this);

  //Name Validator
  bool get nameValidator =>
      RegExp(r"^[a-zA-Z0-9]+$").hasMatch(this) && length >= 2 && length <= 20;

  //Code Validator
  bool get codeValidator => length == 4;
}
