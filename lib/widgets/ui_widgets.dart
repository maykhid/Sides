import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:trove_app/extras/app_colors.dart';
import 'package:sizer/sizer.dart';

class WelcomeUser extends StatelessWidget {
  final String boldText;
  final String boldSubText;
  final double fontSize;

  WelcomeUser({
    @required this.boldText,
    @required this.boldSubText,
    this.fontSize = 25.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(left: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          Text(
            '$boldText,',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 24.0.sp,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w600,
            ),
          ),
          //
          Text(
            boldSubText,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                fontFamily: 'OpenSans',
                color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class TextInputField extends StatelessWidget {
  final String labelText;
  final FormFieldValidator<String> validator;
  final bool shouldObscureText;
  final FormFieldSetter<String> onSaved;
  //
  TextInputField({
    @required this.labelText,
    this.validator,
    this.shouldObscureText = false,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        decoration: _getTextFieldDeco(labelText),
        validator: validator,
        obscureText: shouldObscureText,
        onSaved: onSaved,
      ),
    );
  }
}

InputDecoration _getTextFieldDeco(String labelText) {
  return InputDecoration(
    focusedBorder: OutlineInputBorder(
      // remember width: 0.0 produces a thin "hairline" border
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: AppColors.pink, width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      // remember width: 0.0 produces a thin "hairline" border
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
    ),
    labelText: labelText,
    labelStyle: TextStyle(color: Colors.grey),
  );
}

class AuthScreenBottomText extends StatefulWidget {
  final String firstText, secondText;
  final Function onPressed;
  AuthScreenBottomText({
    @required this.firstText,
    @required this.secondText,
    this.onPressed,
  });
  @override
  _AuthScreenBottomTextState createState() => _AuthScreenBottomTextState();
}

class _AuthScreenBottomTextState extends State<AuthScreenBottomText> {
  TapGestureRecognizer _tapRecognizer;
  @override
  void initState() {
    super.initState();
    _tapRecognizer = TapGestureRecognizer()..onTap = widget.onPressed;
  }

  @override
  void dispose() {
    _tapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        text: TextSpan(
            text: '${widget.firstText}?  ',
            style: TextStyle(color: Colors.black38),
            children: [
              TextSpan(
                  text: '${widget.secondText} ->',
                  style: TextStyle(color: AppColors.pink),
                  recognizer: _tapRecognizer),
            ]),
      ),
    );
  }
}
