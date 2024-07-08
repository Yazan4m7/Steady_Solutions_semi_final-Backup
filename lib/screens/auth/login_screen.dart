import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:steady_solutions/app_config/style.dart';
import 'package:steady_solutions/controllers/api_adderss_controller.dart';
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:steady_solutions/screens/auth/api_address_screen.dart';
import 'package:steady_solutions/widgets/misc/show_up_widget.dart';
import 'package:steady_solutions/widgets/utils/background.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  //static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = Get.find<AuthController>();
  final ApiAddressController _apiController = Get.find<ApiAddressController>();
  static TextEditingController _emailTFController = TextEditingController();
  static TextEditingController _passwordTFController = TextEditingController();
  static String? role = "0";

  final TextEditingController _dropdownController = TextEditingController();
  static final GlobalKey<State> _dropDownKey = GlobalKey<State>();
  @override
  Widget build(BuildContext context) {

     Future.delayed(Duration.zero, () async {
     await   _authController.getEquipIds();
     if (_authController.isGeneral.value &&   !_authController.isMedical.value)
       role= "1";
    else if (!_authController.isGeneral.value &&   _authController.isMedical.value)
     role=="2";
     });
    
   
    
    
   
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leadingWidth: double.infinity,
            iconTheme:
                const IconThemeData(color: Color.fromARGB(255, 38, 49, 57)),
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.language),
                  onSelected: (String result) {
                    storageBox.write('languageCode', result);
                    Get.updateLocale(Locale(result));
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'en',
                      child: Text(AppLocalizations.of(context).english),
                    ),
                    PopupMenuItem<String>(
                      value: 'ar',
                      child: Text(AppLocalizations.of(context).arabic),
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      storageBox.erase();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const ApiAddressScreen()), (route) => false);
                    },
                    icon: const Icon(Icons.link_off))
              ],
            ),
            //  title: const Text("LOGIN"),
            
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            centerTitle: true),
        body: Center(
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              _logo(),
              SizedBox(height: 60.h),
              ShowUp(
                  delay: 2,
                  child: Text(
                    AppLocalizations.of(context).loginWelcomeMsg,
                    style: TextStyle(fontSize: 50.w),
                  )),
              ShowUp(
                delay: 2,
                child: Text(
                  AppLocalizations.of(context).enterCredentials,
                  style: TextStyle(fontSize: 40.w),
                ),
              ),
              SizedBox(
                height: 60.h,
              ),
              ShowUp(
                  delay: 2,
                  child: Row(
                    children: [
                      const Spacer(),
                      Expanded(
                        flex: 10,
                        child: _loginForm(context),
                      ),
                      const Spacer(),
                    ],
                  )),
            ],
          )),
        ),
      ),
    );
  }

  Widget _logo() {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 6,
              child: Image.asset(
                  "assets/images/logos/new_blue_logo_transparent_bg-09.png"),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    // print("returning form");
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Form(
        // key: _formKey,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor3BrightBlue,
              style: inputTextStyle,
              controller: _emailTFController,
              decoration: kTextFieldDecoration.copyWith(
                  labelText: AppLocalizations.of(context).email,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Color(0xFF4d7fa2),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                controller: _passwordTFController,
                style: inputTextStyle,
                textInputAction: TextInputAction.done,
                obscureText: true,
                cursorColor: kPrimaryColor3BrightBlue,
                decoration: kTextFieldDecoration.copyWith(
                    labelText: AppLocalizations.of(context).password,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF4d7fa2),
                    )),
              ),
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: DropdownButtonFormField<String>(
                //  hint: Text("Select Type"),
                    value: _authController.isGeneral.value ? "General" : "Medical",
                    key: LoginScreen._dropDownKey,
                    dropdownColor: Colors.white,
                    style: inputTextStyle,
                    decoration: kTextFieldDecoration.copyWith(
                        labelText: AppLocalizations.of(context).select_om_type,
                        prefixIcon: const Icon(Icons.arrow_drop_down,
                            color: Colors.black)),
                    items: [
                      
                      DropdownMenuItem<String>(
                        value: AppLocalizations.of(context).medical,
                        child: Obx(
                          () => Text(AppLocalizations.of(context).medical,
                              style: _authController.isMedical.value == true
                                  ? dropDownTextStyle
                                  : dropDownTextStyle.copyWith(
                                      color:
                                          Color.fromARGB(255, 151, 151, 151))),
                        ),
                        onTap: () {
                           // print("onTap 2  $role");
                          role = '2';
                        },
                        enabled: _authController.isMedical.value,
                      ),
                      DropdownMenuItem<String>(
                        value: AppLocalizations.of(context).general,
                        child: Obx(
                          () => Text(AppLocalizations.of(context).general,
                              style: _authController.isGeneral.value == true
                                  ? dropDownTextStyle
                                  : dropDownTextStyle.copyWith(
                                      color: Colors.grey)),
                        ),
                        enabled: _authController.isGeneral.value,
                        onTap: () {
                          // print("onTap 1  $role");
                          role = '1';
                        },
                      )
                    ],
                    onChanged: (String? newValue) {
                      // print("onChanged");
                    },
                    onSaved: (String? newValue) {
                      // print("onSaved");
                    },
                   // value: _selectedRole
                    ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              style: kPrimeryBtnStyle(context),
              onPressed: () async {
                // print("sending role to controller: $role");
                // Error dialog box shows up by auth controller
                await _authController.login(_emailTFController.text,
                    _passwordTFController.text, role!, context);
                //    }
              },
              child: Text(
                AppLocalizations.of(context).login,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
