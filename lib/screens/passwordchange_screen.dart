import 'dart:convert';

import 'package:bca_project/screens/home_screen.dart';
import 'package:bca_project/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordchangeScreen extends StatefulWidget {
  const PasswordchangeScreen({super.key});

  @override
  State<PasswordchangeScreen> createState() => _PasswordchangeScreenState();
}

class _PasswordchangeScreenState extends State<PasswordchangeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _conformPasswordController =
      TextEditingController();

  bool isObsecured = true;
  bool isObsecured2 = true;
  bool isObsecured3 = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _oldPasswordController.dispose();
    _conformPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(AppLocalizations.of(context)!.changePassword),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.changePassword,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  SizedBox(height: 30),

                  TextFormField(
                    controller: _oldPasswordController,
                    obscureText: isObsecured,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.oldPassword,
                      border: OutlineInputBorder(),
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            isObsecured = !isObsecured;
                          });
                        },
                        icon: Icon(
                          isObsecured
                              ? Icons.remove_red_eye
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: isObsecured2,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.newPassword,
                      border: OutlineInputBorder(),
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            isObsecured2 = !isObsecured2;
                          });
                        },
                        icon: Icon(
                          isObsecured2
                              ? Icons.remove_red_eye
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is Required";
                      }
                      if (value.length < 8) {
                        return "Password must be 8 character";
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _conformPasswordController,
                    obscureText: isObsecured3,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.conformPassword,
                      border: OutlineInputBorder(),
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            isObsecured3 = !isObsecured3;
                          });
                        },
                        icon: Icon(
                          isObsecured3
                              ? Icons.remove_red_eye
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value?.trim() !=
                          _newPasswordController.text?.trim()) {//using trim() to compare two passwords from users.
                        return "New Password is Not Match";
                      }
                    },
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        bool isValid = _formKey.currentState!.validate();
                        // debugPrint("Is Value $isValid");
                        if (isValid) {
                          SharedPreferences ins =
                              await SharedPreferences.getInstance();
                          final String? token = ins.getString("token");

                          if (token == null) return;

                          final changeurl = Uri.parse(
                            "http://10.0.2.2:1337/api/auth/change-password",
                          );
                          try {
                            http.Response response = await http.post(
                              changeurl,
                              body: {
                                "currentPassword": _oldPasswordController.text,
                                "password": _newPasswordController.text,
                                "passwordConfirmation":
                                    _conformPasswordController.text,
                              },
                              headers: {"Authorization": "Bearer $token"},
                            );
                            // debugPrint("data is $response");
                            if (response.statusCode == 200) {
                              await ins.clear();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LoginScreen();
                                  },
                                ),
                                (value) {
                                  return false;
                                },
                              );
                              showTopSnackBar(
                                Overlay.of(context),
                                CustomSnackBar.success(
                                  message: "Change Password Successfully",
                                ),
                              );
                            }
                            if (response.statusCode == 400 ||
                                response.statusCode == 403) {
                              final decodedResult = jsonDecode(response.body);
                              final message = decodedResult['error']['message'];
                              showTopSnackBar(
                                Overlay.of(context),
                                CustomSnackBar.error(message: message),
                              );
                            }
                          } catch (e) {
                            showTopSnackBar(
                              Overlay.of(context),
                              CustomSnackBar.error(message: e.toString()),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.changePassword,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
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
