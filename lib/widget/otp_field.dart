import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../const/app_color.dart';

/// Defines the types of haptic feedback that can be triggered by [AnimatedOtpInput].
///
/// Use this enum to specify the intensity or style of haptic feedback for success or error events.
/// This allows you to tailor the tactile response to match your application's UX requirements.
///
/// - [light]: Triggers a light impact vibration, suitable for subtle feedback is [HapticFeedback.lightImpact].
/// - [medium]: Triggers a medium impact vibration, providing moderate feedback is [HapticFeedback.mediumImpact].
/// - [heavy]: Triggers a heavy impact vibration, for strong and noticeable feedback is [HapticFeedback.heavyImpact].
/// - [vibrate]: Triggers a standard device vibration, typically longer and more pronounced is [HapticFeedback.vibrate].
/// - [none]: Disables haptic feedback for the event is.
enum OtpHapticType { light, medium, heavy, vibrate, none }

/// {@template animated_otp_input}
/// # AnimatedOtpInput
///
/// A highly customizable, animated, and accessible One-Time Password (OTP) input widget for Flutter applications.
///
/// ## Overview
/// `AnimatedOtpInput` provides a robust and user-friendly solution for entering OTP, PIN, or verification codes.
/// It is designed for professional apps requiring advanced UX, accessibility, and flexible theming.
///
/// ## Key Features
/// - **Paste detection:** Automatically fills all fields when a complete code is pasted.
/// - **Animated focus:** Each field animates on focus, with customizable scale, duration, and curve.
/// - **Per-field error indication:** Empty fields show a red border for instant feedback.
/// - **Accessibility:** Each field is wrapped in [Semantics] for screen reader support.
/// - **Custom theming:** Use [OtpInputTheme] to style borders, colors, text, and animation.
/// - **Obscure text:** Optionally hide digits for PIN entry, with a custom obscuring character.
/// - **Automatic focus shifting:** Moves focus as the user types or deletes.
/// - **Auto-focus:** Optionally focuses the first field when the keyboard opens.
/// - **LTR layout:** Always left-to-right for consistent OTP entry, even in RTL locales.
/// - **Haptic feedback:** Optionally trigger haptic feedback on success or error, with customizable feedback type.
///
/// ## Usage Example
/// ```dart
/// AnimatedOtpInput(
///   length: 6,
///   onChanged: (otp) => print(otp),
///   theme: OtpInputTheme(
///     borderRadius: BorderRadius.circular(12),
///     animationDuration: Duration(milliseconds: 300),
///   ),
///   enableSuccessHaptic: true,
///   enableErrorHaptic: true,
///   errorMessage: "Invalid OTP. Please try again.",
/// )
/// ```
///
/// ## Constructor Parameters
/// - [length] (`int`): Number of OTP digits. Defaults to 6.
/// - [onChanged] (`void Function(String)?`): Callback for OTP value changes.
/// - [enabled] (`bool`): Whether fields are editable. Defaults to true.
/// - [fieldWidth] (`double`): Width of each field. Defaults to 45.
/// - [fieldSpacing] (`double`): Space between fields. Defaults to 4.
/// - [theme] ([OtpInputTheme]): Customizes appearance and animation.
/// - [obscureText] (`bool`): Hides digits for PIN entry. Defaults to false.
/// - [obscureCharacter] (`String`): Character for obscured digits. Defaults to '•'.
/// - [autoFocusFirstField] (`bool`): Auto-focuses first field. Defaults to false.
/// - [semanticsLabel] (`String`): Base label for accessibility. Defaults to 'OTP digit'.
/// - [semanticsHint] (`String?`): Base hint for accessibility. Defaults to null.
/// - [errorMessage] (`String?`): Error message displayed below fields.
/// - [enableSuccessHaptic] (`bool?`): Enable haptic feedback on success.
/// - [enableErrorHaptic] (`bool?`): Enable haptic feedback on error.
/// - [successHapticFeedback] ([OtpHapticType?]): Custom haptic feedback type for success.
/// - [errorHapticFeedback] ([OtpHapticType?]): Custom haptic feedback type for error.
///
/// ## Accessibility
/// - Each field is labeled for screen readers (e.g., "OTP digit 1").
/// - Semantics hints can be customized for better guidance.
///
/// ## Error Indication
/// - Empty fields show a red border for instant feedback.
/// - Custom error messages can be displayed below the input fields.
///
/// ## Animation
/// - Focused fields scale up with customizable animation via [OtpInputTheme].
///
/// ## Haptic Feedback
/// - Optionally trigger haptic feedback on success or error.
/// - Use [enableSuccessHaptic], [enableErrorHaptic], [successHapticFeedback], and [errorHapticFeedback] for configuration.
///
/// ## See Also
/// - [OtpInputTheme]: For customizing appearance and animation.
/// {@endtemplate}

