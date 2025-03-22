import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class AddExpenseScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onExpenseAdded;
  final Map<String, dynamic>? initialExpense;

  const AddExpenseScreen({
    super.key,
    required this.onExpenseAdded,
    this.initialExpense,
  });

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'Ăn uống';
  File? _receiptImage;
  String _payer = 'Nguyễn Văn A';
  bool _splitEqually = true;
  final Map<String, TextEditingController> _splitControllers = {};
  DateTime _selectedDate = DateTime.now();

  final List<String> categories = ['Ăn uống', 'Mua sắm', 'Đi lại', 'Khác'];
  final List<String> members = ['Nguyễn Văn A', 'Trần Thị B'];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _receiptImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveExpense() {
    double amount = double.tryParse(_amountController.text) ?? 0;
    Map<String, double> splitAmounts = {};

    if (_splitEqually) {
      double splitAmount = amount / members.length;
      for (var member in members) {
        splitAmounts[member] = splitAmount;
      }
    } else {
      // Tính tổng tỷ lệ
      double totalRatio = members.fold(0, (sum, member) {
        return sum +
            (double.tryParse(_splitControllers[member]?.text ?? '0') ?? 0);
      });

      // Tính số tiền mỗi người phải trả
      for (var member in members) {
        double memberRatio =
            double.tryParse(_splitControllers[member]?.text ?? '0') ?? 0;
        splitAmounts[member] = (memberRatio / totalRatio) * amount;
      }
    }

    Map<String, dynamic> newExpense = {
      'amount': amount,
      'description': _descriptionController.text,
      'category': _selectedCategory,
      'payer': _payer,
      'split': splitAmounts,
      'date': DateFormat('dd/MM/yyyy').format(_selectedDate),
    };

    widget.onExpenseAdded(newExpense);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm Chi Tiêu')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Số tiền'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Mô tả'),
              ),
              DropdownButtonFormField(
                value: _selectedCategory,
                items:
                    categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value.toString();
                  });
                },
                decoration: InputDecoration(labelText: 'Danh mục'),
              ),
              SizedBox(height: 10),
              Text('Ngày chi tiêu:'),
              TextButton.icon(
                icon: Icon(Icons.calendar_today),
                label: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                onPressed: () => _selectDate(context),
              ),
              SizedBox(height: 10),
              Text('Đính kèm hóa đơn:'),
              _receiptImage != null
                  ? Image.file(_receiptImage!, height: 100)
                  : TextButton.icon(
                    icon: Icon(Icons.attach_file),
                    label: Text('Chọn ảnh'),
                    onPressed: _pickImage,
                  ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                value: _payer,
                items:
                    members.map((member) {
                      return DropdownMenuItem(
                        value: member,
                        child: Text(member),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _payer = value.toString();
                  });
                },
                decoration: InputDecoration(labelText: 'Người trả tiền'),
              ),
              SwitchListTile(
                title: Text('Chia đều chi phí'),
                value: _splitEqually,
                onChanged: (value) {
                  setState(() {
                    _splitEqually = value;
                    if (!value) {
                      for (var member in members) {
                        _splitControllers[member] = TextEditingController();
                      }
                    } else {
                      _splitControllers.clear();
                    }
                  });
                },
              ),
              if (!_splitEqually) ...[
                SizedBox(height: 10),
                Text('Nhập tỉ lệ chia:'),
                Column(
                  children:
                      members.map((member) {
                        return TextField(
                          controller: _splitControllers[member],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: '$member (%)'),
                        );
                      }).toList(),
                ),
              ],
              SizedBox(height: 20),
              ElevatedButton(onPressed: _saveExpense, child: Text('Lưu')),
            ],
          ),
        ),
      ),
    );
  }
}
