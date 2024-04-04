import 'package:alumnet/screens/community/batchDetails_screen.dart';
import 'package:flutter/material.dart';

class BatchList extends StatelessWidget {
  final String branch;
  final List<String> data = [
    "Batch 2024",
    "Batch 2023",
    "Batch 2022",
    "Batch 2021",
    "Batch 2020",
    "Batch 2019"
  ];

  BatchList({required this.branch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(branch),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              data[index],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BatchDetails(branch: branch, batch: data[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
