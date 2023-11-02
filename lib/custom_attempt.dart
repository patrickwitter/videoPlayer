import 'package:flutter/material.dart';

class CustomAttempt extends StatefulWidget {
  const CustomAttempt({super.key});

  @override
  State<CustomAttempt> createState() => _CustomAttemptState();
}

class _CustomAttemptState extends State<CustomAttempt> {
  List<String> list1Items = List.generate(10, (index) => 'Video $index');
  List<String> list2Items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Builder UI POC'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: list1Items.length,
              itemBuilder: (context, index) {
                return Draggable<String>(
                  data: list1Items[index],
                  child: ListTile(
                    title: Text(list1Items[index]),
                  ),
                  feedback: Material(
                      child: Container(
                          height: 100,
                          color: Colors.blue.shade100,
                          child: Text(list1Items[index]))),
                );
              },
            ),
          ),
          Container(
            color: Colors.green.shade100,
            height: 200,
            width: MediaQuery.sizeOf(context).width,
            child: DragTarget<String>(
              onAccept: (receivedItem) {
                setState(() {
                  list2Items.add(receivedItem);
                });
              },
              builder: (context, candidateData, rejectedData) =>
                  ReorderableListView(
                scrollDirection: Axis.horizontal,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final item = list2Items.removeAt(oldIndex);
                    list2Items.insert(newIndex, item);
                  });
                },
                children: [
                  for (int i = 0; i < list2Items.length; i++)
                    Padding(
                      key: UniqueKey(),
                      padding: EdgeInsets.only(top: 10, left: i == 0 ? 15 : 0),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                            top: 100,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    list2Items.removeAt(i);
                                  });
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Container(
                              color: Colors.grey.shade100,
                              width: 110,
                              height: 100,
                              child: ListTile(
                                title: Text(list2Items[i]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
