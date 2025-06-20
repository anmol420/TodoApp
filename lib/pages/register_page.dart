import 'package:todoapp/components/my_button.dart';
import 'package:todoapp/components/my_textfield.dart';
import 'package:todoapp/components/square_tile.dart';
import 'package:todoapp/pages/home_page.dart';
import 'package:todoapp/pages/login_page.dart';
import 'package:todoapp/services/api_services.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernamecontroller = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  

  // Register user  method
  void register(BuildContext context) async {
    String? error = await ApiService.register(usernamecontroller.text,emailController.text, passwordController.text);

    if(!context.mounted) return;
    if (error == null) {
      Navigator.pushReplacement(
        context,
         MaterialPageRoute(builder: (context) => HomePage()),
         );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
        );
    }
  } 
  

  bool showOtp = false; // 🔁 to toggle OTP section

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                // Logo
                Image.asset(
                  'lib/images/Todologo.png',
                  height: 200,
                ),
                

                // Title
                Text(
                  'Register with ToDo <3',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextfield(controller: usernamecontroller, hinText: 'Username', obsecureText: false),
                const SizedBox(height: 25),

                // Email Field
                MyTextfield(
                    controller: emailController,
                    hinText: 'Email',
                    obsecureText: false),

                const SizedBox(height: 25),

                // Password Field
                MyTextfield(
                    controller: passwordController,
                    hinText: 'Password',
                    obsecureText: true),

                const SizedBox(height: 25),

                
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showOtp = true; //  show OTP UI on click
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Verify Email',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),

                const SizedBox(height: 30),

                 
                if (showOtp) ...[
                  Text(
                    'Enter 4-digit OTP',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        width: 50,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: Colors.grey[900],
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
                  const SizedBox(height: 25),
                   
          
                // register button 
                MyButton(
                    onTap:() {
                         register(context);     
                    },
                    text: 'Register',
                  ),
                

                const SizedBox(height: 50),
          
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                          ),
                      ),
                       Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
          
                    ],
                  ),
                ),

                      const SizedBox(height:50),
                // google/apple sign in
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(imagePath: 'lib/images/google.png' ),
          
                    
          
                ],
                ),
                const SizedBox(height:50),
                // register now 
          
                Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                           MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
          
                  ],)
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
