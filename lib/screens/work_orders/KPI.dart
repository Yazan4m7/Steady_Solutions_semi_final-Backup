import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:simple_animated_icon/simple_animated_icon.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:steady_solutions/app_config/style.dart';
import 'package:steady_solutions/screens/work_orders/new_asset_wo_form_screen.dart';
import 'package:steady_solutions/widgets/utils/qr_scanner.dart';

class KPIWebsite extends StatefulWidget {
  final String url;
  KPIWebsite({Key? key, required this.url}) : super(key: key);
  @override
  State<KPIWebsite> createState() => _KPIWebsiteState();
}

class _KPIWebsiteState extends State<KPIWebsite> with AnimationMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  Rx<double> _progress = 0.00.obs;
  late InAppWebViewController inAppWebViewController;
  @override
  void initState() {
    super.initState();
    _animationController = createController();
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut, // Apply the curve to the CurvedAnimation
    );
   
  log("cleared previous urls");
  }

  @override
  Widget build(BuildContext context) {
    // print("KPI ADDRESS : ${widget.url}");
    _animationController.play();
    log("widget.url : ${widget.url}");
    return WillPopScope(
      onWillPop: () async {
          QRScannerView.previousURLs = [];
        var isLastPage = await inAppWebViewController.canGoBack();

        if (isLastPage) {
          inAppWebViewController.goBack();
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(
                    url: WebUri.uri(
                  Uri.parse(widget.url),
                )),
                onWebViewCreated: (InAppWebViewController controller) {
                  inAppWebViewController = controller;
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setState(
                    () {
                      _progress.value = progress / 100;
                      // print(_progress.value);
                    },
                  );
                },
              ),
              _progress < 1
                  ? Container(
                      child: Column(
                        children: [
                          LinearProgressIndicator(
                            minHeight:
                                MediaQuery.of(context).size.height * 0.01,
                            color: kPrimeryColor2NavyDark,
                            value: _progress.value,
                          ),
                          Text(_progress.value.toString())
                        ],
                      ),
                    )
                  : SizedBox(
                     
                    ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.05,
                left: Get.locale?.languageCode == "en"
                    ? MediaQuery.of(context).size.width * 0.05
                    : null,
                right: Get.locale?.languageCode == "en"
                    ? null
                    : MediaQuery.of(context).size.width * 0.05,
                child: Obx(()=>
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: _progress.value < 0.75
                        ? ElevatedButton(
                      style: kPrimeryBtnNoPaddingStyle(context).copyWith(backgroundColor:  WidgetStateProperty .all<Color>(Colors.grey)),
                          onPressed: (){return null;},
                          child:  Text('Loading KPI..',style: Theme.of(context).textTheme.displayLarge?.copyWith(),),
                        )
                    
                        : ElevatedButton(
                      style: kPrimeryBtnStyle(context),
                      onPressed: (){

                          // Parse the URL into a Uri object
                          Uri uri = Uri.parse(widget.url);

                          // Split the query string into a map of key-value pairs
                          Map<String, String> params = uri.queryParameters;

                          // Get the value associated with the "CNo" key
                          String controlNumber = params['CNo']!; 
                          log("CNo read from QR : $controlNumber");

                        
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewEquipWorkOrderFrom(controlNumber: controlNumber,),
                          ),
                        );},
                      child:  Text('Create Work Order'),
                    ),
                ),
              ),
              // animationDuration: Duration(milliseconds: 500),
          )],
          ),
        ),
      ),
    );
  }
}