class AnimatedOtpInput extends StatefulWidget {
  /// Error message to display below the OTP fields when validation fails.
  final String? errorMessage;

  /// The total number of digits in the OTP.
  ///
  /// Defaults to `6`.
  final int length;

  /// Callback called every time the combined OTP value changes.
  ///
  /// You can use this to trigger auto-submit when length is reached.
  final void Function(String)? onChanged;

  /// Whether the input fields are enabled.
  ///
  /// If `false`, the fields will be read-only and greyed out.
  /// Defaults to `true`.
  final bool enabled;

  /// The width of each individual OTP field.
  ///
  /// Defaults to `45`.
  final double fieldWidth;

  /// The spacing between each OTP field.
  ///
  /// Defaults to `4`.
  final double fieldSpacing;

  /// The theme used to customize the appearance of the OTP fields.
  ///
  /// You can provide borders, fill color, text style, etc.
  final OtpInputTheme theme;

  /// Whether to obscure each character (e.g. like a password field).
  ///
  /// Useful if you want to hide the entered digits (e.g., for PIN entry).
  /// Defaults to `false`.
  final bool obscureText;

  /// The character to use when [obscureText] is enabled.
  ///
  /// Defaults to `'•'`.
  final String obscureCharacter;

  /// Whether to automatically focus the first OTP field when keyboard opens.
  ///
  /// Defaults to `false`. Useful when you want a smoother UX.
  final bool autoFocusFirstField;

  /// The base semantics label for each OTP field.
  ///
  /// Defaults to 'OTP digit'. The field index will be appended automatically.
  final String semanticsLabel;

  /// The base semantics hint/description for each OTP field.
  ///
  /// This string is used to provide additional context to assistive technologies
  /// such as screen readers. If provided, the field index will be appended automatically
  /// (e.g., "Enter digit 1"). This improves accessibility for users with disabilities.
  /// Defaults to `null`.
  final String? semanticsHint;

  /// Whether to enable haptic feedback on successful OTP entry.
  ///
  /// When set to `true`, the widget will trigger a haptic feedback event
  /// (such as a light vibration) when the OTP is successfully entered or validated.
  /// This enhances the user experience by providing tactile confirmation.
  /// Defaults to `true`.
  final bool? enableSuccessHaptic;

  /// Whether to enable haptic feedback on OTP entry error.
  ///
  /// When set to `true`, the widget will trigger a haptic feedback event
  /// (such as a vibration or heavy impact) when an error occurs, such as entering
  /// an invalid OTP or leaving fields empty. This provides immediate feedback to the user.
  /// Defaults to `true`.
  final bool? enableErrorHaptic;

  /// Custom haptic feedback type to trigger on successful OTP entry.
  ///
  /// Use [OtpHapticType] to select the desired feedback intensity or vibration
  /// when a successful OTP entry occurs. Supported types include [OtpHapticType.light], [OtpHapticType.medium],
  /// [OtpHapticType.heavy], [OtpHapticType.vibrate], and [OtpHapticType.none].
  /// This allows for fine-grained control over success feedback.
  final OtpHapticType? successHapticFeedback;

