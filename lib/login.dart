import "dart:async";

import "package:berita_app/sign_up.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";

import "auth.dart";
import "news_page.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Form Key untuk Validasi Form Input
  final formkey = GlobalKey<FormState>();

  // invisible agar icon mata pada password dapat di gunakan semestinya
  bool invisible = true;

  // ignorePointer agar tidak spam click
  bool ignorePointer = false;
  Timer? ignorePointerTimer;

  // Variable Text Editor Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Logic form input Login
  void login(BuildContext context) {
    // Mengubah Controller menjadi String/huruf
    var email = emailController.text;
    var password = passwordController.text;

    // Menjadikan Map agar mudah di pindah ke function lain
    var data = {
      "email": email,
      "password": password,
    };
    // Menjalankan Logic Class Function Auth Login
    Auth.login(data, context);
  }

  void cekUser() {
    // Logic cek Data User apakah sudah pernah login
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.currentUser;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const NewsPage()));
      });
    }
  }

  // Code yang bakal di jalankan pertama kali halaman ini dibuka
  @override
  void initState() {
    // Cek User apakah user sudah pernah login sebelumnya
    cekUser();
    super.initState();
  }

  @override
  void dispose() {
    // Timer pada ignore pointer akan di hapus jika pindah page
    // agar tidak memakan banyak resource device dan tidak error
    if (ignorePointerTimer != null) {
      ignorePointerTimer!.cancel();
    }
    EasyLoading.dismiss();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Form Section Login
                const Text(
                  "Login",
                  textAlign: TextAlign.left,
                  style:  TextStyle(
                    color: Color(0xFF36454F),
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Selamat Datang ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xFF696F79),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: formkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Email",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color(0xFF696F79),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty || value == "") {
                            return "Email harus di isi!";
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Mohon masukkan email yang valid!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFFCFDFE),
                          hintText: "Masukan Email Anda",
                          hintStyle: const TextStyle(
                            color: Color(0xFF696F79),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: const Icon(Icons.email_outlined),
                          isDense: true,
                          contentPadding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: const BorderSide(width: 1, color: Color(0xFFDEDEDE)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1, color: Colors.redAccent),
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Password",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color(0xFF696F79),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: invisible,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty || value == "") {
                            return "Password harus di isi!";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFFCFDFE),
                          hintText: "Masukan Password Anda",
                          hintStyle: const TextStyle(
                            color: Color(0xFF696F79),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon((invisible == true) ? Icons.visibility_outlined : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                invisible = !invisible;
                              });
                            },
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: const BorderSide(width: 1, color: Color(0xFFDEDEDE)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1, color: Colors.redAccent),
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Validasi Form Input sebelum menjalankan logic Login
                      if (formkey.currentState!.validate()) {
                        setState(() {
                          ignorePointer = true;
                          ignorePointerTimer = Timer(const Duration(seconds: 2), () {
                            setState(() {
                              ignorePointer = false;
                            });
                          });
                        });
                        // Menjalanan kan logic Login
                        login(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2FA4D9),
                    ),
                    child: const Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFF6F7FB),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Belum punya akun? ",
                          style:  TextStyle(
                            color:  Color(0xFF374253),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: 'Daftar',
                          style: const TextStyle(
                            color:  Color(0xFF2FA4D9),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Move Page Ke SignUpPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
