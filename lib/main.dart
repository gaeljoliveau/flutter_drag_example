import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: DragPage(),
        ),
      ),
    );
  }
}

class DragPage extends StatefulWidget {
  const DragPage({super.key});

  @override
  State<DragPage> createState() => _DragPageState();
}

class _DragPageState extends State<DragPage> {
  List<Offset> shapes = [const Offset(100, 100), Offset(300, 100)];

  @override
  Widget build(
    BuildContext context,
  ) {
    GlobalKey key = GlobalKey();

    double getDistance(Offset a, Offset b) {
      final x1 = a.dx;
      final y1 = a.dy;
      final x2 = b.dx;
      final y2 = b.dy;

      return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
    }

    double getAngle(Offset a, Offset b) {
      final x1 = a.dx;
      final y1 = a.dy;
      final x2 = b.dx;
      final y2 = b.dy;

      return atan((y1 - y2) / (x1 - x2));
    }

    return Stack(
      key: key,
      children: [
        Positioned(
          top: shapes[0].dy +
              24 +
              (0.5 * getDistance(shapes[0], shapes[1])) *
                  sin(getAngle(shapes[0], shapes[1])),
          left: shapes[0].dx +
              24 -
              (0.5 * getDistance(shapes[0], shapes[1])) *
                  (1 - cos(getAngle(shapes[0], shapes[1]))),
          child: Transform.rotate(
            angle: getAngle(shapes[0], shapes[1]),
            child: Container(
              height: 2,
              width: getDistance(shapes[0], shapes[1]),
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.rectangle,
              ),
            ),
          ),
        ),
        Positioned(
          top: shapes[0].dy,
          left: shapes[0].dx,
          child: Draggable(
            feedback: RoundWidget(),
            key: UniqueKey(),
            onDragEnd: (details) {
              RenderBox box =
                  key.currentContext!.findRenderObject() as RenderBox;
              Offset zonePosition = box.localToGlobal(Offset.zero);
              print(zonePosition);
              setState(() {
                shapes = [
                  details.offset - zonePosition,
                  shapes[1],
                ];
              });
            },
            childWhenDragging: SizedBox(),
            child: RoundWidget(),
          ),
        ),
        Positioned(
          top: shapes[1].dy,
          left: shapes[1].dx,
          child: Draggable(
            feedback: RoundWidget(),
            key: UniqueKey(),
            onDragEnd: (details) {
              RenderBox box =
                  key.currentContext!.findRenderObject() as RenderBox;
              Offset zonePosition = box.localToGlobal(Offset.zero);
              print(zonePosition);
              setState(() {
                shapes = [
                  shapes[0],
                  details.offset - zonePosition,
                ];
              });
            },
            onDragUpdate: (details) {
              RenderBox box =
                  key.currentContext!.findRenderObject() as RenderBox;
              Offset zonePosition = box.localToGlobal(Offset.zero);
              print(details.localPosition);

              /*setState(() {
                shapes = [
                  shapes[0],
                  details.localPosition,
                ];
              });*/
            },
            childWhenDragging: SizedBox(),
            child: RoundWidget(),
          ),
        ),
      ],
    );
  }
}

class RoundWidget extends StatelessWidget {
  const RoundWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
    );
  }
}
