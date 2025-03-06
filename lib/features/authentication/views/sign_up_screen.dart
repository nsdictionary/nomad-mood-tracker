import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mood_tracker/features/authentication/views/widgets/form_button.dart';

import '../../../constants/gaps.dart';
import '../../../constants/sizes.dart';
import '../view_models/signup_view_model.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  static String routeURL = "/signup";
  static String routeName = "signup";
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void _onSubmitTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save(); // onSaved 콜백 실행

        ref.read(signUpForm.notifier).state = {
          "email": _formData["email"],
          "password": _formData["password"],
        };
        ref.read(signUpProvider.notifier).signUp(context);
      }
    }
  }

  void _onTapLogin() {
    Navigator.pop(context);
  }

  String? _isEmailValid(String? email) {
    if (email != null && email.isEmpty) {
      return "Please write your email";
    }

    final regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (email != null && !regExp.hasMatch(email)) {
      return "Email not valid";
    }

    return null;
  }

  void _onClearTap() {
    _passwordController.clear();
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Gaps.v44,
              const Center(
                child: Text(
                  '🔥MOOD🔥',
                  style: TextStyle(
                    fontSize: Sizes.size24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Gaps.v96,
              const Text(
                'Join!',
                style: TextStyle(
                  fontSize: Sizes.size20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size36,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Gaps.v28,
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Sizes.size20,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Sizes.size20,
                            ),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Email',
                        ),
                        validator: _isEmailValid,
                        onSaved: (newValue) {
                          if (newValue != null) {
                            _formData['email'] = newValue;
                          }
                        },
                      ),
                      Gaps.v16,
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Sizes.size20,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Sizes.size20,
                            ),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Password',
                          suffix: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: _onClearTap,
                                child: FaIcon(
                                  FontAwesomeIcons.solidCircleXmark,
                                  color: Colors.grey.shade500,
                                  size: Sizes.size20,
                                ),
                              ),
                              Gaps.h16,
                              GestureDetector(
                                onTap: _toggleObscureText,
                                child: FaIcon(
                                  _obscureText
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  color: Colors.grey.shade500,
                                  size: Sizes.size20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return "Please write your password";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          if (newValue != null) {
                            _formData['password'] = newValue;
                          }
                        },
                      ),
                      Gaps.v28,
                      FormButton(
                        onTapFunc: (context) {
                          _onSubmitTap();
                        },
                        disabled: ref.watch(signUpProvider).isLoading,
                        text: 'Create Account',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size36,
            vertical: Sizes.size18,
          ),
          child: FormButton(
            onTapFunc: (context) => _onTapLogin(),
            disabled: false,
            text: 'Log in →',
          ),
        ),
      ),
    );
  }
}
