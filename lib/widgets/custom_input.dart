import 'package:flutter/material.dart';
import '../design_system/colors.dart';
import '../design_system/typography.dart';

class CustomInput extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? errorText;
  final Widget? prefix;
  final Widget? suffix;
  final int maxLines;
  final bool enabled;

  const CustomInput({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.errorText,
    this.prefix,
    this.suffix,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          autofocus: autofocus,
          maxLines: maxLines,
          enabled: enabled,
          style: AppTypography.body.copyWith(color: AppColors.textPrimary),
          cursorColor: AppColors.accentPrimary,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.body.copyWith(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.backgroundTertiary,
            prefixIcon: prefix,
            suffixIcon: suffix,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.accentPrimary, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 1),
            ),
            errorText: errorText,
            errorStyle: AppTypography.caption.copyWith(color: AppColors.error),
          ),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
        ),
      ],
    );
  }
}