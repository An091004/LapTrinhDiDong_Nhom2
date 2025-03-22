import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  DateTime selectedMonth = DateTime(2025, 2, 1);
  double monthlyIncome = 0.0;
  double monthlyExpense = 0.0;

  Map<DateTime, List<Map<String, dynamic>>> transactionsByDate = {
    DateTime(2025, 2, 6): [
      {"amount": -337000, "note": "Mua sắm"},
    ],
    DateTime(2025, 2, 9): [
      {"amount": -20000, "note": "Ăn uống"},
    ],
    DateTime(2025, 2, 15): [
      {"amount": 5000, "note": "Tiền lãi"},
      {"amount": -15000, "note": "Di chuyển"},
    ],
    DateTime(2025, 2, 25): [
      {"amount": 103000, "note": "Tiền thưởng"},
      {"amount": -65000, "note": "Mua quà"},
    ],
    DateTime(2025, 3, 5): [
      {"amount": -50000, "note": "Hóa đơn điện nước"},
    ],
  };

  @override
  void initState() {
    super.initState();
    _calculateMonthlySummary();
  }

  void _calculateMonthlySummary() {
    double income = 0.0;
    double expense = 0.0;

    transactionsByDate.forEach((date, transactions) {
      if (date.year == selectedMonth.year &&
          date.month == selectedMonth.month) {
        for (var transaction in transactions) {
          if (transaction['amount'] > 0) {
            income += transaction['amount'];
          } else {
            expense += transaction['amount'].abs();
          }
        }
      }
    });

    setState(() {
      monthlyIncome = income;
      monthlyExpense = expense;
    });
  }

  void _changeMonth(int increment) {
    setState(() {
      selectedMonth = DateTime(
        selectedMonth.year,
        selectedMonth.month + increment,
        1,
      );
    });
    _calculateMonthlySummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tổng quan chi tiêu"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMonthSelector(),
              _buildSummary(),
              const SizedBox(height: 10),
              _buildCalendar(),
              const SizedBox(height: 10),
              _buildTransactionHistory(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _changeMonth(-1),
        ),
        Flexible(
          child: Text(
            "Tháng ${selectedMonth.month}/${selectedMonth.year}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => _changeMonth(1),
        ),
      ],
    );
  }

  Widget _buildSummary() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSummaryItem("Tổng thu", monthlyIncome, Colors.blue),
            _buildSummaryItem("Tổng chi", monthlyExpense, Colors.black),
            _buildSummaryItem(
              "Chênh lệch",
              monthlyIncome - monthlyExpense,
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, double amount, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        Text(
          "${amount.toInt()}đ",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    int daysInMonth =
        DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
    int firstWeekday =
        DateTime(selectedMonth.year, selectedMonth.month, 1).weekday;

    List<Widget> dayWidgets = [];

    for (int i = 1; i < firstWeekday; i++) {
      dayWidgets.add(
        const SizedBox(width: 45, height: 65),
      ); // Khoảng trống đầu tháng
    }

    for (int day = 1; day <= daysInMonth; day++) {
      DateTime currentDate = DateTime(
        selectedMonth.year,
        selectedMonth.month,
        day,
      );
      List<Map<String, dynamic>> transactions =
          transactionsByDate[currentDate] ?? [];
      double totalAmount = transactions.fold(
        0.0,
        (sum, t) => sum + t['amount'],
      );

      dayWidgets.add(
        Container(
          width: 45,
          height: 65,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$day",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (transactions.isNotEmpty)
                Text(
                  "${totalAmount > 0 ? "+" : ""}${(totalAmount / 1000).toStringAsFixed(0)}K",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: totalAmount > 0 ? Colors.blue : Colors.red,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
              ["T2", "T3", "T4", "T5", "T6", "T7", "CN"]
                  .map(
                    (day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 5),

        LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = constraints.maxWidth;
            int daysInRow = 7;
            double dayWidth =
                (maxWidth - 5 * (daysInRow - 1)) /
                daysInRow; // Tính toán kích thước động

            return Wrap(
              spacing: 5,
              runSpacing: 5,
              children:
                  dayWidgets.map((dayWidget) {
                    return SizedBox(width: dayWidth, child: dayWidget);
                  }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTransactionHistory() {
    List<DateTime> transactionDates =
        transactionsByDate.keys
            .where(
              (date) =>
                  date.year == selectedMonth.year &&
                  date.month == selectedMonth.month,
            )
            .toList()
          ..sort();

    return transactionDates.isEmpty
        ? const Center(child: Text("Không có giao dịch nào trong tháng này."))
        : Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 250,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: transactionDates.length,
                itemBuilder: (context, index) {
                  DateTime date = transactionDates[index];
                  String formattedDate = DateFormat("dd/MM/yyyy").format(date);
                  List<Map<String, dynamic>> transactions =
                      transactionsByDate[date] ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ...transactions.map(
                        (transaction) => ListTile(
                          title: Text(transaction['note']),
                          trailing: Text(
                            "${transaction['amount'] > 0 ? "+" : ""}${transaction['amount']}đ",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                                  transaction['amount'] > 0
                                      ? Colors.blue
                                      : Colors.red,
                            ),
                          ),
                        ),
                      ),
                      if (index < transactionDates.length - 1) const Divider(),
                    ],
                  );
                },
              ),
            ),
          ),
        );
  }
}
