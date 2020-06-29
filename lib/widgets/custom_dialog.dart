import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/provider/download_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';

// import 'package:permission_handler/permission_handler.dart';
// import 'package:install_plugin/install_plugin.dart';

class UpdateCheckDialog extends StatefulWidget {
  final String updateUrl;
  UpdateCheckDialog({@required this.updateUrl});

  @override
  _UpdateCheckDialogState createState() => _UpdateCheckDialogState();
}

class _UpdateCheckDialogState extends State<UpdateCheckDialog> {
  String downLoadMessage = "Initializing...";
  bool _isDownloading = false;
  bool _isDownloadingFinished = false;
  var percentage;
  var retStatus;
  String _apkFilePath = '/sdcard/download/NewVersion.apk';
  FileDownloaderProvider fileDownloaderProvider;
  @override
  Widget build(BuildContext context) {
    fileDownloaderProvider = Provider.of<FileDownloaderProvider>(context);

    switch (fileDownloaderProvider.downloadStatus) {
      case DownloadStatus.Downloading:
        {
          percentage =
              fileDownloaderProvider.downloadPercentage.toString() + "%";
        }
        break;
      case DownloadStatus.Completed:
        {
          retStatus = "Download Completed";
          _isDownloading = false;
          _isDownloadingFinished = true;
        }
        break;
      case DownloadStatus.NotStarted:
        {
          retStatus = "Click Download Button";
        }
        break;
      case DownloadStatus.Started:
        {
          retStatus = "Download Started";
        }
        break;
    }
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
              child: changeDialog()),
        )
      ],
    );
  }

  changeDialog() {
    if (_isDownloading == false && _isDownloadingFinished == false) {
      return updateDialog();
    } else if (_isDownloading == true && _isDownloadingFinished == false) {
      return downloadProcessDialog();
    } else if (_isDownloading == false && _isDownloadingFinished == true) {
      return downloadCompletedDialog();
    }
  }

  Widget downloadProcessDialog() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Downloading",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 10,
        ),
        Text(fileDownloaderProvider.downloadPercentage.toString() + "\t%",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        SizedBox(
          height: 10,
        ),
        Container(
          width: 80,
          height: 0.5,
          child: LinearProgressIndicator(
            // value: fileDownloaderProvider.downloadPercentage,
            backgroundColor: Colors.blueGrey,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        )
      ],
    );
  }

  Widget downloadCompletedDialog() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Download Completed",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () async {
            OpenFile.open("/sdcard/download/NewVersion.apk");

            // var directory = await getApplicationDocumentsDirectory(); OpenFile.open("${directory.path}/yourNameOfYour.apk");

            // FlutterUpdate.install(
            //     widget.updateUrl, "/sdcard/download/NewVersion.apk");

            // onClickInstallApk();

            // setState(() {
            //   // _isDownloading = !_isDownloading;
            //   // downloadProcess();
            // });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Color(0xFFCFD8DC),
            ),
            height: 40,
            width: 100,
            child: Center(
              child: Text("Install",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center),
            ),
          ),
        ),
      ],
    );
  }

  Widget updateDialog() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("Update Available",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text("Need to install first to continue",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              onTap: () async {
                setState(() {
                  _isDownloading = !_isDownloading;
                  downloadProcess();
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
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  // void onClickInstallApk() async {
  //   if (_apkFilePath.isEmpty) {
  //     print('make sure the apk file is set');
  //     return;
  //   }
  //   Map<PermissionGroup, PermissionStatus> permissions =
  //       await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  //   if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
  //     InstallPlugin.installApk(_apkFilePath, 'com.zaihui.installpluginexample')
  //         .then((result) {
  //       print('install apk $result');
  //     }).catchError((error) {
  //       print('install apk error: $error');
  //     });
  //   } else {
  //     print('Permission request fail!');
  //   }
  // }

  void downloadProcess() {
    fileDownloaderProvider
        .downloadFile(widget.updateUrl, "NewVersion.apk")
        .then((onValue) {});

    switch (fileDownloaderProvider.downloadStatus) {
      case DownloadStatus.Downloading:
        {
          percentage =
              fileDownloaderProvider.downloadPercentage.toString() + "%";
        }
        break;
      case DownloadStatus.Completed:
        {
          retStatus = "Download Completed";
        }
        break;
      case DownloadStatus.NotStarted:
        {
          retStatus = "Click Download Button";
        }
        break;
      case DownloadStatus.Started:
        {
          retStatus = "Download Started";
        }
        break;
    }
  }
}
