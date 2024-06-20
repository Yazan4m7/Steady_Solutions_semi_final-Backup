import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:steady_solutions/app_config/app_theme.dart';
import 'package:steady_solutions/app_config/style.dart';
import 'package:steady_solutions/controllers/api_adderss_controller.dart';
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:glossy/glossy.dart';

import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:steady_solutions/widgets/utils/background.dart';
import 'package:steady_solutions/widgets/misc/show_up_widget.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static final GlobalKey<State> _dropDownKey = GlobalKey();
  
  static TextEditingController _emailTFController = TextEditingController();
  static TextEditingController _passwordTFController = TextEditingController();
  static String? role;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = Get.find<AuthController>();

  final ApiAddressController _apiController = Get.find<ApiAddressController>();

  String?  _selectedRole;
  String?  role;
  final TextEditingController _dropdownController = TextEditingController();

  @override
  void initState() {
   
   
   _authController.getEquipIds();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    
   _selectedRole = (_authController.isGeneral.value &&
                            !_authController.isMedical.value)
                        ? AppLocalizations.of(context).general
                        : (!_authController.isMedical.value &&
                                _authController.isMedical.value)
                            ? AppLocalizations.of(context).medical
                            : AppLocalizations.of(context).medical;
   _dropdownController.text = _selectedRole!;
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/backgrounds/operations_blurry1.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
        //backgroundColor: Colors.white,
        appBar: AppBar(
            iconTheme:
                const IconThemeData(color: Color.fromARGB(255, 38, 49, 57)),
            leading: PopupMenuButton<String>(
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
                    style: TextStyle(fontSize: 50.w, fontFamily: 'ProductSans-Light',fontWeight: FontWeight.w500,color: Colors.white),
                  )),
              ShowUp(
                delay: 2,
                child: Text(
                  AppLocalizations.of(context).enterCredentials,
                  style: TextStyle(fontSize: 40.w, fontFamily: 'ProductSans-Light',fontWeight: FontWeight.w300,color: Colors.white),
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
       )) );
  }

  Widget _logo() {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 6,
              child: Image.asset("assets/images/logos/WhiteOMS.png"),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    print("FONT : " + 20.sp.toString());

    print("returning form");
    return GlossyContainer(
       width: MediaQuery.of(context).size.width/1.1,
                    height: MediaQuery.of(context).size.width/1.05,
     // color: Colors.white.withOpacity(0.3),
     // decoration: BoxDecoration(
      //    color: Colors.white.withOpacity(0.3),
      //     borderRadius: BorderRadius.circular(20),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.5),
          //     spreadRadius: 1,
          //     blurRadius: 3,
          //     offset: const Offset(0, 3), // changes position of shadow
          //   ),
          // ]
      //    ),
      //padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: LoginScreen._formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                cursorColor: kPrimaryColor3BrightBlue,
                style: inputTextStyle,
                validator: (value) {
                  if (value == null) {
                    return 'Please enter an email address';
                  }
                  if (!isValidEmail(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                controller: LoginScreen._emailTFController,
                decoration: kTextFieldDecoration.copyWith(
                    labelText: AppLocalizations.of(context).email,
                    prefixIcon:  Icon(
                      Icons.email_outlined,
                      color:Colors.white,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: TextFormField(
                  controller: LoginScreen._passwordTFController,
                  style: inputTextStyle,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  cursorColor: kPrimaryColor3BrightBlue,
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter password';
                    } else if (value == "") {
                      return 'Please enter password';
                    }
                    return null;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    labelText: AppLocalizations.of(context).password,
                    prefixIcon:  Icon(
                      Icons.lock_outline,
                      color:Colors.white,
                    ),
                  ),
                ),
              ),
              Obx(
                ()=> Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: DropdownButtonFormField<String>(
                      key: LoginScreen._dropDownKey,
                      dropdownColor: Colors.white,
                      style: inputTextStyle,
                      decoration: kTextFieldDecoration.copyWith(
                          labelText: AppLocalizations.of(context).select_om_type,
                          prefixIcon: const Icon(Icons.arrow_drop_down,
                              color: Colors.white)),
                      items: [
                        DropdownMenuItem<String>(
                          value: AppLocalizations.of(context).medical,
                          child:Obx(()=>
                             Text(AppLocalizations.of(context).medical,
                                style: _authController.isMedical.value == true
                                    ? dropDownTextStyle
                                    :dropDownTextStyle.copyWith(color: Colors.white) ),
                          ),
                          enabled: _authController.isMedical.value,
                        ),
                        DropdownMenuItem<String>(
                          value: AppLocalizations.of(context).general,
                          child: Obx(()=> Text(AppLocalizations.of(context).general,
                                style:  _authController.isGeneral.value == true
                                    ? dropDownTextStyle
                                    :dropDownTextStyle.copyWith(color: Colors.grey) ),
                          ),
                          enabled: _authController.isGeneral.value,
                        )
                      ],
                      onChanged: (String? newValue) {
                        print("onChanged");
                        _selectedRole = newValue;
                      },
                      onSaved: (String? newValue) {
                        print("onSaved");
                        _selectedRole = newValue;
                      },
                      value: _selectedRole),
                ),
              ),
              const SizedBox(height: defaultPadding),
              ElevatedButton(
                style: kPrimeryBtnStyle(context),
                onPressed: () async {
                  LoginScreen._formKey.currentState!.save();
                  if (LoginScreen._formKey.currentState!.validate()) {
                    if (_selectedRole == AppLocalizations.of(context).medical) {
                      role = '2';
                    } else {
                      role = '1';
                    }
                    print("sending role to controller: ${_selectedRole}");
                    // Error dialog box shows up by auth controller
                    await _authController.login(LoginScreen._emailTFController.text,
                        LoginScreen._passwordTFController.text, role ?? "", context);
                    //    }
                  }
                },
                child: Text(
                  AppLocalizations.of(context).login,style: TextStyle(fontSize: 40.w, fontFamily: 'ProductSans-Light',fontWeight: FontWeight.w500,color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String value) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(value);
  }
}
