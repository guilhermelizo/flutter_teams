import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterteams/models/member_model.dart';

class MemberSearchController {
  final _searchController = StreamController<String>();

  Sink get seachEvent => _searchController.sink;

  Stream<List<MemberModel>> get searchStream => _searchController.stream
          .where((q) => q.isNotEmpty)
          .asyncMap((query) async {
        final data =
            await FirebaseFirestore.instance.collection('members').get();
        final result = data.docs
            .map(
              (e) => MemberModel.fromMap(
                e.data(),
                e.id,
              ),
            )
            .where((member) =>
                member.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        return result;
      }).asBroadcastStream();

  void dispose() => _searchController.close();
}
