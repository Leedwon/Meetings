import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meetings/assets/images.dart';
import 'package:meetings/icons/meetings_icons.dart';
import 'package:meetings/models/services/place_api_service.dart';
import 'package:meetings/models/services/rating_api_service.dart';
import 'package:meetings/widgets/cards_scroll.dart';
import 'package:meetings/widgets/loading.dart';
import 'package:meetings/widgets/place_rating.dart';
import 'package:meetings/widgets/spacing_widget.dart';

import '../../post_location_service.dart';
import 'home_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class _HomeScreenState extends State<HomeScreen> {
  PostLocationService postLocationService;
  var currentPage = images.length - 1.0;
  HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    Client client = Client();
    PostLocationService.init();
    _homeBloc = HomeBloc(PlaceApiService(client), RatingApiService(client));
    _homeBloc.subscribeToSearchQuery();
  }

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: images.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Meetings"),
        actions: <Widget>[
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                "logout",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              )),
            ),
            onTap: () {
              _homeBloc.resetUserId();
              Navigator.pushReplacementNamed(context, "/login");
            },
          )
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Container(
                  child: TextField(
                onChanged: _homeBloc.changeSearchQuery,
                decoration: InputDecoration(
                    hintText: "Search for meeting places",
                    suffixIcon: Icon(Meetings.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              )),
              Expanded(
                child: StreamBuilder<List<PlaceRatingItem>>(
                    stream: _homeBloc.places,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return LoadingWidget();
                      } else if (snapshot.data.isEmpty) {
                        return SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "We reccomend :",
                                  style: TextStyle(
                                      fontSize: 24.0, color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                              Stack(
                                children: <Widget>[
                                  CardScrollWidget(images, title, currentPage,
                                      widgetAspectRatio, cardAspectRatio),
                                  Positioned.fill(
                                    child: PageView.builder(
                                      itemCount: images.length,
                                      controller: controller,
                                      reverse: true,
                                      itemBuilder: (context, index) {
                                        return Container();
                                      },
                                    ),
                                  )
                                ],
                              ),
                              InkWell(onTap: () => _homeBloc.getAllMeetings(),
                              child: Text("see all", style: TextStyle(color: Colors.blue, fontSize: 24.0),))
                            ],
                          ),
                        );
                      } else {
                        List<PlaceRatingItem> items = snapshot.data;
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SpacingWidget(
                                    bottomSpacing: 8.0,
                                    child: PlaceRatingWidget(
                                      items[index],
                                      (item) => Navigator.pushNamed(context, '/placeDetails', arguments: [item.placeId]),
                                    ));
                              }),
                        );
                      }
                    }),
              )
            ],
          )),
    );
  }
}
