import 'package:flutter/material.dart';import 'package:flutter_curiosity/curiosity.dart';class ScannerBox extends StatefulWidget {  final Widget child;  ScannerBox({Key key, this.child}) : super(key: key);  @override  ScannerBoxState createState() => ScannerBoxState();}class ScannerBoxState extends State<ScannerBox> with TickerProviderStateMixin {  AnimationController controller;  @override  void initState() {    super.initState();    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));    controller.repeat(reverse: true);  }  @override  void dispose() {    controller.dispose();    super.dispose();  }  @override  Widget build(BuildContext context) {    return AnimatedBuilder(        animation: controller,        builder: (BuildContext context, Widget child) =>            CustomPaint(              foregroundPainter: ScannerPainter(value: controller.value,                  borderColor: Colors.white, scannerColor: Colors.black),              child: widget.child,              willChange: true,            ));  }}