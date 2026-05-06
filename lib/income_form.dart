// lib/income_form.dart (নতুন ফাইল)
import 'package:flutter/material.dart';

class IncomeForm extends StatefulWidget {
  final Function(Map<String, String>) onSubmit;

  const IncomeForm({required this.onSubmit});

  @override
  _IncomeFormState createState() => _IncomeFormState();
}

class _IncomeFormState extends State<IncomeForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'বেতন';

  // ইনকাম ক্যাটাগরি
  final List<String> _categories = [
    'বেতন',
    'ফ্রিল্যান্সিং',
    'ব্যবসা',
    'উপহার',
    'ইনভেস্টমেন্ট',
    'অন্যান্য',
  ];

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      Map<String, String> newData = {
        'title': _titleController.text,
        'note': _noteController.text,
        'amount': _amountController.text,
        'date': _selectedDate.toString(),
        'category': _selectedCategory,
        'type': 'income',
      };
      widget.onSubmit(newData);
      Navigator.pop(context);
      
      // সাকসেস মেসেজ দেখান
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ ইনকাম এন্ট্রি সফল হয়েছে!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: Locale('bn', 'BD'), // বাংলা লোকেল
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('আয়ের এন্ট্রি', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // ইনকাম আইকন
                Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.attach_money, size: 50, color: Colors.green.shade700),
                  ),
                ),
                SizedBox(height: 30),
                
                // টাইটেল ফিল্ড
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'আয়ের বিবরণ *',
                    hintText: 'যেমন: মাসিক বেতন, ফ্রিল্যান্সিং',
                    prefixIcon: Icon(Icons.title, color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'আয়ের বিবরণ দিন';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                
                // ক্যাটাগরি সিলেক্ট
                DropdownButtonFormField(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'ক্যাটাগরি',
                    prefixIcon: Icon(Icons.category, color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                SizedBox(height: 20),
                
                // টাকার পরিমাণ
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'পরিমাণ (টাকায়) *',
                    prefixIcon: Icon(Icons.attach_money, color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'টাকার পরিমাণ দিন';
                    }
                    if (double.tryParse(value) == null) {
                      return 'সঠিক সংখ্যা দিন';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                
                // তারিখ সিলেক্ট
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.green),
                        SizedBox(width: 12),
                        Text(
                          'তারিখ: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_drop_down, color: Colors.green),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                
                // নোট (অপশনাল)
                TextFormField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    labelText: 'নোট (ঐচ্ছিক)',
                    hintText: 'অতিরিক্ত কিছু তথ্য',
                    prefixIcon: Icon(Icons.note, color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 30),
                
                // সেভ বাটন
                ElevatedButton(
                  onPressed: _saveForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    minimumSize: Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'ইনকাম সেভ করুন',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}