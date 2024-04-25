import 'package:flutter/material.dart';
import 'package:hotel/presentation/home/widgets/text_widget.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key, this.email}) : super(key: key);

  final String? email; // Make email parameter optional

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (email != null) // Check if email is not null
                RichText(
                  text: TextSpan(
                    text: 'Hi,  ',
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: email!,//iam trying to display email on the screen. If I remove "!" it gives an error saying
                        style: const TextStyle(
                          color: Colors.cyan,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 20,
              ),
              _listTiles(
                title: 'Address 2',
                subtitle: 'My subtitle',
                icon: IconlyLight.profile,
                onPressed: () {},
                color: Colors.cyan,
              ),
              _listTiles(
                title: 'Bookings',
                icon: IconlyLight.bag,
                onPressed: () {},
                color: Colors.cyan,
              ),
              _listTiles(
                title: 'Viewed',
                icon: IconlyLight.show,
                onPressed: () {},
                color: Colors.cyan,
              ),
              _listTiles(
                title: 'Forget password',
                icon: IconlyLight.unlock,
                onPressed: () {},
                color: Colors.cyan,
              ),
              _listTiles(
                title: 'Logout',
                icon: IconlyLight.logout,
                onPressed: () {},
                color: Colors.cyan,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listTiles({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
      title: TextWidget(
        text: title,
        color: color,
        textSize: 22,
      ),
      subtitle: TextWidget(
        text: subtitle ?? "",
        color: color,
        textSize: 18,
      ),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {
        onPressed();
      },
    );
  }
}
