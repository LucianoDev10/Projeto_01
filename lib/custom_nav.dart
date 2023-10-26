import 'package:flutter/material.dart';
import 'package:projeto_01_teste/utils/typograph.dart';

class CustomTabBar extends StatelessWidget {
  final List<IconData> icons;
  final List<IconData> icons_solid;
  final List<String> tabLabels;
  final int selectedIndex;
  final Function(int) onTap;
  final bool isbottomIndicator;

  const CustomTabBar({
    Key? key,
    required this.tabLabels,
    required this.selectedIndex,
    required this.icons,
    required this.icons_solid,
    required this.onTap,
    this.isbottomIndicator = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorPadding: EdgeInsets.zero,
      indicator: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: corPrimary,
            width: 3.0,
          ),
        ),
      ),
      labelColor: corText,
      unselectedLabelColor: Colors.black,
      labelStyle: const TextStyle(fontSize: 8.0),
      labelPadding: const EdgeInsets.all(0),
      tabs: icons
          .asMap()
          .map(
            (i, e) => MapEntry(
              i,
              Container(
                height: 70,
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0.0),
                child: Tab(
                  icon: SizedBox(
                    height: 23,
                    child: Icon(
                      i == selectedIndex ? icons_solid[i] : e,
                      color: i == selectedIndex ? corPrimary : Colors.black45,
                      size: 24.0,
                    ),
                  ),
                  text: tabLabels[i],
                ),
              ),
            ),
          )
          .values
          .toList(),
      onTap: onTap,
    );
  }
}
