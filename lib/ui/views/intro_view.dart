import 'package:flutter/material.dart';
import 'package:meenforquei/ui/widgets/walk_through.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/viewmodel/startup_view_model.dart';
import 'package:stacked/stacked.dart';

class IntroView extends StatefulWidget {
  @override
  _IntroViewState createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  final PageController controller = new PageController();
  int currentPage = 0;
  bool lastPage = false;

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
      if (currentPage == 3) {
        lastPage = true;
      } else {
        lastPage = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return ViewModelBuilder<StartUpViewModel>.reactive(
        viewModelBuilder: () => StartUpViewModel(),
        builder: (context, model, child) => Container(
          color: Color(0xFFEEEEEE),
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                flex: 3,
                child: PageView(
                  children: <Widget>[
                    WalkThrough(
                      title: MEString.wt1,
                      content: MEString.wc1,
                      imageIcon: Icons.calendar_today,
                    ),
                    WalkThrough(
                      title: MEString.wt2,
                      content: MEString.wc2,
                      imageIcon: Icons.chrome_reader_mode,
                    ),
                    WalkThrough(
                      title: MEString.wt3,
                      content: MEString.wc3,
                      imageIcon: Icons.check_box,
                    ),
                    WalkThrough(
                      title: MEString.wt4,
                      content: MEString.wc4,
                      imageIcon: Icons.perm_identity,
                    ),
                    WalkThrough(
                      title: MEString.wt5,
                      content: MEString.wc5,
                      imageIcon: Icons.attach_money,
                    ),
                  ],
                  controller: controller,
                  onPageChanged: _onPageChanged,
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Text(lastPage ? "" : MEString.skip,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      onPressed: () =>
                      lastPage ? null : model.goToHome(),
                    ),
                    FlatButton(
                      child: Text(lastPage ? MEString.gotIt : MEString.next,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      onPressed: () => lastPage
                          ? model.goToHome()
                          : controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }
}
