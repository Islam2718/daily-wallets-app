// lib/login_screen.dart
import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ফোন ও পাসওয়ার্ডের জন্য কন্ট্রোলার
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // লোডিং ইন্ডিকেটরের জন্য ভেরিয়েবল
  bool _isLoading = false;

  // লগইন ভ্যালিডেশন ফাংশন
  void _login() {
    // ফোন নম্বর ভ্যালিডেশন (নূন্যতম 11 ডিজিট, বাংলাদেশি নম্বরের জন্য)
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    
    if (phone.isEmpty) {
      _showError('দয়া করে ফোন নম্বর দিন');
      return;
    }
    
    if (phone.length < 11) {
      _showError('সঠিক ফোন নম্বর দিন (১১ ডিজিট)');
      return;
    }
    
    if (password.isEmpty) {
      _showError('দয়া করে পাসওয়ার্ড দিন');
      return;
    }
    
    if (password.length < 4) {
      _showError('পাসওয়ার্ড কমপক্ষে ৪ ডিজিট হতে হবে');
      return;
    }
    
    // লোডিং স্টার্ট
    setState(() {
      _isLoading = true;
    });
    
    // সিমুলেটেড লগইন প্রসেস (১ সেকেন্ড দেরি করে দেখানোর জন্য)
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
      
      // চেক করুন - এখানে আপনি আপনার প্রিফার্ড ক্রেডেনশিয়াল সেট করতে পারেন
      // উদাহরণ: phone = "01710001337" এবং password = "123456"
      if (phone == "01710001337" && password == "123456") {
        // লগইন সফল - হোম স্ক্রিনে যান
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // লগইন ব্যর্থ
        _showError('ভুল ফোন নম্বর বা পাসওয়ার্ড');
      }
    });
  }
  
  // এরর মেসেজ দেখানোর ফাংশন
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade700, Colors.teal.shade100],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // লোগো বা আইকন
                    Icon(
                      Icons.account_circle,
                      size: 100,
                      color: Colors.teal,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'আমার পকেট',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 30),
                    
                    // ফোন নম্বর ফিল্ড
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'ফোন নম্বর',
                        hintText: '01XXXXXXXXX',
                        prefixIcon: Icon(Icons.phone_android),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    
                    // পাসওয়ার্ড ফিল্ড
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'পাসওয়ার্ড',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    
                    // লগইন বাটন
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'লগইন করুন',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                    
                    SizedBox(height: 20),
                    
                    // ডেমো ক্রেডেনশিয়াল দেখানোর জন্য টেক্সট
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'ডেমো অ্যাকাউন্ট:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'ফোন: 01710001337',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            'পাসওয়ার্ড: 123456',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}