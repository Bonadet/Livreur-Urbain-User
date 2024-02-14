import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translations/translation.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';

class OutStationDetails extends StatefulWidget {
  final dynamic requestId;
  final dynamic i;
  const OutStationDetails({super.key, this.requestId, this.i});

  @override
  State<OutStationDetails> createState() => _OutStationDetailsState();
}

class _OutStationDetailsState extends State<OutStationDetails> {
  bool _isLoading = false;
  TextEditingController updateAmount = TextEditingController();
  List driverBck = [];

  navigate() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Material(
      child: StreamBuilder<Object>(
          stream: FirebaseDatabase.instance
              .ref()
              .child('bid-meta/${widget.requestId}')
              .onValue
              .asBroadcastStream(),
          builder: (context, AsyncSnapshot event) {
            List driverList = [];
            Map rideList = {};
            // rideList = event.data!.snapshot;
            if (event.data != null) {
              DataSnapshot snapshots = event.data!.snapshot;
              if (snapshots.value != null) {
                rideList = jsonDecode(jsonEncode(snapshots.value));
                if (rideList['drivers'] != null) {
                  Map driver = rideList['drivers'];
                  driver.forEach((key, value) {
                    if (driver[key]['is_rejected'] == 'none') {
                      driverList.add(value);
                    }
                  });

                  if (driverList.isNotEmpty) {
                    if (driverBck.isNotEmpty &&
                        driverList[0]['user_id'] != driverBck[0]['user_id']) {
                      driverBck = driverList;
                    } else if (driverBck.isEmpty) {
                      driverBck = driverList;
                    }
                  } else {
                    driverBck = driverList;
                  }
                } else {
                  driverBck = driverList;
                }
              }
            }

            return Stack(
              children: [
                Container(
                  width: media.width * 1,
                  height: media.height * 1,
                  color: page,
                  padding: EdgeInsets.all(media.width * 0.05),
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).padding.top),
                      Stack(
                        children: [
                          Container(
                            padding:
                                EdgeInsets.only(bottom: media.width * 0.05),
                            width: media.width * 1,
                            alignment: Alignment.center,
                            child: MyText(
                              text: languages[choosenLanguage]
                                  ['text_bidded_drivers'],
                              size: media.width * twenty,
                              fontweight: FontWeight.w600,
                            ),
                          ),
                          Positioned(
                              child: InkWell(
                                  onTap: () async {
                                    Navigator.pop(context);
                                    getHistory('is_later=1');
                                  },
                                  child: Icon(Icons.arrow_back_ios,
                                      color: textColor)))
                        ],
                      ),
                      Expanded(
                        child: (driverList.isNotEmpty)
                            ? SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        MyText(
                                          text: languages[choosenLanguage]
                                              ['text_my_bid_amount'],
                                          color: textColor,
                                          fontweight: FontWeight.w600,
                                          size: media.width * fourteen,
                                        ),
                                        MyText(
                                          text: rideList['currency'] +
                                              rideList['price'].toString(),
                                          color: textColor,
                                          fontweight: FontWeight.w600,
                                          size: media.width * fourteen,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: media.width * 0.03,
                                    ),
                                    Column(
                                        children: driverList
                                            .asMap()
                                            .map((key, value) {
                                              return MapEntry(
                                                  key,
                                                  ValueListenableBuilder(
                                                      valueListenable:
                                                          valueNotifierTimer
                                                              .value,
                                                      builder: (context, value,
                                                          child) {
                                                        if (driverList
                                                            .isNotEmpty) {
                                                          audioPlayers.play(
                                                              AssetSource(
                                                                  audio));
                                                        }
                                                        return Container(
                                                          margin:
                                                              EdgeInsets.all(
                                                                  media.width *
                                                                      0.025),
                                                          decoration:
                                                              BoxDecoration(
                                                                  // borderRadius: BorderRadius.circular(10),
                                                                  color: page,
                                                                  boxShadow: [
                                                                BoxShadow(
                                                                    blurRadius:
                                                                        2,
                                                                    spreadRadius:
                                                                        2,
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.2))
                                                              ]),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .all(media
                                                                            .width *
                                                                        0.05),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              media.width * 0.1,
                                                                          height:
                                                                              media.width * 0.1,
                                                                          decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              image: DecorationImage(image: NetworkImage(driverList[key]['driver_img']), fit: BoxFit.cover)),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              media.width * 0.05,
                                                                        ),
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: media.width * 0.4,
                                                                              child: MyText(
                                                                                text: driverList[key]['driver_name'],
                                                                                size: media.width * fourteen,
                                                                                fontweight: FontWeight.w600,
                                                                                maxLines: 1,
                                                                                textAlign: TextAlign.left,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: media.width * 0.025,
                                                                            ),
                                                                            SizedBox(
                                                                                width: media.width * 0.4,
                                                                                child: MyText(
                                                                                  text: '${driverList[key]['vehicle_make']} ${driverList[key]['vehicle_model']}',
                                                                                  size: media.width * fourteen,
                                                                                  color: textColor,
                                                                                  fontweight: FontWeight.w600,
                                                                                  textAlign: TextAlign.left,
                                                                                  maxLines: 1,
                                                                                )),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              media.width * 0.05,
                                                                        ),
                                                                        SizedBox(
                                                                            width: media.width *
                                                                                0.15,
                                                                            child:
                                                                                MyText(
                                                                              text: rideList['currency'] + driverList[key]['price'],
                                                                              size: media.width * fourteen,
                                                                              fontweight: FontWeight.w600,
                                                                              textAlign: TextAlign.center,
                                                                              maxLines: 1,
                                                                            ))
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: media
                                                                              .width *
                                                                          0.05,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Button(
                                                                          onTap:
                                                                              () async {
                                                                            setState(() {
                                                                              _isLoading = true;
                                                                            });
                                                                            var val =
                                                                                await acceptRequest(jsonEncode({
                                                                              'driver_id': driverList[key]['driver_id'],
                                                                              'request_id': widget.requestId,
                                                                              'accepted_ride_fare': driverList[key]['price'].toString(),
                                                                              'offerred_ride_fare': rideList['price'],
                                                                            }));
                                                                            if (val ==
                                                                                'success') {
                                                                              await FirebaseDatabase.instance.ref().child('bid-meta/${widget.requestId}').remove();
                                                                              var res = await getHistory('is_later=1');
                                                                              if (res == 'success') {
                                                                                setState(() {
                                                                                  _isLoading = false;
                                                                                });
                                                                                navigate();
                                                                              }
                                                                              // ignore: use_build_context_synchronously
                                                                            }
                                                                          },
                                                                          text: languages[choosenLanguage]
                                                                              [
                                                                              'text_accept'],
                                                                          width:
                                                                              media.width * 0.35,
                                                                        ),
                                                                        // SizedBox(height: media.width*0.025,),
                                                                        Button(
                                                                          onTap:
                                                                              () async {
                                                                            setState(() {
                                                                              _isLoading = true;
                                                                            });
                                                                            await FirebaseDatabase.instance.ref().child('bid-meta/${widget.requestId}/drivers/driver_${driverList[key]["driver_id"]}').update({
                                                                              "is_rejected": 'by_user'
                                                                            });
                                                                            setState(() {
                                                                              _isLoading = false;
                                                                            });
                                                                          },
                                                                          text: languages[choosenLanguage]
                                                                              [
                                                                              'text_decline'],
                                                                          width:
                                                                              media.width * 0.35,
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }));
                                            })
                                            .values
                                            .toList()),
                                  ],
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: media.width * 0.05,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: media.width * 0.7,
                                    width: media.width * 0.7,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/noorder.png'),
                                            fit: BoxFit.contain)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: media.width * 0.07,
                                        ),
                                        SizedBox(
                                          width: media.width * 0.2,
                                          child: MyText(
                                              text: languages[choosenLanguage]
                                                  ['text_noorder'],
                                              textAlign: TextAlign.center,
                                              fontweight: FontWeight.w800,
                                              size: media.width * sixteen),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
                //loader
                (_isLoading == true)
                    ? const Positioned(top: 0, child: Loading())
                    : Container(),
              ],
            );
          }),
    );
  }
}
