// A student's profile, as shown on My Profile, Other User's Profile
// and edited on Edit Profile
class UserProfile {
  final String fullName;
  final String email;
  final String year;
  final List<String> majors;
  final List<String> minors;
  final List<String> skills;
  final List<GroupMembership> currentGroups;

  const UserProfile({
    required this.fullName,
    required this.email,
    required this.year,
    required this.majors,
    required this.minors,
    required this.skills,
    required this.currentGroups,
  });

  // Returns a copy with only the given fields changed (used by Edit Profile)
  UserProfile copyWith({
    String? year,
    List<String>? majors,
    List<String>? minors,
    List<String>? skills,
  }) {
    return UserProfile(
      fullName: fullName,
      email: email,
      year: year ?? this.year,
      majors: majors ?? this.majors,
      minors: minors ?? this.minors,
      skills: skills ?? this.skills,
      currentGroups: currentGroups,
    );
  }
}

// A group the user is in, and whether they own it or are a member
class GroupMembership {
  final String groupName;
  final bool isOwner;

  const GroupMembership({required this.groupName, required this.isOwner});
}

// Options for the "Year of study" dropdown
const List<String> yearOptions = [
  'Prep',
  '1st year',
  '2nd year',
  '3rd year',
  '4th year',
  'Graduate',
];

// Sample data until profiles come from the backend
class SampleProfiles {
  static const UserProfile currentUser = UserProfile(
    fullName: 'Azra At',
    email: 'azra.at@sabanciuniv.edu',
    year: '4th year',
    majors: ['Computer Science & Eng.'],
    minors: ['Mathematics'],
    skills: ['Flutter', 'SQL', 'Python', 'NLP'],
    currentGroups: [
      GroupMembership(groupName: 'CS310 app team', isOwner: true),
      GroupMembership(groupName: 'ENS491 project team', isOwner: false),
    ],
  );

  static const UserProfile otherUser = UserProfile(
    fullName: 'Elif Çamlıkaya',
    email: 'elif.c@sabanciuniv.edu',
    year: '3rd year',
    majors: ['Computer Science & Eng.'],
    minors: ['Business Analytics'],
    skills: ['UI design', 'Figma', 'Dart'],
    currentGroups: [
      GroupMembership(groupName: 'CS310 app team', isOwner: false),
      GroupMembership(groupName: 'SU Career Fair group', isOwner: true),
    ],
  );
}
