library nice_buttons;

import 'package:flutter/material.dart';

enum GradientOrientation {
  Vertical,
  Horizontal,
}

class NiceButtons extends StatefulWidget {
  /// The gradient start color.
  final Color startColor;

  /// The gradient start color.
  final Color endColor;

  /// The color of the 3D border.
  final Color borderColor;

  /// Orientation of the gradient defaults to Horizontal.
  final GradientOrientation gradientOrientation;

  /// The thickness of the 3D border, defaults to 5.
  final double borderThickness;

  /// Height of the button, defaults to 60.
  final double height;

  /// The border radius of the button, defaults to 20.
  final double borderRadius;

  /// whether to occupy the full available space in the parent, defaults to true.
  final bool stretch;

  /// Width of the button defaults to 200, its useless if the stretch property is set to true.
  final double width;

  final bool progress;

  Widget child;
  BorderRadius br;
  double calculatedWidth;

  NiceButtons(
      {this.startColor = const Color(0xFF2ec8ff),
      this.endColor = const Color(0xFF529fff),
      this.borderColor = const Color(0xFF3489e9),
      this.borderRadius = 20,
      this.borderThickness = 5,
      this.height = 60,
      this.width = 200,
      this.gradientOrientation = GradientOrientation.Vertical,
      this.stretch = true,
      this.progress = false,
      this.child}) {
    this.br = BorderRadius.all(Radius.circular((this.borderRadius)));
    if (this.stretch) {
      this.calculatedWidth = double.infinity;
    } else {
      this.calculatedWidth = this.width;
    }
  }

  @override
  _NiceButtonsState createState() => _NiceButtonsState(borderThickness);
}

class _NiceButtonsState extends State<NiceButtons> {
  double _borderThickness;
  double _moveMargin = 0.0;

  _NiceButtonsState(double borderThickness) {
    this._borderThickness = borderThickness;
  }

  Widget _buildBackLayout() {
    return Container(
      padding: EdgeInsets.only(top: _borderThickness),
      width: double.infinity,
      height: double.infinity,
      child: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          borderRadius: widget.br,
          color: widget.borderColor,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(
              width: double.infinity, height: double.infinity),
        ),
      ),
    );
  }

  Widget _buildFrontLayout() {
    return AnimatedContainer(
      onEnd: () {
        setState(() {
          _moveMargin = 0;
        });
      },
      margin: EdgeInsets.only(top: _moveMargin),
      duration: Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: widget.br,
        gradient: LinearGradient(
          begin: widget.gradientOrientation == GradientOrientation.Vertical
              ? Alignment.topCenter
              : Alignment.centerLeft,
          end: widget.gradientOrientation == GradientOrientation.Vertical
              ? Alignment.bottomCenter
              : Alignment.centerRight,
          colors: [
            widget.startColor,
            widget.endColor,
          ],
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(
            width: double.infinity, height: widget.height - _borderThickness),
        child: Align(
          alignment: Alignment.center,
          child: widget.child != null ? widget.child : Text(''),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          print('Tapped');
          _moveMargin = _borderThickness;
        });
      },
      child: Container(
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(
              width: widget.calculatedWidth, height: widget.height),
          child: Stack(
            children: <Widget>[
              _buildBackLayout(),
              _buildFrontLayout(),
            ],
          ),
        ),
      ),
    );
  }
}
