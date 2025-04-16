import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'group_model.dart';
import 'group_setting_creen.dart';
import 'add_expense/add_expense_screen.dart';
import 'package:intl/intl.dart';
class GroupDetailScreen extends StatefulWidget {
  final GroupModel group;

  const GroupDetailScreen({super.key, required this.group});

  @override
  _GroupDetailScreenState createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  List<Map<String, dynamic>> expenses = [];
  String? filterPayer;
  DateTime selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  void _addExpense(Map<String, dynamic> expense) {
    setState(() {
      expenses.add(expense);
    });
  }

  List<Map<String, dynamic>> getFilteredExpenses() {
  if (expenses.isEmpty) return [];

  DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  return expenses.where((expense) {
    try {
      DateTime expenseDate = dateFormat.parse(expense['date']);
      return expenseDate.month == selectedMonth.month &&
             expenseDate.year == selectedMonth.year;
    } catch (e) {
      return false;
    }
  }).toList();
}


  Map<String, double> getTotalAmountPerPerson() {
    Map<String, double> totals = {};
    for (var expense in getFilteredExpenses()) {
      (expense['split'] as Map<String, dynamic>).forEach((person, amount) {
        totals[person] = (totals[person] ?? 0) + (amount as num).toDouble();
      });
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.group.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            SettingScreen(groupName: widget.group.name),
                  ),
                );
              },
            ),
          ],
          bottom: TabBar(tabs: [Tab(text: "Chi tiêu"), Tab(text: "Thống kê")]),
        ),
        body: TabBarView(children: [buildExpenseList(), buildStatisticsTab()]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => AddExpenseScreen(onExpenseAdded: _addExpense),
              ),
            );
          },
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget buildExpenseList() {
    final filteredExpenses = getFilteredExpenses();
    if (filteredExpenses.isEmpty) {
      return Center(child: Text("Chưa có khoản chi tiêu nào"));
    }
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredExpenses.length,
      itemBuilder: (context, index) {
        final expense = filteredExpenses[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mô tả: ${expense['description']}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Số tiền: ${expense['amount']} đ",
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  "Người trả: ${expense['payer']}",
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 10),
                Text("Chia cho:"),
                Column(
                  children:
                      (expense['split'] as Map<String, dynamic>).entries
                          .map(
                            (entry) => Text("${entry.key}: ${entry.value} đ"),
                          )
                          .toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildStatisticsTab() {
    Map<String, double> totals = getTotalAmountPerPerson();
    if (totals.isEmpty) {
      return Center(child: Text("Chưa có dữ liệu thống kê"));
    }
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          DropdownButton<DateTime>(
            value: selectedMonth,
            onChanged: (newMonth) {
              if (newMonth != null) {
                setState(() {
                  selectedMonth = DateTime(newMonth.year, newMonth.month, 1);
                });
              }
            },
            items:
                List.generate(12, (index) {
                  DateTime month = DateTime(DateTime.now().year, index + 1, 1);
                  return DropdownMenuItem(
                    value: month,
                    child: Text("Tháng ${month.month}/${month.year}"),
                  );
                }).toList(),
          ),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barGroups:
                    totals.entries.map((entry) {
                      return BarChartGroupData(
                        x: entry.key.hashCode,
                        barRods: [
                          BarChartRodData(toY: entry.value, color: Colors.blue),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
