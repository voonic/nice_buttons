library nice_buttons;

import 'package:flutter/material.dart';

class NiceButtonsStyle {
  final Color topColor;
  final Color backColor;
  final BorderRadius borderRadius;
  final double z;
  final double tappedZ;
  const NiceButtonsStyle(
      {this.topColor = const Color(0xFF45484c),
      this.backColor = const Color(0xFF191a1c),
      this.borderRadius = const BorderRadius.all(Radius.circular(7.0)),
      this.z = 8.0,
      this.tappedZ = 3.0});

  static const RED = const NiceButtonsStyle(
      topColor: const Color(0xFFc62f2f), backColor: const Color(0xFF922525));
  static const BLUE = const NiceButtonsStyle(
      topColor: const Color(0xFF25a09c), backColor: const Color(0xFF197572));
  static const WHITE = const NiceButtonsStyle(
      topColor: const Color(0xFFffffff), backColor: const Color(0xFFCFD8DC));
}

class NiceButtons extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final NiceButtonsStyle style;
  final double width;
  final double height;

  NiceButtons(
      {@required this.onPressed,
      @required this.child,
      this.style = NiceButtonsStyle.WHITE,
      this.width = 100.0,
      this.height = 90.0});

  @override
  State<StatefulWidget> createState() => NiceButtonsState();
}

class NiceButtonsState extends State<NiceButtons> {
  bool isTapped = false;

  Widget _buildBackLayout() {
    return Padding(
      padding: EdgeInsets.only(top: widget.style.z),
      child: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
            borderRadius: widget.style.borderRadius,
            boxShadow: [BoxShadow(color: widget.style.backColor)]),
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(
              width: widget.width, height: widget.height - widget.style.z),
        ),
      ),
    );
  }

  Widget _buildTopLayout() {
    return Padding(
      padding: EdgeInsets.only(
          top: isTapped ? widget.style.z - widget.style.tappedZ : 0.0),
      child: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
            borderRadius: widget.style.borderRadius,
            boxShadow: [BoxShadow(color: widget.style.topColor)]),
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(
              width: widget.width, height: widget.height - widget.style.z),
          child: Container(
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[_buildBackLayout(), _buildTopLayout()],
      ),
      onTapDown: (TapDownDetails event) {
        setState(() {
          isTapped = true;
        });
      },
      onTapCancel: () {
        setState(() {
          isTapped = false;
        });
      },
      onTapUp: (TapUpDetails event) {
        setState(() {
          isTapped = false;
        });
        widget.onPressed();
      },
    );
  }
}
