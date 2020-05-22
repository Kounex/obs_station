import 'package:flutter/material.dart';
import 'package:obs_station/shared/basic/translucent_sliver_app_bar.dart';
import 'package:obs_station/views/home/widgets/refresher_app_bar/scroll_refresh_icon.dart';

class RefresherAppBar extends StatelessWidget {
  final double expandedHeight;
  final String imagePath;

  RefresherAppBar({
    this.expandedHeight,
    @required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return TransculentSliverAppBar(
      pinned: true,
      expandedHeight: this.expandedHeight,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: LayoutBuilder(
          builder: (context, constraints) => Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AnimatedOpacity(
                duration: Duration(milliseconds: 250),
                curve: Curves.easeInExpo,
                opacity: constraints.maxHeight -
                            (MediaQuery.of(context).padding.top - 20) <=
                        60
                    ? 1.0
                    : 0.0,
                child: Text(
                  'OBS Station',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              ScrollRefreshIcon(
                expandedBarHeight: this.expandedHeight,
              )
            ],
          ),
        ),
        background: Padding(
            padding: EdgeInsets.only(top: 32.0),
            child: Image.asset(this.imagePath)),
        collapseMode: CollapseMode.parallax,
        stretchModes: [StretchMode.blurBackground, StretchMode.zoomBackground],
      ),
    );
  }
}
