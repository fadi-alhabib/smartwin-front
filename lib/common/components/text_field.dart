import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/widgets.dart';
// import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class MyTextField extends FormField<String> {
  final Widget? suffix;
  final Widget? lable;
  final TextInputType? keyboardType;
  final String? hint;
  final TextEditingController? controller;
  final bool expands;
  final Function()? onTap;
  final void Function(String)? onChanged;
  final bool? isSecure;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  final Widget? prefix;
  MyTextField({
    super.key,
    final FormFieldValidator<String>? validator,
    this.suffix,
    this.expands = false,
    this.lable,
    this.keyboardType,
    this.hint,
    this.controller,
    this.onChanged,
    this.margin,
    this.padding,
    this.onTap,
    this.isSecure,
    this.prefix,
  }) : super(
            initialValue: controller?.text,
            validator: validator,
            builder: (field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      margin: margin,
                      padding: padding,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(-0.5, -0.5),
                                blurRadius: 5,
                                blurStyle: BlurStyle.normal,
                                color: field.hasError
                                    ? Colors.red.shade300
                                    : Colors.black38),
                            BoxShadow(
                                offset: const Offset(0.5, 1),
                                blurRadius: 5,
                                blurStyle: BlurStyle.normal,
                                color: field.hasError
                                    ? Colors.red.shade200
                                    : Colors.black45)
                          ]),
                      child: TextFormField(
                        onChanged: (value) {
                          field.setValue(value);
                        },
                        onTap: onTap,
                        keyboardType: keyboardType,
                        obscureText: isSecure ?? false,
                        maxLines: expands ? 8 : 1,
                        controller: controller,
                        decoration: InputDecoration(
                          label: lable,
                          prefixIcon: prefix,
                          border: InputBorder.none,
                          hintText: hint,
                          errorBorder: InputBorder.none,
                          suffixIcon: suffix,
                        ),
                      )),
                  field.hasError
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            field.errorText!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14),
                          ),
                        )
                      : const SizedBox()
                ],
              );
            });
}
