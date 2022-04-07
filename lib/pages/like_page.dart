import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_pattern/controllers/like_controller.dart';
import '../views/glow_widget.dart';
import '../views/liked_user_listtile.dart';

class LikePage extends StatelessWidget {
  const LikePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: const Text(
          'Activity',
          style: TextStyle(
              fontSize: 35, color: Colors.black, fontFamily: 'Billabong'),
        ),
      ),
      body: GetBuilder<LikeController>(
          init: LikeController(),
          builder: (_controller) {
            return Glow(
                child: Stack(
              alignment: Alignment.center,
              children: [
                if (_controller.users.isNotEmpty)
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _controller.users.length,
                            itemBuilder: (context, index) {
                              return userLikeListTile(
                                  _controller, _controller.users[index]);
                            }),
                      ],
                    ),
                  ),
                if (_controller.users.isEmpty && (!_controller.isLoading))
                  const Center(
                    child: Text(
                      'Activities are not found ...',
                      style: TextStyle(fontFamily: 'Billabong', fontSize: 25),
                    ),
                  ),
                if (_controller.isLoading)
                  const Center(
                    child: CupertinoActivityIndicator(
                      radius: 25,
                    ),
                  )
              ],
            ));
          }),
    );
  }

}
