import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final String hinText;
  final bool obsecureText; 
  const MyTextfield({
    super.key,
    required this.controller,
    required this.hinText,
    required this.obsecureText,
    });

  @override
  Widget build(BuildContext context) {
    return   Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: controller,
                  obscureText: obsecureText,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    hintText: hinText,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    
                    
                    
                
                  ),
                  
                ),
              );
  }
}