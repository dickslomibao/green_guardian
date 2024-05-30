import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etr_mark/const.dart';
import 'package:etr_mark/helper.dart';
import 'package:etr_mark/provider/user_controller.dart';
import 'package:etr_mark/screens/restarter_widget.dart';
import 'package:etr_mark/theme.dart';
import 'package:etr_mark/widgets/button_widget.dart';
import 'package:etr_mark/widgets/password_field_widget.dart';
import 'package:etr_mark/widgets/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final keyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final watch = context.read<UserController>();
    fullNameController.text = watch.fullName;
    emailController.text = watch.email;
    currentPasswordController.text = "";
    passwordController.text = "";
    confirmPasswordController.text = "";
    keyController.text = apiKey;
    print(apiKey);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: whiteText),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Information Details',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFieldWidget(
                controller: fullNameController,
                label: 'Full Name',
              ),
              const SizedBox(
                height: 12,
              ),
              ButtonWidget(
                onPressed: () async {
                  String fullName = fullNameController.text.trim();
                  if (fullName.isEmpty) {
                    handleToastError('Full Name is required.');
                    return;
                  }
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                    'name': fullName,
                  });
                  if (context.mounted) {
                    context.read<UserController>().getUserData();
                  }
                  handleToastSuccess('Updated Successfully');
                },
                title: 'Save Changes',
              ),
              const SizedBox(
                height: 36,
              ),
              Container(
                height: 1,
                width: double.infinity,
                color: primaryColor,
              ),
              const SizedBox(
                height: 18,
              ),
              const Text(
                'Change Password',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              PasswordFieldWidget(
                controller: currentPasswordController,
                label: 'Current Password',
              ),
              PasswordFieldWidget(
                controller: passwordController,
                label: 'New Password',
              ),
              PasswordFieldWidget(
                controller: confirmPasswordController,
                label: 'Confirm new Password',
              ),
              const SizedBox(
                height: 12,
              ),
              ButtonWidget(
                onPressed: () async {
                  String currentPassword =
                      currentPasswordController.text.trim();
                  String password = passwordController.text.trim();
                  String changePassword = confirmPasswordController.text.trim();

                  if (!validateChangePasswordForm(
                    currentPassword: currentPassword,
                    password: password,
                    passwordConfirmation: changePassword,
                  )) {
                    return;
                  }
                  try {
                    final user = FirebaseAuth.instance.currentUser;
                    final cred = EmailAuthProvider.credential(
                      email: watch.email,
                      password: currentPassword,
                    );
                    await user!.reauthenticateWithCredential(cred);
                    await user.updatePassword(password);
                    handleToastSuccess('Password updated successfully.');
                  } on FirebaseAuthException catch (e) {
                    firebaseAuthExceptionHandler(e);
                  }
                },
                title: 'Save password',
              ),
              const SizedBox(
                height: 36,
              ),
              Container(
                height: 1,
                width: double.infinity,
                color: primaryColor,
              ),
              const SizedBox(
                height: 18,
              ),
              const Text(
                'Change Key',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              TextFieldWidget(
                controller: keyController,
                label: 'Key',
              ),
              const SizedBox(
                height: 12,
              ),
              ButtonWidget(
                onPressed: () async {
                  String key = keyController.text.trim();
                  if (key.isEmpty) {
                    handleToastError('Key is required');
                    return;
                  }
                  await context.read<UserController>().saveData(key);
                  handleToastSuccess('Save successfully.');
                  setState(() {});
                },
                title: 'Save',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
