import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweetalertv2/sweetalertv2.dart';

import '../providers/registered_users.dart';
import '../models/registered_user.dart';

class RagistrationDetailsScreen extends StatelessWidget {
  static const routeName = '/registration-detail-screen';

  String _getStatus(String stat) {
    switch (stat) {
      case "NA":
        return "Pending";
      case "A":
        return "Approved";
      case "R":
        return "Rejected";
      default:
        return "Pending";
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> updateStatus(String stat, int userid) async {
      try {
        final resp = await Provider.of<RegisteredUsers>(context, listen: false)
            .updateUserStatus(stat, userid);
        if (resp['Result'] == "OK") {
          SweetAlertV2.show(context,
              title: "Updated!",
              subtitle: resp['Msg'],
              style: SweetAlertV2Style.success);
        } else {
          SweetAlertV2.show(context,
              title: "Error",
              subtitle: resp['Msg'],
              style: SweetAlertV2Style.error);
        }
      } catch (error) {
        print("Error => $error");
        SweetAlertV2.show(context,
            title: "Error",
            subtitle: "Error while updating the user",
            style: SweetAlertV2Style.error);
      }
    }

    final userId =
        ModalRoute.of(context).settings.arguments as int; // is the id!

    Widget _heading(String heading, RegisteredUser userData) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.80, //80% of width,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            heading,
            style: TextStyle(fontSize: 16),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15, // 30 padding
              vertical: 5, // 5 top and bottom
            ),
            decoration: BoxDecoration(
              color: _getStatus(userData.stat) == 'Approved'
                  ? Colors.green.shade400
                  : _getStatus(userData.stat) == 'Pending'
                      ? Colors.yellow.shade400
                      : Colors.red.shade400,
              borderRadius: BorderRadius.all(
                Radius.circular(22),
              ),
            ),
            child: Text(
              _getStatus(userData.stat),
              style: TextStyle(color: Colors.black),
            ),
          ),
        ]),
      );
    }

    Widget _detailsCard(RegisteredUser userData) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 4,
          child: Column(
            children: [
              //row for each deatails
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Sevarth Number: ${userData.uSevarthNo}"),
              ),
              Divider(
                height: 0.6,
                color: Colors.black87,
              ),

              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text("Registered Date: ${userData.regon}"),
              ),

              Divider(
                height: 0.6,
                color: Colors.black87,
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text("Mobile No.: ${userData.uMobile}"),
              ),
              Divider(
                height: 0.6,
                color: Colors.black87,
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text("Email Id: ${userData.uEmail}"),
              ),
              Divider(
                height: 0.6,
                color: Colors.black87,
              ),
              ListTile(
                leading: Icon(Icons.badge),
                title: Text("Designation: ${userData.uDesgNm}"),
              ),
              Divider(
                height: 0.6,
                color: Colors.black87,
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text("Division: ${userData.uOfcNm}"),
              ),
              Divider(
                height: 0.6,
                color: Colors.black87,
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Reporting Officer: ${userData.uReportUNm}"),
              ),

              Divider(
                height: 0.6,
                color: Colors.black87,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        title: Text('Registration Details'),
      ),
      body: FutureBuilder(
        future: Provider.of<RegisteredUsers>(context, listen: false)
            .findById(userId),
        builder: (ctx, resultSnapshot) => resultSnapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<RegisteredUsers>(
                builder: (ctx, regUsers, _) => SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.80,
                            child: Center(
                              child: Text(
                                '${regUsers.regUser.uFname} ${regUsers.regUser.uLname}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                          _heading('Registration Details', regUsers.regUser),
                          _detailsCard(regUsers.regUser),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.green, // background
                                      onPrimary: Colors.white,
                                      textStyle: TextStyle(fontSize: 18)),
                                  label: Text('Approve'),
                                  icon: Icon(Icons.check_circle_outline),
                                  onPressed: () =>
                                      updateStatus("A", regUsers.regUser.uid),
                                ),
                              ),
                              Flexible(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red, // background
                                    onPrimary: Colors.white, // foreground
                                    textStyle: TextStyle(fontSize: 18),
                                  ),
                                  icon: Icon(Icons.cancel_outlined),
                                  label: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text('Reject'),
                                  ),
                                  onPressed: () {
                                    updateStatus("R", regUsers.regUser.uid);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
