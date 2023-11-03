import 'package:flutter/material.dart';
import 'package:reordablelist/custom_attempt.dart';
import 'package:reordablelist/demo/demo.dart';
import 'package:reordablelist/listtolist/basic_example.dart';
import 'package:reordablelist/listtolist/dragintolist.dart';
import 'package:reordablelist/listtolist/horizaontal_example.dart';
import 'package:reordablelist/reordable_listview.dart';
import 'package:reordablelist/reordables/nested_wrap.dart';
import 'package:reordablelist/reorder_gridview/demo_grid_builder.dart';
import 'package:reordablelist/video_stich.dart';
import 'package:reordablelist/video_stich2.dart';
import 'package:reordablelist/video_stich_final.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: NestedWrapExample(),
      // home: BasicExample(),
      // home: HorizontalExample(),
      // home: ReorderableListViewPage(),
      // home: const CustomAttempt(),
      // home: VideoSequencePlayer(),
      // home: VideoSequencePlayer2(),
      home: Demo(),
    );
  }
}
