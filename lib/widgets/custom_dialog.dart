
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class UpdateCheckDialog extends StatefulWidget {
  final String updateUrl;
  UpdateCheckDialog({@required this.updateUrl});

  @override
  _UpdateCheckDialogState createState() => _UpdateCheckDialogState();
}

class _UpdateCheckDialogState extends State<UpdateCheckDialog> {
  String downLoadMessage = "Initializing...";
  bool _isDownloading = false;
  var percentage;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Material(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
          child: Container(
              height: 150,
              width: MediaQuery.of(context).size.width - 60,
              color: Colors.white,
              child: _isDownloading == false
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Update Available",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Need to install first to continue",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  _isDownloading = !_isDownloading;
                                });
                                
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Color(0xFFCFD8DC),
                                ),
                                height: 40,
                                width: 100,
                                child: Center(
                                  child: Text("Download",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  SystemNavigator.pop();
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Color(0xFFCFD8DC),
                                ),
                                height: 40,
                                width: 100,
                                child: Center(
                                  child: Text(
                                    "Exit",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  : Column(
                      children: <Widget>[
                        Text("Downloading",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(downLoadMessage,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                        LinearProgressIndicator(
                          value: percentage,
                          backgroundColor: Colors.blueGrey,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        )
                      ],
                    )),
        )
      ],
    );
  }
}
