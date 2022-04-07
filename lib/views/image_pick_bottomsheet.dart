import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<dynamic> buildShowModalBottomSheet(
    BuildContext context,  _controller) {
  return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(children: [
            const SizedBox(
              height: 10,
            ),

            /// From Gallery
            ListTile(
                leading: Icon(CupertinoIcons.photo_fill_on_rectangle_fill),
                title: Text(
                  'Pick Photo',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                onTap: () {
                  _controller.getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                }),

            /// Take Photo
            ListTile(
                leading: Icon(CupertinoIcons.camera_fill),
                title: Text(
                  'Take Photo',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                onTap: () {
                  _controller.getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                }),
          ]),
        );
      });
}