  /// Custom haptic feedback type to trigger on OTP entry error.
  ///
  /// Use [OtpHapticType] to select the desired feedback intensity or vibration
  /// when an error occurs. Supported types include [OtpHapticType.light], [OtpHapticType.medium],
  /// [OtpHapticType.heavy], [OtpHapticType.vibrate], and [OtpHapticType.none].
  /// This allows for fine-grained control over error feedback.
  final OtpHapticType? errorHapticFeedback;

  /// Creates an animated and customizable OTP input field.
  ///
  /// All parameters are optional and have sensible defaults for common use cases.
  /// For advanced customization, provide a custom [OtpInputTheme], adjust field dimensions,
  /// enable or disable haptic feedback, and configure accessibility labels and hints.
  const AnimatedOtpInput({
    super.key,
    this.length = 6,
    this.onChanged,
    this.enabled = true,
    this.fieldWidth = 45,
    this.fieldSpacing = 4,
    this.theme = const OtpInputTheme(),
    this.obscureText = false,
    this.obscureCharacter = '•',
    this.autoFocusFirstField = false,
    this.semanticsLabel = 'OTP digit',
    this.semanticsHint,
    this.errorMessage,
    this.enableSuccessHaptic = true,
    this.enableErrorHaptic = true,
    this.successHapticFeedback = OtpHapticType.light,
    this.errorHapticFeedback = OtpHapticType.heavy,
  });

  @override
  State<AnimatedOtpInput> createState() => _AnimatedOtpInputState();
}

class _AnimatedOtpInputState extends State<AnimatedOtpInput>
    with SingleTickerProviderStateMixin {
  late final List<TextEditingController> controllers;
  late final List<FocusNode> focusNodes;
  late List<bool> fieldErrors;
  late List<bool> fieldFocused;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(widget.length, (_) => TextEditingController());
    focusNodes = List.generate(widget.length, (_) => FocusNode());
    // If errorMessage is set, initialize fieldErrors to true for all fields (empty)
    if (widget.errorMessage != null) {
      fieldErrors = List.generate(widget.length, (_) => true);
    } else {
      fieldErrors = List.generate(widget.length, (_) => false);
    }
    fieldFocused = List.generate(widget.length, (_) => false);
    for (int i = 0; i < widget.length; i++) {
      focusNodes[i].addListener(() {
        setState(() {
          fieldFocused[i] = focusNodes[i].hasFocus;
        });
      });
    }
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    for (final node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handlePaste(String pasted) {
    if (RegExp(r'^\d+$').hasMatch(pasted) && pasted.length == widget.length) {
      for (int i = 0; i < widget.length; i++) {
        controllers[i].text = pasted[i];
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        focusNodes.last.requestFocus();
      });
      widget.onChanged?.call(pasted);
    }
  }

  void _triggerHaptic(OtpHapticType? type) {
    if (type == null || type == OtpHapticType.none) return;
    switch (type) {
      case OtpHapticType.light:
        HapticFeedback.lightImpact();
        break;
      case OtpHapticType.medium:
        HapticFeedback.mediumImpact();
        break;
      case OtpHapticType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case OtpHapticType.vibrate:
        HapticFeedback.vibrate();
        break;
      case OtpHapticType.none:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure error state is correct on every build
    if (widget.errorMessage != null) {
      for (int i = 0; i < widget.length; i++) {
        fieldErrors[i] = controllers[i].text.isEmpty;
      }
    }
    // Removed unused hasError variable
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Directionality(
          textDirection:
              TextDirection.ltr, // OTP input is LTR even in RTL locales
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.length, (i) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: widget.fieldSpacing),
                width: widget.fieldWidth,
                child: Semantics(
                  label: '${widget.semanticsLabel} ${i + 1}',
                  hint: '${widget.semanticsHint} ${i + 1}',
                  enabled: widget.enabled,
                  textField: true,
                  child: TextFormField(
                    controller: controllers[i],
                    focusNode: focusNodes[i],
                    enabled: widget.enabled,
                    obscureText: widget.obscureText,
                    obscuringCharacter: widget.obscureCharacter,
                    autofocus:
                        widget.autoFocusFirstField &&
                        widget.enabled &&
                        i == 0 &&
                        MediaQuery.of(context).viewInsets.bottom == 0,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,

                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final pasted = newValue.text;
                        if (pasted.length == widget.length) {
                          _handlePaste(pasted);
                          // return TextEditingValue(
                          //   text: pasted[i],
                          //   selection: TextSelection.collapsed(offset: i),
                          // );
                        }
                        return newValue;
                      }),
                    ],
                    keyboardType: TextInputType.number,
                    textInputAction: i < widget.length - 1
                        ? TextInputAction.next
                        : TextInputAction.done,
                    maxLength: 1,
                    cursorColor: AppColor.primary,
                    textAlign: TextAlign.center,
                    style:
                        widget.theme.textStyle ??
                        Theme.of(context).textTheme.titleLarge,
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor:
                          widget.theme.fillColor ??
                          Theme.of(context).colorScheme.surface,
                      focusedBorder: widget.theme.focusedBorder,
                      errorBorder: widget.theme.errorBorder,
                      border:
                          widget.theme.border ??
                          OutlineInputBorder(
                            borderRadius:
                                widget.theme.borderRadius ??
                                BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                    ),
                    onChanged: (value) {
                      final fullOtp = controllers.map((c) => c.text).join();
                      widget.onChanged?.call(fullOtp);
                      setState(() {
                        fieldErrors[i] = value.isEmpty;
                      });

                      // Success haptic: when last field is filled and all fields are non-empty
                      if (value.isNotEmpty && i == widget.length - 1) {
                        if (widget.enableSuccessHaptic == true &&
                            controllers.every((c) => c.text.isNotEmpty)) {
                          _triggerHaptic(widget.successHapticFeedback);
                        }
                        FocusScope.of(context).unfocus();
                      }

                      // Error haptic: when errorMessage is shown and any field is empty
                      if (widget.errorMessage != null &&
                          widget.enableErrorHaptic == true &&
                          controllers.any((c) => c.text.isEmpty)) {
                        _triggerHaptic(widget.errorHapticFeedback);
                      }

                      if (value.isNotEmpty && i < widget.length - 1) {
                        focusNodes[i + 1].requestFocus();
                      } else if (value.isEmpty && i > 0) {
                        focusNodes[i - 1].requestFocus();
                      }
                    },
                  ),
                ),
              );
            }),
          ),
        ),
        if (widget.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.errorMessage!,
              style:
                  widget.theme.errorMessageStyle ??
                  TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
            ),
          ),
      ],
    );
  }
}

