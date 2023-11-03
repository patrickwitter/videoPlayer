import 'package:flutter/material.dart';
import 'package:reordablelist/demo/demo_player.dart';
import 'package:reordablelist/demo/video.dart';

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  List<Video> videoLibrary = [
    Video(
        url:
            "https://storage.googleapis.com/staging.elite-firefly-403919.appspot.com/10sec1.mp4",
        name: "Clip1"),
    Video(
        url:
            "https://storage.googleapis.com/staging.elite-firefly-403919.appspot.com/10sec2.mp4",
        name: "Clip2"),
    // Video(
    //     url:
    //         "https://storage.googleapis.com/staging.elite-firefly-403919.appspot.com/10sec1.mp4",
    //     name: "Clip3"),
    // Video(
    //     url:
    //         "https://storage.googleapis.com/staging.elite-firefly-403919.appspot.com/10sec2.mp4",
    //     name: "Clip4"),
  ];
  List<Video> timeline = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Builder POC"),
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * .4,
            child: DemoPlayer(
              videoToBePlayed: timeline,
              key: ValueKey(timeline.map((video) => video.name).join("-")),
            ),
          ),
          Container(
            color: Colors.grey.shade300,
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * .1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: videoLibrary.length,
              itemBuilder: (context, index) {
                return Draggable<Video>(
                  data: videoLibrary[index],
                  child: SizedBox(
                    width: 100,
                    child: ListTile(
                      title: Text(videoLibrary[index].name),
                    ),
                  ),
                  feedback: Material(
                      child: Container(
                          alignment: Alignment.center,
                          height: 100,
                          width: 200,
                          color: Colors.blue.shade100,
                          child: Text(
                            videoLibrary[index].name,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ))),
                );
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.green.shade100,
            height: 200,
            width: MediaQuery.sizeOf(context).width,
            child: DragTarget<Video>(
              onAccept: (receivedItem) {
                setState(() {
                  timeline.add(receivedItem);
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
                    final item = timeline.removeAt(oldIndex);
                    timeline.insert(newIndex, item);
                  });
                },
                children: [
                  for (int i = 0; i < timeline.length; i++)
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
                                    timeline.removeAt(i);
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
                                title: Text(timeline[i].name),
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
