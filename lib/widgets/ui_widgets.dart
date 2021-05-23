import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:trove_app/extras/app_colors.dart';
import 'package:sizer/sizer.dart';

class WelcomeUser extends StatelessWidget {
  final String boldText;
  final String boldSubText;
  WelcomeUser({@required this.boldText, @required this.boldSubText});
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(left: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$boldText,',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 40.0,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            boldSubText,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 30.0,
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
  TextInputField(
      {@required this.labelText,
      this.validator,
      this.shouldObscureText = false,
      this.onSaved});

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

class BottomText extends StatefulWidget {
  final String firstText, secondText;
  final Function onPressed;
  BottomText(
      {@required this.firstText, @required this.secondText, this.onPressed});
  @override
  _BottomTextState createState() => _BottomTextState();
}

class _BottomTextState extends State<BottomText> {
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

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50.0.h,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0),
          ),
        ),
        // color: Colors.black.withOpacity(0.8),
        padding: EdgeInsets.only(left: 2.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 5.0.h),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 6.0.h,
                    bottom: 10.0.h,
                    left: 0.1.h,
                    right: 1.5.h,
                  ),
                  child: CircleAvatar(
                    radius: 5.0.h,
                    child: Icon(Icons.verified_user),
                  ),
                ),
                InAppGreet()
              ],
            ),

            ListTile(
              title: Text(
                'First screen',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0.sp,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'First screen',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0.sp,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'First screen',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0.sp,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'First screen',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InAppGreet extends StatelessWidget {
  final Color topTextColor, bottomTextColor;
  InAppGreet({this.topTextColor, this.bottomTextColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        text: TextSpan(
            text: 'Good Morning \n',
            style: TextStyle(
              color: topTextColor,
              fontSize: 8.0.sp,
              fontFamily: 'OpenSans',
              // fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: 'Henry',
                style: TextStyle(
                  color: bottomTextColor,
                  fontSize: 12.0.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ]),
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.0.h, right: 1.0.h),
      child: Container(
        width: double.infinity,
        height: 7.0.h,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
          color: AppColors.greyWhite,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 10.0.w,
              child: Icon(
                Icons.search,
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: TextField(
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  // focusedBorder: InputBorder.none,
                  // enabledBorder: InputBorder.none,
                  // errorBorder: InputBorder.none,
                  // disabledBorder: InputBorder.none,
                  hintText: "Search for products",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DailyDealsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 1.0.h),
      child: Container(
        height: 38.0.h,
        width: 28.0.h,
        child: Column(
          children: [
            // img container
            Stack(
              children: [
                Container(
                  height: 27.0.h,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
                        scale: 1.0,
                      ),
                    ),
                  ),
                ),

                // item options container
                ItemOptions(),
              ],
            ),

            // item details
            Expanded(
              //expanded to make the detail container take up remaining space in cards container
              child: SizedBox(
                child: Container(
                  width: 28.0.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('iPhone XR 8GB RAM\n 128GB ROM Crystal', style: TextStyle(fontWeight: FontWeight.w900)),
                      Text('300,000', style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.0,
      child: Container(
        width: 30.0.h,
        height: 8.5.h,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.50),
        ),
        // options
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // add to cart
            Container(
              height: 6.0.h,
              width: 18.0.h,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.3),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.blue,
                    size: 3.0.h,
                  ),
                  SizedBox(width: 1.0.h),
                  Text(
                    'Add to cart',
                    style: TextStyle(color: Colors.blue, fontSize: 1.5.h),
                  ),
                ],
              ),
            ),

            //
            SizedBox(width: 1.0.h),

            // favorite
            Container(
              height: 6.0.h,
              width: 6.0.h,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.3),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: IconButton(
                // padding and constraints help remove default padding
                // in IconButton
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PopularCategoriesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 0.5.h, right: 0.5.h),
      child: Container(
        height: 12.5.h,
        width: 33.0.h,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(
              'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
              scale: 1.0,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.65), Colors.transparent],
                stops: [0.1, 1.0]),
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(1.0.h),
              child: Text(
                'Apple',
                style: TextStyle(
                  fontSize: 2.0.h,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}