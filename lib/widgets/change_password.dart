import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweetalertv2/sweetalertv2.dart';

import '../providers/auth.dart';

class ChangePassword extends StatefulWidget {
  final loginId;
  final Function decoration;
  final Function togglePwdChange;
  ChangePassword(this.loginId, this.decoration, this.togglePwdChange);
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var _isLoading = false;
  TextEditingController _cnfPwdController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  Future<void> _changePassword() async {
    print("_cnfPwdController.text => ${_cnfPwdController.text}");
    print("_pwdController.text => ${_pwdController.text}");
    if (_cnfPwdController.text == "" || _pwdController.text == "") {
      SweetAlertV2.show(context,
          title: "Error",
          subtitle: "Please enter password and confirm password.",
          style: SweetAlertV2Style.error);
      return;
    }
    if (_cnfPwdController.text != _pwdController.text) {
      SweetAlertV2.show(context,
          title: "Error",
          subtitle: "Password and confirm password doesn't match.",
          style: SweetAlertV2Style.error);
      return;
    }
    try {
      setState(() {
        _isLoading = true;
      });
      final respo = await Provider.of<Auth>(context, listen: false)
          .changePassword(widget.loginId, _pwdController.text);

      setState(() {
        _isLoading = false;
      });
      print("respo ==> $respo");

      if (respo['Result'] == "OK") {
        _cnfPwdController.clear();
        _cnfPwdController.clear();
        widget.togglePwdChange();
        SweetAlertV2.show(context,
            title: "Updated!",
            subtitle: respo['Msg'],
            style: SweetAlertV2Style.success);
      } else {
        SweetAlertV2.show(context,
            title: "Error",
            subtitle: respo['Msg'],
            style: SweetAlertV2Style.error);
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print("Error--> $error");
      if (error != null) {
        SweetAlertV2.show(context,
            title: "Error",
            subtitle: "Error while changing password.",
            style: SweetAlertV2Style.error);
      }
    }
  }

  @override
  void dispose() {
    _cnfPwdController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                Container(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFormField(
                        initialValue: widget.loginId,
                        readOnly: true,
                        decoration: widget.decoration(
                            icon: Icons.person, hintText: "Login Id"),
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: _pwdController,
                        decoration: widget.decoration(
                            icon: Icons.lock, hintText: "New Password"),
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: _cnfPwdController,
                        decoration: widget.decoration(
                            icon: Icons.lock, hintText: "Confirm Password"),
                      ),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          elevation: 12,
                          primary: Colors.red, // background
                          onPrimary: Colors.white,
                          textStyle: TextStyle(fontSize: 18)),
                      label: Text('Cancel'),
                      icon: Icon(Icons.highlight_remove_outlined),
                      onPressed: widget.togglePwdChange,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          elevation: 12,
                          primary: Colors.green, // background
                          onPrimary: Colors.white,
                          textStyle: TextStyle(fontSize: 18)),
                      label: Text("Submit"),
                      icon: Icon(Icons.check_circle_outline),
                      onPressed: _changePassword,
                    ),
                  ],
                )
              ],
            ),
          );
  }
}
