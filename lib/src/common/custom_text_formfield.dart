
import 'package:flutter/material.dart';
import 'package:vrhaman/constants.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? label; // Add this line
  final Function()? onTap;
  final String? errorText;
  final bool isPrefix;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.label,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.validator, // Add this line
    this.errorText,
    this.isPrefix = false,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style:  smallTextStyle
          ),
        if (widget.label != null) const SizedBox(height: 10),
        TextFormField(
          
          onTap: widget.onTap,
          style: smallTextStyle,
          
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
            validator: widget.validator, // Add this line
            
          decoration: InputDecoration(
            // prefix: widget.isPrefix ? Text('+91') : null,
                prefixIcon: widget.isPrefix ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 10),
                  child: Text('+91', style: smallTextStyle,),
                ) : null,
           
            hintText: widget.hintText,

            filled: true,
            errorText: widget.errorText,
            // fillColor: _isFocused ? secondaryColor : lightGreyColor,
            enabledBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? whiteColor
                    : greyColor,
              ),
            ),
            focusedBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: primaryColor, style: BorderStyle.solid),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red, style: BorderStyle.solid),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red, style: BorderStyle.solid),
            )
          ),
          
        ),
      ],
    );
  }
}