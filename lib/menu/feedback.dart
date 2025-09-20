import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  bool isLoading = false;

  Future<void> submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final url = Uri.parse(
        "http://api.aswdc.in/Api/MST_AppVersions/GetAppDetailByAppNameSystem/Ecodomia0");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "API_KEY": "1234",
      },
      body: {
        "AppName": "PlayFul Pal",
        "VersionNo": "1.0.0",
        "Platform": "Android",
        "PersonName": nameController.text,
        "Mobile": mobileController.text,
        "Email": emailController.text,
        "Message": messageController.text,
        "Remarks": "Submitted from Flutter App",
      },
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["IsResult"] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Feedback submitted successfully!",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.green.withOpacity(0.8), // Transparent green
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${data["Message"] ?? "Submission failed"}",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.red.withOpacity(0.8), // Transparent red
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Error submitting feedback",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red.withOpacity(0.8), // Transparent red
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.lightGreen.shade50,
      labelStyle: TextStyle(color: Colors.lightGreen.shade400),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.lightGreen.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.lightGreen.shade400, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen.shade50,
      appBar: AppBar(
        title: const Text("Feedback"),
        centerTitle: true,
        backgroundColor: Colors.lightGreen.shade600,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Share Your Experience",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreen.shade400,
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: nameController,
                decoration: _inputDecoration("Your Name"),
                validator: (val) =>
                val!.isEmpty ? "Please enter your name" : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: mobileController,
                decoration: _inputDecoration("Mobile Number"),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: emailController,
                decoration: _inputDecoration("Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: messageController,
                decoration: _inputDecoration("Message"),
                maxLines: 4,
                validator: (val) =>
                val!.isEmpty ? "Please enter your feedback" : null,
              ),
              const SizedBox(height: 25),

              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.lightGreen.shade100,
                        foregroundColor: Colors.lightGreen.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 3,
                      ),
                      onPressed: submitFeedback,
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 3,
                      ),
                      onPressed: () {
                        nameController.clear();
                        mobileController.clear();
                        emailController.clear();
                        messageController.clear();
                      },
                      child: const Text(
                        "Clear",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}