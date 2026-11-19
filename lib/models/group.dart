import 'package:sunite/models/user_profile.dart';

// A group post: shown on My Groups and managed by its owner on Manage Group
class Group {
  final String id;
  final String title;
  final String category; // e.g. 'Course Groups'
  final String categoryDetail; // e.g. 'CS310'; empty for Startups & Projects
  final List<String> lookingFor;
  final int maxMembers;
  final UserProfile owner;
  final List<UserProfile> members; // includes the owner
  final List<UserProfile> pendingRequests;

  const Group({
    required this.id,
    required this.title,
    required this.category,
    this.categoryDetail = '',
    required this.lookingFor,
    required this.maxMembers,
    required this.owner,
    required this.members,
    required this.pendingRequests,
  });

  int get memberCount => members.length;
  int get pendingCount => pendingRequests.length;
  bool get isFull => memberCount >= maxMembers;

  // 'Course Groups · CS310', or just 'Startups & Projects'
  String get categoryLine =>
      categoryDetail.isEmpty ? category : '$category · $categoryDetail';

  // Returns a copy with only the given lists changed (used by Manage Group)
  Group copyWith({
    List<UserProfile>? members,
    List<UserProfile>? pendingRequests,
  }) {
    return Group(
      id: id,
      title: title,
      category: category,
      categoryDetail: categoryDetail,
      lookingFor: lookingFor,
      maxMembers: maxMembers,
      owner: owner,
      members: members ?? this.members,
      pendingRequests: pendingRequests ?? this.pendingRequests,
    );
  }
}
