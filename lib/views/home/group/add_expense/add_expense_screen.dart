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
      double totalRatio = members.fold(0, (sum, member) {
        return sum +
            (double.tryParse(_splitControllers[member]?.text ?? '0') ?? 0);
      });
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
      appBar: AppBar(
        title: Text(
          'Thêm Chi Tiêu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                'Số tiền',
                _amountController,
                TextInputType.number,
              ),
              SizedBox(height: 10),
              _buildTextField(
                'Mô tả',
                _descriptionController,
                TextInputType.text,
              ),
              SizedBox(height: 10),
              _buildDropdown('Danh mục', categories, _selectedCategory, (
                value,
              ) {
                setState(() {
                  _selectedCategory = value.toString();
                });
              }),
              const SizedBox(height: 10),
              _buildDatePicker(),
              const SizedBox(height: 10),
              _buildImagePicker(),
              const SizedBox(height: 10),
              _buildDropdown('Người trả tiền', members, _payer, (value) {
                setState(() {
                  _payer = value.toString();
                });
              }),
              SizedBox(height: 10),
              SwitchListTile(
                title: const Text('Chia đều chi phí'),
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
                const SizedBox(height: 10),
                _buildSplitRatioFields(),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveExpense,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text('Lưu', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    TextInputType inputType,
  ) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String value,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items:
          items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDatePicker() {
    return ListTile(
      title: Text(
        'Ngày chi tiêu: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
      ),
      trailing: Icon(Icons.calendar_today, color: Colors.teal),
      onTap: () => _selectDate(context),
    );
  }

  Widget _buildImagePicker() {
    return _receiptImage != null
        ? Image.file(_receiptImage!, height: 100)
        : TextButton.icon(
          icon: Icon(Icons.attach_file, color: Colors.teal),
          label: const Text('Chọn ảnh'),
          onPressed: _pickImage,
        );
  }

  Widget _buildSplitRatioFields() {
    return Column(
      children:
          members.map((member) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildTextField(
                '$member ()',
                _splitControllers[member]!,
                TextInputType.number,
              ),
            );
          }).toList(),
    );
  }
}
