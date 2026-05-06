// lib/home_screen.dart (সুন্দর ডিজাইন সহ)
import 'package:flutter/material.dart';
import 'entry_form.dart';
import 'income_form.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // 0 = খরচ, 1 = আয়
  
  List<Map<String, String>> _expenses = [];
  List<Map<String, String>> _incomes = [];

  void _addIncome(Map<String, String> newIncome) {
    setState(() {
      _incomes.add(newIncome);
    });
  }

  void _addExpense(Map<String, String> newExpense) {
    setState(() {
      _expenses.add(newExpense);
    });
  }

  double get _totalIncome {
    double total = 0;
    for (var item in _incomes) {
      total += double.tryParse(item['amount'] ?? '0') ?? 0;
    }
    return total;
  }

  double get _totalExpense {
    double total = 0;
    for (var item in _expenses) {
      total += double.tryParse(item['amount'] ?? '0') ?? 0;
    }
    return total;
  }

  double get _balance {
    return _totalIncome - _totalExpense;
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('লগআউট', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('আপনি কি নিশ্চিত যে লগআউট করতে চান?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('না', style: TextStyle(color: Colors.grey, fontSize: 16)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('হ্যাঁ', style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'আমার পকেট',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
        actions: [
          // ব্যালেন্স দেখানোর জন্য চিপ
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  size: 18,
                  color: _balance >= 0 ? Colors.green : Colors.red,
                ),
                SizedBox(width: 4),
                Text(
                  '৳${_balance.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _balance >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _selectedIndex == 0 ? _buildExpenseTab() : _buildIncomeTab(),
      
      // সুন্দর বটম নেভিগেশন বার
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.teal,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // খরচ বাটন
                _buildNavItem(
                  icon: Icons.shopping_cart,
                  label: 'খরচ',
                  index: 0,
                ),
                
                // মাঝখানে ফাঁকা জায়গা FAB এর জন্য
                SizedBox(width: 40),
                
                // জমা বাটন
                _buildNavItem(
                  icon: Icons.account_balance_wallet,
                  label: 'জমা',
                  index: 1,
                ),
                
                // লগআউট বাটন
                _buildNavItem(
                  icon: Icons.logout,
                  label: 'লগআউট',
                  index: 2,
                  isLogout: true,
                ),
              ],
            ),
          ),
        ),
      ),
      
      // ফ্লোটিং অ্যাকশন বাটন
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.4),
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            if (_selectedIndex == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EntryForm(onSubmit: _addExpense),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IncomeForm(onSubmit: _addIncome),
                ),
              );
            }
          },
          child: Icon(Icons.add, size: 25),
          backgroundColor: Colors.white,
          foregroundColor: Colors.teal,
          elevation: 8,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // নেভিগেশন আইটেম বিল্ডার
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    bool isLogout = false,
  }) {
    final isSelected = _selectedIndex == index;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          if (isLogout) {
            _logout();
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: isSelected && !isLogout 
                ? Colors.white.withOpacity(0.2) 
                : Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: isSelected && !isLogout ? 26 : 24,
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSelected && !isLogout ? 13 : 12,
                  fontWeight: isSelected && !isLogout ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // খরচের ট্যাব
  Widget _buildExpenseTab() {
    return _expenses.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.shopping_cart, size: 60, color: Colors.teal.shade300),
                ),
                SizedBox(height: 20),
                Text(
                  'কোনো খরচের এন্ট্রি নেই',
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                ),
                SizedBox(height: 10),
                Text(
                  'মাঝের + বাটনে ক্লিক করে খরচ যোগ করুন',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: _expenses.length,
            itemBuilder: (ctx, index) {
              final item = _expenses[index];
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.shade100,
                    radius: 25,
                    child: Icon(Icons.shopping_cart, color: Colors.teal, size: 24),
                  ),
                  title: Text(
                    item['title']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: item['note'] != null && item['note']!.isNotEmpty
                      ? Text(
                          item['note']!,
                          style: TextStyle(fontSize: 13),
                        )
                      : null,
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '৳${item['amount']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.red.shade700,
                        ),
                      ),
                      Text(
                        'খরচ',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('ডিলিট করুন'),
                        content: Text('"${item['title']}" খরচটি ডিলিট করতে চান?'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: Text('না'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _expenses.removeAt(index);
                              });
                              Navigator.of(ctx).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('খরচ ডিলিট হয়েছে'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Text('হ্যাঁ', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
  }

  // আয়ের ট্যাব
  Widget _buildIncomeTab() {
    return _incomes.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.account_balance_wallet, size: 60, color: Colors.green.shade300),
                ),
                SizedBox(height: 20),
                Text(
                  'কোনো আয়ের এন্ট্রি নেই',
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                ),
                SizedBox(height: 10),
                Text(
                  'মাঝের + বাটনে ক্লিক করে আয় যোগ করুন',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: _incomes.length,
            itemBuilder: (ctx, index) {
              final item = _incomes[index];
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade100,
                    radius: 25,
                    child: Icon(Icons.attach_money, color: Colors.green, size: 24),
                  ),
                  title: Text(
                    item['title']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item['note'] != null && item['note']!.isNotEmpty)
                        Text(item['note']!, style: TextStyle(fontSize: 13)),
                      if (item['category'] != null)
                        Container(
                          margin: EdgeInsets.only(top: 4),
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item['category']!,
                            style: TextStyle(fontSize: 11, color: Colors.green.shade800),
                          ),
                        ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '৳${item['amount']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.green.shade700,
                        ),
                      ),
                      if (item['date'] != null)
                        Text(
                          '${DateTime.parse(item['date']!).day}/${DateTime.parse(item['date']!).month}',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                    ],
                  ),
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('ডিলিট করুন'),
                        content: Text('"${item['title']}" আয়টি ডিলিট করতে চান?'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: Text('না'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _incomes.removeAt(index);
                              });
                              Navigator.of(ctx).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('আয় ডিলিট হয়েছে'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Text('হ্যাঁ', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
  }
}