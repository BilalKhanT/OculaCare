import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  TextEditingController userController;
  TextEditingController passController;
  GlobalKey<FormState> formKey;

  LoginForm(
      {Key? key,
      required this.userController,
      required this.passController,
      required this.formKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: userController,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter a username';
              }
              return null;
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.person,
              ),
              hintText: "Enter Username",
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: passController,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter a password';
              }
              return null;
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
              ),
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.visibility_off),
              ),
              hintText: "Enter Password",
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
