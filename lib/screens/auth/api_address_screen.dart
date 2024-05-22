import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:steady_solutions/app_config/style.dart';
import 'package:steady_solutions/controllers/api_adderss_controller.dart';
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:steady_solutions/screens/auth/login_screen.dart';
import 'package:steady_solutions/widgets/misc/custom_dialog.dart';
import 'package:steady_solutions/widgets/utils/background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
class ApiAddressScreen extends StatefulWidget {
  const ApiAddressScreen({super.key});

  @override
  _ApiAddressScreenState createState() => _ApiAddressScreenState();
}

class _ApiAddressScreenState extends State<ApiAddressScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ApiAddressController _apiController = Get.find<ApiAddressController>();

  StreamSubscription<bool>? lisenter;
  Rx<bool> isLoading = false.obs;

  @override
  initState() {
    if (mounted) {
      lisenter = isLoading.listen((value) {
        if (value) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
        }
      });
    }
    super.initState();
  }

  Future<void> _saveApiAddress() async {
   
    if (_formKey.currentState!.validate()) {
      print("starting");

      ////////////   TESTING PURPOSES  ////////////
     
      // await Future.delayed(const Duration(seconds: 3), (){
      //  _authController.saveApiAddres("oms-livedemo.com");
      // });
      ////////////   PRODUCTION CODE  ////////////
      await _apiController.saveApiAddres (_controller.text,context);
  
    }
  
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Background(
        child: SingleChildScrollView(
            child: Column(
      children: <Widget>[
        _logo(context),
        SizedBox(
          height: 100.h,
        ),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 10,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                          style: inputTextStyle,
                          keyboardType: TextInputType.url,
                          autofocus: true,
                          controller: _controller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .please_enter_url;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 23, 23,
                                      23)), // Change this color to your preference
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .black), // Change this color to your preference
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            prefixIcon: const Icon(Icons.link),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            labelText:
                                AppLocalizations.of(context).portalAddress,
                            labelStyle: inputHintStyle,
                          )),
                    ),
                    SizedBox(height: 60.h),
                    ElevatedButton(
                      style: kPrimeryBtnStyle(context),
                      onPressed: _saveApiAddress,
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ],
    )));
  }
}

Widget _logo(BuildContext context) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/logos/steadyOMS_Colored.png",
            width: MediaQuery.of(context).size.width / 1.4,
          ),
        ],
      ),
    ],
  );
}