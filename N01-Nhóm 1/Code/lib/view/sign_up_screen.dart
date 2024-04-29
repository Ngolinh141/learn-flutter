import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../res/constant/app_assets.dart';
import '../utils/routes/routes.dart';
import 'widget/ui_text.dart';
import 'widget/ui_textinput.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.arrow_back_outlined),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                const UIText(
                  'Nhập lại mật khẩu',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 5),
                UITextInput(
                  controller: rePasswordController,
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
                    if (passwordController.text.trim() !=
                        rePasswordController.text.trim()) {
                      showDialog(
                          context: context,
                          builder: (_) => const AlertDialog(
                                title: UIText(
                                    textAlign: TextAlign.center,
                                    'Mật khẩu không trùng khớp '),
                              ));
                      return;
                    }
                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim());

                      if (!context.mounted) return;
                      Routes.goToSignInScreen(context);
                      showDialog(
                          context: context,
                          builder: (_) => const AlertDialog(
                                title: UIText(
                                    textAlign: TextAlign.center,
                                    'Đăng ký thành công'),
                              ));
                    } catch (e) {
                      showDialog(
                          context: context,
                          builder: (_) => const AlertDialog(
                                title: UIText(
                                    textAlign: TextAlign.center,
                                    'Đăng ký không thành công'),
                              ));
                    }
                  },
                  child: const UIText(
                    'Đăng Ký',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
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
