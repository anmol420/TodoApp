import 'package:todoapp/components/my_button.dart';
import 'package:todoapp/components/my_textfield.dart';
import 'package:todoapp/components/square_tile.dart';
import 'package:todoapp/pages/blacktodo.dart';
import 'package:todoapp/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/pages/register_page.dart';

class LoginPage extends StatelessWidget {
   LoginPage({super.key});

  // text editing controllers 
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void login(BuildContext context) async {
    String? error = await ApiService.login(emailController.text, passwordController.text);

    if(!context.mounted) return;
    if (error == null) {
      Navigator.pushReplacement(
        context,
         MaterialPageRoute(builder: (context) => Blacktodo()),
         );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
        );
    }
  } 
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Image.asset(
                'lib/images/Todologo.png',
                height: 210,
               ),
          
                const SizedBox(height: 10,),
          
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
          
                const SizedBox(height: 25),
          
                // username textfield 
                MyTextfield(controller: emailController, hinText: 'Email', obsecureText: false),
          
                const SizedBox(height: 25),
          
                // password textfield 
                MyTextfield(controller: passwordController, hinText: 'Password', obsecureText: true),
          
                const SizedBox(height: 10),
          
                // forgot password 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height:25),
          
                // sign in button 
                 MyButton(
                    
                    text: 'Sign In',
                    onTap: () {
                    login(context);
                  },
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
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                           MaterialPageRoute(builder: (context) => RegisterPage()),
                        );
                      },
                      child: const Text(
                        'Register now',
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