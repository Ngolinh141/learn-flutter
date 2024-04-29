import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../res/constant/app_assets.dart';
import '../utils/routes/routes.dart';
import 'widget/ui_text.dart';
import 'widget/ui_textinput.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.bgApp),
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),
                SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.asset(
                      AppAssets.imageApp,
                    )),
                const SizedBox(height: 50),
                const UIText(
                  'Tài khoản',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 5),
                UITextInput(
                  controller: emailController,
                  hint: 'example@gmail.com',
                ),
                const SizedBox(height: 20),
                const UIText(
                  'Mật khẩu',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 5),
                UITextInput(
                  controller: passwordController,
                  hint: 'example123@',
                  isObscure: isObscure,
                  keyboardType: TextInputType.visiblePassword,
                  onSuffixIconPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor:
                        Colors.blue, // Adjust the color to your liking
                  ),
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim());

                      if (!context.mounted) return;
                      Routes.goToMainScreen(context);
                    } catch (e) {
                      showDialog(
                          context: context,
                          builder: (_) => const AlertDialog(
                                title: UIText(
                                    textAlign: TextAlign.center,
                                    'Tài khoản hoặc mật khẩu không chính xác'),
                              ));
                    }
                  },
                  child: const UIText(
                    'Đăng nhập',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => Routes.goToSignUpScreen(context),
                  child: const UIText(
                    "Đăng ký tài khoản?",
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
