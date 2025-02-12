import 'package:flutter/material.dart';
import 'package:sw/common/components/helpers.dart';
import 'package:sw/common/constants/colors.dart';
import 'package:sw/common/utils/cache_helper.dart';
import 'package:sw/features/auth/screens/register_screen.dart';

import '../../stores/store_main_screen.dart';

class MainScreenDrawer extends StatelessWidget {
  const MainScreenDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: getScreenSize(context).width / 1.2,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), bottomLeft: Radius.circular(25))),
      elevation: 0,
      backgroundColor: const Color.fromARGB(255, 36, 36, 42),
      child: ListView(children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Card(
              color: Color.fromARGB(255, 30, 30, 36),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Smart win',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                          fontSize: 25),
                    ),
                  )
                ],
              )),
        ),
        const SizedBox(
          height: 150,
        ),
        Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: const ListTile(
            title: Text("دعوة صديق"),
            subtitle: Text(
              "يمكنك الحصول على نقطتين عند دعوة صديق",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
            subtitleTextStyle: TextStyle(
              fontSize: 10,
            ),
            leading: CircleAvatar(child: Icon(Icons.share)),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoreMainScreen(),
                ));
          },
          child: Card(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: const ListTile(
              title: Text("المتاجر"),
              leading: CircleAvatar(child: Icon(Icons.storefront)),
            ),
          ),
        ),
        Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: const ListTile(
            title: Text("الشروط والاحكام"),
            leading: CircleAvatar(child: Icon(Icons.privacy_tip)),
          ),
        ),
        GestureDetector(
          onTap: () async {
            await CacheHelper.clearCache();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
                (route) => false);
          },
          child: Card(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: const ListTile(
              title: Text("تسجيل خروج"),
              leading: CircleAvatar(child: Icon(Icons.logout_outlined)),
            ),
          ),
        ),
      ]),
    );
  }
}
