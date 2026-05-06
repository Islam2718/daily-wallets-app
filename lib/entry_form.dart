// lib/entry_form.dart
import 'package:flutter/material.dart';

// onSubmit নামে একটি Function টাইপের ভেরিয়েবল নেওয়া হয়েছে,
// যাতে করে ফর্ম ডাটা Home Screen-এ পাঠানো যায়।
class EntryForm extends StatefulWidget {
  final Function(Map<String, String>) onSubmit;

  const EntryForm({required this.onSubmit});

  @override
  _EntryFormState createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  void _saveForm() {
    if (_formKey.currentState!.validate()) {      
      Map<String, String> newData = {
        'title': _titleController.text,
        'note': _noteController.text,
        'amount': _amountController.text,
      };
      
      widget.onSubmit(newData);      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('খরচ এন্ট্রি'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'খরচের নাম'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'এন্ট্রি দিতে হবে';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(labelText: 'নোট (ঐচ্ছিক)'),
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'পরিমাণ (টাকায়)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'টাকার পরিমাণ দিতে হবে';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                child: Text('সেভ করুন'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}