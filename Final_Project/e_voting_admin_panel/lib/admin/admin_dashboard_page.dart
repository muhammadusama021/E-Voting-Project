import 'package:e_voting_admin_panel/admin/widgets/side_menu_admin.dart';
import 'package:e_voting_admin_panel/resources/auth_methods.dart';
import 'package:e_voting_admin_panel/utils/global_varaibles.dart';
import 'package:e_voting_admin_panel/widgets/navigation_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_voting_admin_panel/models/admin.dart' as adminModel;

class AdminDashBoardPage extends StatefulWidget {
  const AdminDashBoardPage({Key key}) : super(key: key);

  @override
  _AdminDashBoardPageState createState() => _AdminDashBoardPageState();
}

class _AdminDashBoardPageState extends State<AdminDashBoardPage> {
  int _page = 0;
  adminModel.Admin admin;
  PageController adminPageController;

  @override
  void initState() {
    super.initState();
    adminPageController = PageController();
  }

  getAdminData() async {
    admin = await AuthMethods().getCurrentAdminDetails();

    return admin;
  }

  @override
  void dispose() {
    super.dispose();
    adminPageController.dispose();
  }

  navigationTapped(int page) {
    adminPageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAdminData(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: Row(
              children: [
                SideMenuAdmin(
                  pageController: adminPageController,
                ),
                Column(
                  children: [
                    NavigationWidget(
                        headline: 'Admin',
                        username: admin.username,
                        ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      width: MediaQuery.of(context).size.width * 0.76,
                      height: MediaQuery.of(context).size.height * 0.78,
                      // color: Colors.green,
                      child: PageView(
                        children: dashboardItemsAdmin,
                        physics: const NeverScrollableScrollPhysics(),
                        controller: adminPageController,
                        onPageChanged: onPageChanged,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
