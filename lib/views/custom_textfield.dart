import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  TextEditingController textEditingController;
  String hintText;

  CustomTextField(
      {required this.textEditingController, required this.hintText, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            border: Border.all(color: Colors.grey.shade300)),
        child: TextField(
          controller: textEditingController,
          cursorColor: Colors.grey,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              hintText: hintText,
              hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
              border: InputBorder.none),
        ));
  }
}
