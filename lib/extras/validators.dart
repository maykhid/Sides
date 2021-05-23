class EmailFieldValidator {
  static String validate(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    if (email.isEmpty) return 'Email can\'t be empty';

    if (!emailValid) return 'Email is not valid';

    return null;
  }
}

class Username {
  static String validate(String username) {
    if (username.indexOf(' ') >= 0) return 'Username contains space';
    return username.isEmpty ? 'Username can\'t be empty' : null;
  }
}

class PasswordFieldValidator {
  static String validate(String password) {
    // bool passwordValid =
    //     RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
    //         .hasMatch(password);
    if (password.isEmpty) return 'Password can\'t be empty';
    if (password.length < 8)
      return 'Password too short. Password should contain eight characters or more';
    return null;
  }
}
