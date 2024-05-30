import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etr_mark/helper.dart';
import 'package:etr_mark/screens/restarter_widget.dart';
import 'package:etr_mark/theme.dart';
import 'package:etr_mark/widgets/button_widget.dart';
import 'package:etr_mark/widgets/password_field_widget.dart';
import 'package:etr_mark/widgets/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  var obscurePassword = true;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  final collectionPath = 'users';

  Future<void> createAnAccount({required Function onSuccess}) async {
    String fullName = nameController.text.trim();
    String email = emailController.text.trim();

    String password = passwordController.text.trim();
    String passwordConfirmation = passwordConfirmationController.text.trim();
    if (!validateRegistrationForm(
        email: email,
        fullName: fullName,
        password: password,
        passwordConfirmation: passwordConfirmation)) {
      return;
    }
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      String uid = userCredential.user!.uid;
      await userCredential.user!.updateDisplayName(fullName);
      await FirebaseFirestore.instance.collection(collectionPath).doc(uid).set({
        'name': fullName,
        'email': email,
      });
      onSuccess();
    } on FirebaseAuthException catch (ex) {
      firebaseAuthExceptionHandler(ex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Image.asset('assets/logo/logo.png'),
                  const Text(
                    "Register",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Create a new account",
                    style: TextStyle(
                      color: lightText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  TextFieldWidget(
                    controller: nameController,
                    label: "Full Name",
                    prefixIcon: const Icon(
                      Icons.person,
                      color: primaryColor,
                      size: 21,
                    ),
                  ),
                  TextFieldWidget(
                    controller: emailController,
                    label: "Email",
                    prefixIcon: const Icon(
                      Icons.email,
                      color: primaryColor,
                      size: 21,
                    ),
                  ),
                  PasswordFieldWidget(
                    controller: passwordController,
                    label: "Password",
                    prefixIcon: const Icon(
                      Icons.key,
                      color: primaryColor,
                      size: 21,
                    ),
                  ),
                  PasswordFieldWidget(
                    controller: passwordConfirmationController,
                    label: "Confirm Password",
                    marginBottom: 28,
                    prefixIcon: const Icon(
                      Icons.key,
                      color: primaryColor,
                      size: 21,
                    ),
                  ),
                  ButtonWidget(
                    onPressed: () async {
                      await createAnAccount(
                        onSuccess: () {
                          RestartWidget.restartApp(context);
                        },
                      );
                    },
                    title: 'Register',
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
