import 'package:flutter/material.dart';

class ReorderableListViewPage extends StatefulWidget {
  const ReorderableListViewPage({super.key});

  @override
  State<ReorderableListViewPage> createState() =>
      _ReorderableListViewPageState();
}

class _ReorderableListViewPageState extends State<ReorderableListViewPage> {
  final List<String> myTiles = [
    "A",
    "B",
    "C",
    "D",
  ];

  void updateMyTiles(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex--;
      }
      final tile = myTiles.removeAt(oldIndex);
      myTiles.insert(newIndex, tile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ReorderableList View"),
      ),
      body: ReorderableListView(
        onReorder: updateMyTiles,
        children: myTiles
            .map((e) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  key: ValueKey(e),
                  color: Colors.amber,
                  child: ListTile(
                    title: Text(e),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
