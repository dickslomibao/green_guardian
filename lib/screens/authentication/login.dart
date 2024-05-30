import 'package:etr_mark/helper.dart';
import 'package:etr_mark/screens/authentication/register.dart';
import 'package:etr_mark/screens/restarter_widget.dart';
import 'package:etr_mark/theme.dart';
import 'package:etr_mark/widgets/button_widget.dart';
import 'package:etr_mark/widgets/password_field_widget.dart';
import 'package:etr_mark/widgets/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Image.asset('assets/logo/logo.png'),
                    const Text(
                      "Welcome back",
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
                      "Login your account",
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
                    ButtonWidget(
                      onPressed: login,
                      title: 'Login',
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Register",
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
      ),
    );
  }

  void login() async {
    try {
      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();
      if (!validateLoginForm(email: email, password: password)) {
        return;
      }
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (context.mounted) {
        RestartWidget.restartApp(context);
      }
    } on FirebaseAuthException catch (e) {
      firebaseAuthExceptionHandler(e);
    }
  }
}
