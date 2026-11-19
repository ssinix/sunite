import 'package:sunite/models/user_profile.dart';

// A group post: shown on My Groups and Group Detail, and managed by its
// owner on Manage Group
class Group {
  final String id;
  final String title;
  final String category; // e.g. 'Course Groups'
  final String categoryDetail; // e.g. 'CS310'; empty for Startups & Projects
  final String description;
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
    this.description = '',
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

  // What categoryDetail means on this board, shown on Group Detail
  String get categoryDetailLabel {
    if (category == 'Course Groups') return 'Course code';
    if (category == 'Erasmus') return 'School';
    if (category == 'Events') return 'Date';
    return ''; // Startups & Projects has no extra field
  }

  // How a user is related to this group (users are compared by e-mail)
  bool isOwnedBy(UserProfile user) => owner.email == user.email;
  bool hasMember(UserProfile user) =>
      members.any((member) => member.email == user.email);
  bool hasRequestFrom(UserProfile user) =>
      pendingRequests.any((requester) => requester.email == user.email);

  // Returns a copy with only the given lists changed
  Group copyWith({
    List<UserProfile>? members,
    List<UserProfile>? pendingRequests,
  }) {
    return Group(
      id: id,
      title: title,
      category: category,
      categoryDetail: categoryDetail,
      description: description,
      lookingFor: lookingFor,
      maxMembers: maxMembers,
      owner: owner,
      members: members ?? this.members,
      pendingRequests: pendingRequests ?? this.pendingRequests,
    );
  }
}
