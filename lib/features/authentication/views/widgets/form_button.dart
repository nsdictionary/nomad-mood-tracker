import 'package:flutter/material.dart';

import '../../../../constants/sizes.dart';

class FormButton extends StatelessWidget {
  final bool disabled;
  final void Function(BuildContext? context)? onTapFunc;
  final String text;

  const FormButton({
    super.key,
    required this.disabled,
    this.onTapFunc,
    this.text = 'Next',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTapFunc is Function) onTapFunc!(context);
      },
      child: FractionallySizedBox(
        widthFactor: 1,
        child: AnimatedContainer(
          padding: const EdgeInsets.symmetric(vertical: Sizes.size16),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(
              Sizes.size24,
            ),
            color: disabled
                ? Theme.of(context).primaryColor.withOpacity(0.8)
                : Theme.of(context).primaryColor,
          ),
          duration: const Duration(milliseconds: 300),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              color: disabled ? Colors.grey.shade400 : Colors.black,
              fontSize: Sizes.size18,
              fontWeight: FontWeight.w400,
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
