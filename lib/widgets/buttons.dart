import 'package:flutter/material.dart';
import 'package:trove_app/extras/app_colors.dart';
import 'package:sizer/sizer.dart';

class Button {
  static Widget plain(
      // BuildContext context,
      {
    BuildContext context,
    Color buttonColor,
    double borderRadius = 10,
    double horizontalPadding = 2,
    double verticalPadding = 8,
    @required String label,
    double labelPadding = 10,
    double labelSize = 22,
    Color labelColor = Colors.white,
    List<Color> gradientColors,
    bool useGradient = true,
    bool useIcon = true,
    bool showLoading = false,
    Function onPressed,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: _buttonContainer(
        useGradient,
        gradientColors,
        buttonColor,
        useIcon,
        label,
        labelColor,
        showLoading,
      ),
      onTap: onPressed,
    );
  }

  // this basically serves as the button's main structure
  static Container _buttonContainer(
    bool useGradient,
    List<Color> gradientColors,
    Color buttonColor,
    bool useIcon,
    String label,
    Color labelColor,
    bool showLoading,
  ) {
    return Container(
      height: 50.0,
      // padding: EdgeInsets.only(left: 25.0, right: 25.0),
      child: Ink(
        decoration: _buttonDecoration(useGradient, gradientColors, buttonColor),
        child: Container(
          constraints: BoxConstraints(maxWidth: 100.0.w, minHeight: 50.0),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _visibility(useIcon),
              showLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 15,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // for visibility
  static Visibility _visibility(bool useIcon) {
    // decides if icon is to be shown or not, using the bool useIcon property
    return Visibility(
      child: Row(
        children: [
          Icon(
            Icons.ac_unit,
            color: AppColors.pink,
          ),
          // SizedBox(
          //   width: ScreenData.screenWidth / (ScreenData.ten * 4),
          // ),
        ],
      ),
      visible: useIcon,
    );
  }

  // for button decoration
  static BoxDecoration _buttonDecoration(
      bool useGradient, List<Color> gradientColors, Color buttonColor) {
    // logic to decide if gradient is used or not
    if (useGradient)
      return BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10.0),
      );
    else
      return BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(10.0),
      );
  }

  static Widget rounded({String buttonText, onPressed, isLoading = false}) {
    return InkWell(
      child: Container(
        height: 8.0.h,
        width: 45.0.w,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : Text(
                  buttonText,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w900),
                ),
        ),
      ),
      onTap: onPressed,
    );
  }
}
