import "package:flutter/material.dart";
import "package:rive/rive.dart";

class TabItem {
  TabItem({this.stateMachine = "", this.artboard = "", this.status});

  UniqueKey? id = UniqueKey();
  String stateMachine;
  String artboard;
  late SMIBool? status;

  static List<TabItem> tabItemList = [
    TabItem(stateMachine: "HOME_interactivity", artboard: "HOME"),
    TabItem(stateMachine: "SEARCH_Interactivity", artboard: "SEARCH"),
    TabItem(stateMachine: "USER_Interactivity", artboard: "USER"),
    TabItem(stateMachine: "BELL_Interactivity", artboard: "BELL"),
    TabItem(stateMachine: "CHAT_Interactivity", artboard: "CHAT"),
  ];
}
