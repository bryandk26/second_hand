import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_chance/theme.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: darkGrey.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: blackColor,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
            color: textColor, fontWeight: FontWeight.w600, fontSize: 14),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: darkGrey.withOpacity(0.1),
              ),
              child: Icon(
                CupertinoIcons.forward,
                size: 18.0,
                color: blackColor,
              ),
            )
          : null,
    );
  }
}
