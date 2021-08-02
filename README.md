# nice_buttons
`nice_buttons` a beautiful, animated, and customisable 3D button for your flutter project.

/// The color of circular progress indicator, defaults to white
  final Color ;

  /// The size of progress indicator circle, defaults to 20
  final double progressSize;

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

  /// Whether the progress indicator is required or not, defaults to false
  final bool progress;

  /// Disables the button, defaults to false
  final bool disabled;

  ///button press handler, required
  final Function onTap;

### Customisations

| Attribute |    Type    |  Default  | Description  |
| :-------- | :--------: | :-------: | :-------------------------------------------------------------------|
| `startColor` |  `Color`  | `0xFF2ec8ff` | The gradient start color |
| `endColor` |  `Color`  | `0xFF529fff` | The gradient end color |
| `borderColor` |  `Color`  | `0xFF3489e9` | The color of the 3D border. |
| `progressColor` |  `Color`  | `white` | The color of circular progress indicator, defaults to white |
| `progressSize` |  `Double  | `20` | The size of progress indicator circle, defaults to 20 |

