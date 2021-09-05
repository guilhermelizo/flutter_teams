import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterteams/controllers/member_search_controller.dart';
import 'package:flutterteams/models/member_model.dart';
import 'package:flutterteams/widgets/brand_widget.dart';
import 'package:flutterteams/widgets/lock_section_widget.dart';
import 'package:flutterteams/widgets/team_widget.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final searchController = MemberSearchController();
  String query = "";
  late final animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat(reverse: true);

  final textToAnimate = "Parabéns, Devs!! ";

  bool showBlood = false;

  late final _characterCount = StepTween(
    begin: 0,
    end: textToAnimate.length,
  ).animate(CurvedAnimation(
    parent: animationController,
    curve: Curves.easeIn,
  ));

  late final Animation<double> _cursorBlink =
      Tween<double>(begin: .0, end: 1.0).animate(
    animationController,
  );

  Widget teamCard(String team, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            team,
            style: Theme.of(context).textTheme.headline6,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white70),
              borderRadius: BorderRadius.circular(8),
              color: color,
            ),
            height: 72,
            width: 72,
          )
        ],
      ),
    );
  }

  int currentPage = 0;

  final _pageController = PageController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void goToPage(int number) {
    setState(() {
      currentPage = number;
      _pageController.jumpToPage(
        currentPage,
      );
    });
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    late final teamsPage = StreamBuilder<
            DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('permissions')
            .doc('enable_teams')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.data()!;
            final enable = data['field'] as bool;
            if (enable) {
              return SingleChildScrollView(
                child: ResponsiveBuilder(builder: (context, sizing) {
                  final isMobile =
                      sizing.deviceScreenType == DeviceScreenType.mobile;

                  return Container(
                    child: Column(
                      children: [
                        Lottie.asset(
                          'assets/lottie/team_up.json',
                          width: getValueForScreenType(
                            context: context,
                            mobile: 400,
                            desktop: 550,
                          ),
                        ),
                        Text(
                          "Team up!",
                          style: isMobile
                              ? Theme.of(context).textTheme.headline4
                              : Theme.of(context).textTheme.headline3,
                        ),
                        Text(
                          "Está na hora de você conhecer seu time!",
                          style: Theme.of(context).textTheme.subtitle1,
                          textAlign: TextAlign.center,
                        ),
                        Wrap(
                          alignment: WrapAlignment.spaceAround,
                          children: [
                            teamCard("Time 01", Colors.purple),
                            teamCard("Time 02", Colors.blue),
                            teamCard("Time 03", Colors.red),
                            teamCard("Time 04", Colors.green),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          alignment: Alignment.center,
                          child: Container(
                            width: isMobile ? 272 : 500,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: 'Digite seu nome para descobrir',
                                  contentPadding: EdgeInsets.all(16),
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    onPressed: () =>
                                        searchController.seachEvent.add(query),
                                    icon: Icon(Ionicons.search_outline),
                                    padding: EdgeInsets.zero,
                                  )),
                              onChanged: (txt) => query = txt,
                              onSubmitted: searchController.seachEvent.add,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        StreamBuilder<List<MemberModel>>(
                            stream: searchController.searchStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final members = snapshot.data!;
                                return Container(
                                  child: Wrap(
                                    children: members
                                        .where((m) => m.hide)
                                        .map(
                                          (m) => GestureDetector(
                                            onTap: () {
                                              FirebaseFirestore.instance
                                                  .collection('members')
                                                  .doc(m.key)
                                                  .update({
                                                'hide': false,
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Chip(
                                                label: Text(m.name),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }),
                        const SizedBox(height: 18),
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('members')
                                .snapshots(),
                            builder: (context, snapshot) {
                              late Widget content;

                              if (snapshot.hasError) {
                                content = Text("Erro");
                              } else if (snapshot.hasData) {
                                final data = snapshot.data!;
                                final members = data.docs.map((doc) {
                                  return MemberModel.fromMap(doc.data());
                                }).toList();

                                final team01 = members
                                    .where((member) => member.isFromTeam(1))
                                    .toList();
                                final team02 = members
                                    .where((member) => member.isFromTeam(2))
                                    .toList();
                                final team03 = members
                                    .where((member) => member.isFromTeam(3))
                                    .toList();
                                final team04 = members
                                    .where((member) => member.isFromTeam(4))
                                    .toList();

                                content = Wrap(
                                  alignment: WrapAlignment.spaceAround,
                                  children: [
                                    TeamWidget(team: team01),
                                    TeamWidget(team: team02),
                                    TeamWidget(team: team03),
                                    TeamWidget(team: team04),
                                  ],
                                );
                              } else {
                                content =
                                    Center(child: CircularProgressIndicator());
                              }

                              return Container(
                                color: Colors.black26,
                                padding: const EdgeInsets.all(8),
                                width: double.infinity,
                                child: content,
                              );
                            }),
                      ],
                    ),
                  );
                }),
              );
            } else {
              return LockSectionWidget();
            }
          } else {
            return Container();
          }
        });

    late final startPage = ResponsiveBuilder(builder: (context, sizing) {
      final isMobile = sizing.deviceScreenType == DeviceScreenType.mobile;
      return Stack(
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Lottie.asset(
                    'assets/lottie/developers.json',
                    width: getValueForScreenType(
                      context: context,
                      mobile: 500,
                      desktop: 650,
                    ),
                  ),
                  AnimatedBuilder(
                      animation: animationController,
                      builder: (context, _) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  textToAnimate.substring(
                                      0, _characterCount.value),
                                  style: isMobile
                                      ? Theme.of(context).textTheme.headline4
                                      : Theme.of(context).textTheme.headline3,
                                ),
                                Opacity(
                                  opacity: _cursorBlink.value,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    color: Colors.white70,
                                    height: 36,
                                    width: 4,
                                  ),
                                )
                              ],
                            ),
                          ],
                        );
                      }),
                  Flex(
                    direction: isMobile ? Axis.vertical : Axis.horizontal,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sua jornada no Flutter está terminando e nada melhor que um ",
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        "DESAFIO FINAL!",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        showBlood = true;
                      });

                      Future.delayed(const Duration(seconds: 5), () {
                        goToPage(1);
                        setState(() {
                          showBlood = false;
                        });
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Ionicons.rocket_outline),
                          Text("Vamos lá!"),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          if (showBlood)
            Lottie.asset(
              'assets/lottie/blood.json',
              height: double.maxFinite,
              width: double.maxFinite,
              fit: BoxFit.cover,
            ),
        ],
      );
    });

    return ResponsiveBuilder(builder: (context, sizing) {
      bool isMobile = sizing.deviceScreenType == DeviceScreenType.mobile;

      final actions = !isMobile
          ? [
              TextButton(
                child: Text("Início"),
                onPressed: () => goToPage(0),
              ),
              TextButton(
                child: Text("Times"),
                onPressed: () => goToPage(1),
              ),
            ]
          : null;

      final drawer = isMobile
          ? Drawer(
              child: ListView(
                children: [
                  DrawerHeader(
                    child: Center(
                      child: BrandWidget(size: 48, fontSize: 24),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Ionicons.home_outline),
                    title: Text("Início"),
                    onTap: () => goToPage(0),
                    selected: currentPage == 0,
                  ),
                  ListTile(
                    leading: Icon(Ionicons.people_outline),
                    title: Text("Times"),
                    onTap: () => goToPage(1),
                    selected: currentPage == 1,
                  ),
                ],
              ),
            )
          : null;

      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Hero(
            tag: 'brand_tag',
            child: BrandWidget(size: 36, fontSize: 18),
          ),
          actions: actions,
        ),
        drawer: drawer,
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            startPage,
            teamsPage,
          ],
        ),
      );
    });
  }
}