/// Defines the visual and animation style for [AnimatedOtpInput] fields.
///
/// Customize borders, fill color, text style, error style, border radius, and animation behavior.
///
/// Example usage:
/// ```dart
/// AnimatedOtpInput(
///   theme: OtpInputTheme(
///     border: OutlineInputBorder(),
///     fillColor: Colors.grey[200],
///     textStyle: TextStyle(fontSize: 20),
///     focusedScale: 1.15,
///     animationDuration: Duration(milliseconds: 300),
///     animationCurve: Curves.easeOutBack,
///   ),
/// )
/// ```
class OtpInputTheme {
  /// Default border for OTP fields.
  final InputBorder? border;

  /// Border when a field is focused.
  final InputBorder? focusedBorder;

  /// Border when a field is in error state.
  final InputBorder? errorBorder;

  /// Background color of OTP fields.
  final Color? fillColor;

  /// Text style for digits.
  final TextStyle? textStyle;

  /// Text style for the error message shown below OTP field.
  ///
  /// Used for the [errorMessage] property in [AnimatedOtpInput].
  final TextStyle? errorMessageStyle;

  /// Corner radius for fields.
  final BorderRadius? borderRadius;

  /// Duration of focus scale animation.

  /// Curve of focus scale animation.

  /// Scale factor when a field is focused.

  /// Border width for all OTP field borders (default: 2.0).

  /// Creates an [OtpInputTheme] for customizing [AnimatedOtpInput] fields.
  const OtpInputTheme({
    this.border,
    this.focusedBorder,
    this.errorBorder,
    this.fillColor,
    this.textStyle,
    this.errorMessageStyle,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });
}
