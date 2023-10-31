import 'package:flutter/material.dart';
import 'package:webvuln/models/history.dart'; // chứa model History
import 'package:webvuln/service/api.dart'; // API lấy dữ liệu
import 'draftt/resultScreen.dart'; // màn hình chi tiết kết quả
import 'draftt/drawer.dart'; // Drawer điều hướng  

class historyScreen extends StatefulWidget {

  @override
  _historyScreenState createState() => _historyScreenState();
}

class _historyScreenState extends State<historyScreen> {

  List<History> histories = [];
  
  @override
  void initState() {
    super.initState();
    getHistories(); 
  }

  getHistories() async {
    histories = await Api.getHistories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: AppDrawer(), 
      body: histories.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: histories.length,
            itemBuilder: (context, index) {
              return HistoryCard(history: histories[index]);
            },
          ),
    );

  }

}

class HistoryCard extends StatelessWidget {

  final History history;

  HistoryCard({required this.history});

  @override
  Widget build(BuildContext context) {
    
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => resultScreen(historyId: history.id),  
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(history.url), 
              SizedBox(height: 8),
              Text('Scanned at: ${history.dateTime}'),
            ],
          ), 
        ),
      ),
    );

  }

}