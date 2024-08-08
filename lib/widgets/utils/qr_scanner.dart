// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:steady_solutions/controllers/wo_controller.dart';
import 'package:steady_solutions/screens/work_orders/KPI.dart';
import 'package:steady_solutions/screens/work_orders/new_asset_wo_form_screen.dart';
import 'package:steady_solutions/screens/work_orders/new_service_wo_form_screen.dart';
import 'package:steady_solutions/widgets/utils/background.dart';
import 'package:url_launcher/url_launcher.dart';
class QRScannerView extends StatefulWidget {
   QRScannerView({Key? key,  this.goToKPIScreen =true}) : super(key: key);
  static List <String> previousURLs = [];
   bool goToKPIScreen;
  @override
  State<QRScannerView> createState() => _QRScannerViewState();
}
class _QRScannerViewState extends State<QRScannerView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final WorkOrdersController _workOrdersController= Get.find<WorkOrdersController>();
  Barcode? result;
  QRViewController? controller;
 TextEditingController _textController = TextEditingController();
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  bool _called = false;
  @override
  void reassemble() {
    log("reassemble");
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void initState() {
  QRScannerView.previousURLs = [];
  log("cleared previous urls");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    return Background(
      child: Scaffold(
        body: QRView(
          overlay: QrScannerOverlayShape(
            borderColor: const Color.fromARGB(255, 54, 60, 244),
            borderRadius: 10,
            borderWidth: 10,
            cutOutSize: 300,
          ),
          
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,

        )
      ), 
      

      
    );
    
  }

  final StreamController<Barcode> _scannedDataController =
      StreamController<Barcode>(sync: true);
  Stream<Barcode> get scannedDataStream => _scannedDataController.stream;

  void _onQRViewCreated(QRViewController controller) {
    _scannedDataController.stream.listen((scanData) {
      _scannedDataController.add(scanData);
    });
    this.controller = controller;
     log("_onQRViewCreated");
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      
      if(scanData.code != null)
      {
         log("scan data nn");
        if(widget.goToKPIScreen){
              log("go to kpi");
          if(QRScannerView.previousURLs.contains(scanData.code!)){
            log ("already scanned");
          return;}
          log("scanData.code : ${scanData.code}");
          QRScannerView.previousURLs.add(scanData.code!);
      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KPIWebsite(url: scanData.code!),
                          ),
                        );
                        return;}
      }
      log("is called  ${_called}");
       // Call once because QR scanner keeps scanning                
            if (!_called) {
      _called = true;  
            log("QR SCANNED asset [${scanData.code}] and going back");
             log(scanData.code!);
            _workOrdersController.getAssetItemById(assetIdOrLink: scanData.code!);
            Navigator.of(context).pop();
          }
                
            return;
           // if(_workOrdersController.assetItem.value.id != null)   
            // WidgetsBinding.instance.addPostFrameCallback((_) { 
           // Navigator.of(context).pop();
            // },
       //  );

    

     // launchUrl(Uri.parse(scanData.code!));
      });
    
   
 
  }
  

  Function? callOnce(Function function) {


   wrapper() {
    if (!_called) {
      _called = true;
      function();
      return function; // You can optionally return the function here
    } else {
      return null; // Explicitly return null if not called
    }
  }

  return wrapper;
}
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

}