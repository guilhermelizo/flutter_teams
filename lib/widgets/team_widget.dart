import 'package:flutter/material.dart';
import 'package:flutterteams/models/member_model.dart';
import 'package:ionicons/ionicons.dart';
import 'package:responsive_builder/responsive_builder.dart';

const colors = {
  1: Colors.purple,
  2: Colors.blue,
  3: Colors.red,
  4: Colors.green,
};

class TeamWidget extends StatelessWidget {
  final List<MemberModel> team;

  late final List<MemberModel> groupVendor;
  late final List<MemberModel> groupClient;

  TeamWidget({required this.team}) {
    groupVendor = team.where((member) => member.isFromGroup('vendor')).toList();
    groupClient = team.where((member) => member.isFromGroup('client')).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizing) {
      final isMobile = sizing.deviceScreenType == DeviceScreenType.mobile;

      return Container(
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.white24),
        //   borderRadius: BorderRadius.circular(8.0),
        // ),
        padding: EdgeInsets.all(16.0),

        child: Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(minHeight: 220, minWidth: 300),
              decoration: BoxDecoration(
                color: colors[groupVendor.first.teamNumber],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(Ionicons.storefront_outline, size: 18),
                      const SizedBox(width: 6.0),
                      Text(
                        "Vendedor",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                  ...groupVendor
                      .map((member) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Text(
                              member.name,
                              style: member.hide
                                  ? TextStyle(backgroundColor: Colors.white)
                                  : null,
                            ),
                          ))
                      .toList(),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              constraints: BoxConstraints(minHeight: 220, minWidth: 300),
              decoration: BoxDecoration(
                color: colors[groupVendor.first.teamNumber],
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8),
                  topLeft: Radius.circular(8),
                ),
              ),
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(Ionicons.person_outline, size: 18),
                      const SizedBox(width: 6.0),
                      Text(
                        "Cliente",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                  ...groupClient
                      .map((member) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Text(
                              member.name,
                              style: member.hide
                                  ? TextStyle(backgroundColor: Colors.white)
                                  : null,
                            ),
                          ))
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
