import 'dart:math';
import 'dart:ui' as ui;
import 'package:vector_math/vector_math.dart' as Vector;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class RainbowFlagHome extends StatefulWidget {
  @override
  _RainbowFlagHomeState createState() => new _RainbowFlagHomeState();

  RainbowFlagHome() {
    timeDilation = 1.0;
  }
}

class _RainbowFlagHomeState extends State<RainbowFlagHome> {
  @override
  Widget build(BuildContext context) {
    Size size = new Size(MediaQuery.of(context).size.width, 300.0);
    return new Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,

        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.width-100.0,
              child: Image.network('http://cdn.shopify.com/s/files/1/0552/9413/products/LOVE_WINS_grande.png?v=1520808072')),
          new Stack(

            children: <Widget>[
              new ColorCurveBody(size: size, xOffset: 30, yOffset: -10, color: Colors.red), // xOffset value for windy flag effect
              new ColorCurveBody(size: size, xOffset: 10, yOffset: 20, color: Colors.orange), // xOffset value for windy flag effect
              new ColorCurveBody(size: size, xOffset: 0, yOffset: 50, color: Colors.yellow),
              new ColorCurveBody(size: size, xOffset: 0, yOffset: 80, color: Colors.green),
              new ColorCurveBody(size: size, xOffset: 0, yOffset: 110, color: Colors.blue),
              new ColorCurveBody(size: size, xOffset: 0, yOffset: 140, color: Colors.purple),
              new ColorCurveBody(size: size, xOffset: 20, yOffset: 170, color:Colors.white),

            ],
          ),
        ],
      ),
    );
  }
}

class ColorCurveBody extends StatefulWidget {
  final Size size;
  final int xOffset;
  final int yOffset;
  final Color color;

  ColorCurveBody(
      {Key key, @required this.size, this.xOffset, this.yOffset, this.color})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _ColorCurveBodyState();
  }
}

class _ColorCurveBodyState extends State<ColorCurveBody> with TickerProviderStateMixin {
  AnimationController animationController;
  List<Offset> animList1 = [];

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));

    animationController.addListener(() {
      animList1.clear();
      for (int i = -2 - widget.xOffset;
      i <= widget.size.width.toInt() + 2;
      i++) {
        animList1.add(new Offset(
            i.toDouble() + widget.xOffset,
            sin((animationController.value * 360 - i) %
                360 *
                Vector.degrees2Radians) *
                20 +
                50 +
                widget.yOffset));
      }
    });
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      child: new AnimatedBuilder(
        animation: new CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
        builder: (context, child) => new ClipPath(
          child: widget.color == null
              ? Image.network(
            'https://media.istockphoto.com/photos/rainbow-burst-abstract-background-picture-id502102504?k=6&m=502102504&s=612x612&w=0&h=635I_MQdo4S1FvSfp0Jqp1L4mFn49UwFMeEbPMwyol0=',
            width: widget.size.width,
            height: widget.size.height,
            fit: BoxFit.cover,
          )
              : new Container(
            width: widget.size.width,
            height: widget.size.height,
            color: widget.color,
          ),
          clipper: new WaveClipper(animationController.value, animList1),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double animation;

  List<Offset> waveList1 = [];

  WaveClipper(this.animation, this.waveList1);

  @override
  Path getClip(Size size) {
    Path path = new Path();

    path.addPolygon(waveList1, false);

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      animation != oldClipper.animation;
}
