class MemberModel {
  final String? key;
  final int teamNumber;
  final String groupLabel;
  final String name;
  final bool hide;

  const MemberModel({
    required this.teamNumber,
    required this.groupLabel,
    required this.name,
    required this.hide,
    this.key,
  });

  static MemberModel fromMap(Map<String, dynamic> map, [String? key]) =>
      MemberModel(
        teamNumber: map['teamNumber'],
        groupLabel: map['groupLabel'],
        name: map['name'],
        hide: map['hide'],
        key: key,
      );

  bool isFromTeam(int number) => teamNumber == number;
  bool isFromGroup(String label) => groupLabel == label;
}
