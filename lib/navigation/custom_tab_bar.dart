import 'package:alumnet/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:alumnet/models/tab_item.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key, required this.changeScreen, required this.onTabPress, required this.selectedTab});

  final Function changeScreen;
  final Function onTabPress;
  final int selectedTab;
  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  void _onRiveIconInit(Artboard artboard, int index) {
    final controller = StateMachineController.fromArtboard(artboard, _icons[index].stateMachine);
    artboard.addController(controller!);

    _icons[index].status = controller.findInput<bool>("active") as SMIBool;
  }

  final List<TabItem> _icons = TabItem.tabItemList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 8),
        padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AlumnetTheme.background2.withOpacity(0.8),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AlumnetTheme.background2.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 20),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _icons.length,
              (index) {
                TabItem icon = _icons[index];

                return Expanded(
                  key: icon.id,
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(12),
                    onPressed: () {
                      widget.onTabPress(index);
                    },
                    child: AnimatedOpacity(
                      opacity: widget.selectedTab == index ? 1 : 0.5,
                      duration: const Duration(milliseconds: 200),
                      child: SizedBox(
                        height: 36,
                        width: 36,
                        child: RiveAnimation.asset(
                          'assets/rive_app/icons.riv',
                          stateMachines: [icon.stateMachine],
                          artboard: icon.artboard,
                          onInit: (artboard) {
                            _onRiveIconInit(artboard, index);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
