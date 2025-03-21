import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 56, 0, 0),
              child: ProfileHead(),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: ProfileDescription(),
            ),
          ],
        ),
      ),
    );
  }
}

// Includes Profile Picture, Display Name, Username, Followers and Created Recipes
class ProfileHead extends StatelessWidget {
  const ProfileHead({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(blurRadius: 2, color: Color.fromARGB(255, 107, 107, 107), spreadRadius: 1)],
          ),
          child: const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('lib/imgs/cheeseprofile.PNG'),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "CheeseLover",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )
            ),
            Text(
              "@CheeseBros",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14,
              )
            ),
            Text(
              "0 Followers  0 Recipes",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Description for profile
class ProfileDescription extends StatelessWidget {
  const ProfileDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 250, maxWidth: 250),
      child: const Text(
        "Cooking Legend.\nSeeking cheese recipes night and day.\n#CheeseLovers25",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}