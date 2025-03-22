import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityScreen extends StatefulWidget {
  final List<Map<String, dynamic>> activities;

  const ActivityScreen({super.key, required this.activities});

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String searchQuery = "";
  DateTime? selectedMonth;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredActivities =
        widget.activities.where((activity) {
          bool matchesSearch = activity['groupName'].toLowerCase().contains(
            searchQuery.toLowerCase(),
          );
          bool matchesMonth =
              selectedMonth == null ||
              (DateFormat("dd/MM/yyyy").parse(activity['date']).month ==
                      selectedMonth!.month &&
                  DateFormat("dd/MM/yyyy").parse(activity['date']).year ==
                      selectedMonth!.year);
          return matchesSearch && matchesMonth;
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hoạt động chi tiêu",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ActivitySearchDelegate(widget.activities, (query) {
                  setState(() {
                    searchQuery = query;
                  });
                }),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child:
                filteredActivities.isEmpty
                    ? Center(child: Text("Không có hoạt động nào phù hợp"))
                    : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: filteredActivities.length,
                      itemBuilder: (context, index) {
                        return ActivityCard(
                          activity: filteredActivities[index],
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.blueAccent.shade100,
      child: DropdownButtonFormField<DateTime>(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        hint: Text("Chọn tháng"),
        value: selectedMonth,
        onChanged: (newMonth) {
          setState(() {
            selectedMonth = newMonth;
          });
        },
        items: List.generate(12, (index) {
          DateTime month = DateTime(DateTime.now().year, index + 1, 1);
          return DropdownMenuItem(
            value: month,
            child: Text("Tháng ${month.month}/${month.year}"),
          );
        }),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final Map<String, dynamic> activity;

  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    DateTime date = dateFormat.parse(activity['date']);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activity['groupName'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 6),
            Text(
              activity['description'],
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Số tiền: ${activity['amount']} đ",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Text(
                  "Ngày: ${DateFormat('dd/MM/yyyy').format(date)}",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ActivitySearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> activities;
  final Function(String) onSearch;

  ActivitySearchDelegate(this.activities, this.onSearch);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    close(context, query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Map<String, dynamic>> searchResults =
        activities
            .where(
              (activity) => activity['groupName'].toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(searchResults[index]['groupName']),
          onTap: () {
            query = searchResults[index]['groupName'];
            showResults(context);
          },
        );
      },
    );
  }
}
