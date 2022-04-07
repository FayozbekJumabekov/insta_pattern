import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:insta_pattern/controllers/upload_controller.dart';

import '../views/image_pick_bottomsheet.dart';

class UploadPage extends StatelessWidget {
  PageController pageController;

  UploadPage({required this.pageController, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadController>(
        init: UploadController(),
        builder: (_controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              title: const Text(
                'Upload',
                style: TextStyle(
                    fontFamily: 'Billabong', color: Colors.black, fontSize: 28),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    _controller.uploadPost(context);
                  },
                  icon: Icon(FontAwesomeIcons.upload),
                  color: Colors.purple,
                )
              ],
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        /// Image
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              color: Colors.grey.shade300,
                              child: (_controller.image == null)
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.add_a_photo,
                                      ),
                                      onPressed: () {
                                        buildShowModalBottomSheet(
                                            context, _controller);
                                      },
                                      iconSize: 50,
                                      color: Colors.grey,
                                    )
                                  : Image.file(_controller.image!),
                            ),
                            if (_controller.image != null)
                              IconButton(
                                onPressed: () {
                                  _controller.setImage(null);
                                },
                                icon: Icon(CupertinoIcons.clear_circled),
                                color: Colors.white,
                              )
                          ],
                        ),

                        /// TextField Caption
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: TextField(
                            controller: _controller.captionController,
                            maxLines: null,
                            maxLength: null,
                            cursorColor: Colors.grey,
                            onSubmitted: (text){

                            },
                            decoration: const InputDecoration(
                                hintText: "Caption",
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        Divider(
                          height: 0,
                          color: Colors.grey.shade700,
                        )
                      ],
                    ),
                  ),
                  if (_controller.isLoading)
                    const CupertinoActivityIndicator(
                      radius: 30,
                      color: Colors.blue,
                    )
                ],
              ),
            ),
          );
        });
  }


}
