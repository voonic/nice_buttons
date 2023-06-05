library nice_buttons;

import 'package:flutter/material.dart';

/// Gradient settings enum, this can be used to change the direction of the button
/// color gradients.
enum GradientOrientation {
  Vertical,
  Horizontal,
}

class NiceButtons extends StatefulWidget {
  /// The gradient start color from left when gradientOrientation is horizontal,
  /// from top when orientation is vertical.
  final Color startColor;

  /// The gradient end color to right when orientation is horizontal and to
  /// bottom when orientation is vertical.
  final Color endColor;

  /// The color of the 3D border of the button.
  final Color borderColor;

  /// The color of circular progress indicator, defaults to white.
  final Color progressColor;

  /// The size of progress indicator circle, defaults to 20.
  final double progressSize;

  /// Orientation of the gradient defaults to Horizontal.
  final GradientOrientation gradientOrientation;

  /// The thickness of the 3D border, defaults to 5.
  final double borderThickness;

  /// Height of the button, defaults to 60.
  final double height;

  /// The border radius for the button, defaults to 20.
  final double borderRadius;

  /// Whether to occupy the full available space in the parent, defaults to true.
  final bool stretch;

  /// Width of the button defaults to 200, it's useless if the stretch property
  /// is set to true.
  final double width;

  /// Whether the progress indicator is required or not, defaults to false.
  final bool progress;

  /// Disables the button, defaults to false.
  final bool disabled;

  /// Button on press handler, required.
  final Function onTap;

  /// Child widget that will be wrapped inside the button.
  final Widget child;

  /// The calculated border radius for the buttons.
  final BorderRadius br;

  /// The calculated width of the button, sets to parent width when
  /// stretch property is set to true.
  final double calculatedWidth;

  NiceButtons({
    required this.onTap,
    required this.child,
    this.startColor = const Color(0xFF2ec8ff),
    this.endColor = const Color(0xFF529fff),
    this.borderColor = const Color(0xFF3489e9),
    this.progressColor = Colors.white,
    this.progressSize = 20,
    this.borderRadius = 20,
    this.borderThickness = 5,
    this.height = 60,
    this.width = 200,
    this.gradientOrientation = GradientOrientation.Vertical,
    this.stretch = true,
    this.progress = false,
    this.disabled = false,
  })  : this.br = BorderRadius.all(Radius.circular((borderRadius))),
        this.calculatedWidth = stretch ? double.infinity : width;

  @override
  _NiceButtonsState createState() => _NiceButtonsState(borderThickness);
}

/// Button state to keep track of press and progress animations.
class _NiceButtonsState extends State<NiceButtons>
    with TickerProviderStateMixin {
  double _borderThickness = 5;
  double _moveMargin = 0.0;
  double _progressWidth = 0.0;
  bool _showProgress = false;
  bool _tapped = false;
  bool _processing = false;
  int _progressBarMillis = 2500;

  _NiceButtonsState(double borderThickness) {
    this._borderThickness = borderThickness;
  }

  /// The back view of the button that gives the feel of 3D border.
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

  /// The front view of the button, that has the user child widget content and
  /// progress widget to show progress animation.
  Widget _buildFrontLayout() {
    return AnimatedContainer(
      onEnd: () {
        setState(() {
          _moveMargin = 0;
          if (widget.progress && !_showProgress && _tapped) {
            _showProgress = true;
            _progressWidth = double.infinity;
            _processing = true;
            _progressBarMillis = 2500;
          }
          _tapped = false;
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
        child: ClipRRect(
          borderRadius: widget.br,
          child: Stack(
            children: <Widget>[
              _buildProgressBar(),
              if (_showProgress) _buildProgressCircle(),
              if (!_showProgress) _buildUserChild(),
            ],
          ),
        ),
      ),
    );
  }

  /// The progress widget.
  Widget _buildProgressBar() {
    return AnimatedSize(
      duration: Duration(milliseconds: _progressBarMillis),
      curve: Curves.fastOutSlowIn,
      child: Container(
        width: _progressWidth,
        height: double.infinity,
        color: new Color.fromARGB(60, 255, 255, 255),
      ),
    );
  }

  /// The progress circle widget.
  Widget _buildProgressCircle() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: widget.progressSize,
          height: widget.progressSize,
          child: CircularProgressIndicator(
              valueColor:
                  new AlwaysStoppedAnimation<Color>(widget.progressColor)),
        ),
      ),
    );
  }

  /// User provided child widget.
  Widget _buildUserChild() {
    return Align(
      alignment: Alignment.center,
      //child: widget.child != null ? widget.child : Text(''),
      child: widget.child,
    );
  }

  /// The button press handler for the gesture detector. This will be triggered
  /// when button is pressed. Calls the user provided onTap function.
  void _onTap() {
    setState(() {
      _moveMargin = _borderThickness;
      _tapped = true;
    });
    widget.onTap(_finish);
  }

  /// The finish method that will reset the state of the animation, user
  /// has to call this explicitly from the parent.
  void _finish() {
    setState(() {
      _showProgress = false;
      _progressWidth = 0;
      _processing = false;
      _progressBarMillis = 1;
    });
  }

  /// The cumulative button widget that builds the front and back layout of the
  /// button.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.disabled || _processing ? null : _onTap,
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
