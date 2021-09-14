import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/VideoData.dart';
import 'package:raid/provider/GetProvider.dart';
import 'package:raid/style/FCITextStyles.dart';

import 'VideoCard.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var provider = Provider.of<GetProvider>(context, listen: false);

    return provider.busy
        ? loading()
        : Padding(
            padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(10),
                horizontal: ScreenUtil().setWidth(20)),
            child: ListView.builder(
              itemCount: provider.videosData.length + 1,
              itemBuilder: (context, index) => index == 0
                  ? Column(
                      children: [
                        Text(
                          'فيديوهات تهمك',
                          style: FCITextStyle(color: AccentColor).bold20(),
                        ),
                        /* Text(
                    'Flutter is Googles UI toolkit for building beautiful, natively compiled applications for mobile, web, desktop, and embedded devices from a single codebase. ',
                    style: FCITextStyle(color: AccentColor).normal10(),
                    textAlign: TextAlign.center,
                  ),*/
                        SizedBox(
                          height: ScreenUtil().setHeight(15),
                        )
                      ],
                    )
                  : Padding(
                      child: VideoCard(videoData: provider.videosData[index - 1]),
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(10))),
            ),
          );
  }
}
