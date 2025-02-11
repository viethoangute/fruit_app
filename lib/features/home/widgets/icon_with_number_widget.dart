import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class BadgeIcon extends StatefulWidget {
  final int amount;
  final Icon icon;
  const BadgeIcon({Key? key, required this.amount, required this.icon}) : super(key: key);

  @override
  State<BadgeIcon> createState() => _BadgeIconState();
}

class _BadgeIconState extends State<BadgeIcon> {
  @override
  Widget build(BuildContext context) {
    return badges.Badge(
        position: badges.BadgePosition.topEnd(),
        badgeAnimation: const badges.BadgeAnimation.slide(
          disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
          curve: Curves.easeInCubic,
        ),
        showBadge: widget.amount != 0,
        badgeStyle: const badges.BadgeStyle(
          badgeColor: Colors.red,
        ),
        badgeContent: Text(
          '${widget.amount}',
          style: const TextStyle(color: Colors.white),
        ),
        child: widget.icon
    );
  }
}
