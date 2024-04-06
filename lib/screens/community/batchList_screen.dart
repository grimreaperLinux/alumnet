import 'package:alumnet/screens/community/batchDetails_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BatchList extends StatefulWidget {
  final String branch;

  BatchList({required this.branch});

  @override
  _BatchListState createState() => _BatchListState();
}

class _BatchListState extends State<BatchList> {
  List<String> data = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('users')
        .doc(widget.branch)
        .collection('batches')
        .get();

    setState(() {
      data = querySnapshot.docs.map((doc) => doc.id).toList();
      print(data);
      print(widget.branch);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.branch),
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
                  builder: (context) => BatchDetails(
                    branch: widget.branch,
                    batch: data[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
