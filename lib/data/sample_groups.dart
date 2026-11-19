import 'package:sunite/models/group.dart';
import 'package:sunite/models/join_request.dart';
import 'package:sunite/models/user_profile.dart';

// Sample data until groups come from the backend.
// The current user is SampleProfiles.currentUser (Azra).

const _azra = SampleProfiles.currentUser;
const _elif = SampleProfiles.otherUser;

const _mert = UserProfile(
  fullName: 'Mert Ali İlter',
  email: 'mert.ilter@sabanciuniv.edu',
  year: '2nd year',
  majors: ['Computer Science & Eng.'],
  minors: [],
  skills: ['Backend', 'Firebase'],
  currentGroups: [
    GroupMembership(groupName: 'ENS491 project team', isOwner: true),
    GroupMembership(groupName: 'CS310 app team', isOwner: false),
  ],
);

const _ece = UserProfile(
  fullName: 'Ece Ulutaş',
  email: 'ece.ulutas@sabanciuniv.edu',
  year: '3rd year',
  majors: ['Computer Science & Eng.'],
  minors: [],
  skills: ['Flutter', 'UI design'],
  currentGroups: [
    GroupMembership(groupName: 'ENS491 project team', isOwner: false),
    GroupMembership(groupName: 'CS412 study group', isOwner: false),
  ],
);

const _can = UserProfile(
  fullName: 'Can Yılmaz',
  email: 'can.yilmaz@sabanciuniv.edu',
  year: '2nd year',
  majors: ['Electronics Eng.'],
  minors: [],
  skills: ['Firebase'],
  currentGroups: [
    GroupMembership(groupName: 'CS412 study group', isOwner: true),
    GroupMembership(groupName: 'Campus food-waste app', isOwner: false),
  ],
);

class SampleGroups {
  // Groups Azra created (My Groups > Owned)
  static const List<Group> owned = [
    Group(
      id: 'cs310-team',
      title: 'CS310 app team',
      category: 'Course Groups',
      categoryDetail: 'CS310',
      lookingFor: ['Flutter'],
      maxMembers: 5,
      owner: _azra,
      members: [_azra, _mert, _elif],
      pendingRequests: [_ece, _can],
    ),
    Group(
      id: 'food-waste-app',
      title: 'Campus food-waste app',
      category: 'Startups & Projects',
      lookingFor: ['Backend', 'Marketing'],
      maxMembers: 3,
      owner: _azra,
      members: [_azra, _can],
      // More requests than open spots: accepting one fills the group
      pendingRequests: [_mert, _ece],
    ),
    Group(
      id: 'career-fair',
      title: 'Going to the SU Career Fair together',
      category: 'Events',
      categoryDetail: '14 Dec',
      lookingFor: ['Any major'],
      maxMembers: 6,
      owner: _azra,
      members: [_azra, _mert, _ece, _elif],
      pendingRequests: [],
    ),
  ];

  // Groups Azra is a member of (My Groups > Joined)
  static const List<Group> joined = [
    Group(
      id: 'ens491-team',
      title: 'ENS491 project team',
      category: 'Course Groups',
      categoryDetail: 'ENS491',
      lookingFor: ['Backend', 'ML'],
      maxMembers: 4,
      owner: _mert,
      members: [_mert, _azra, _ece],
      pendingRequests: [],
    ),
  ];

  // Join requests Azra sent that are still pending or were declined
  // (My Groups > My Requests)
  static const List<JoinRequest> myRequests = [
    JoinRequest(
      group: Group(
        id: 'cs412-study',
        title: 'CS412 study group',
        category: 'Course Groups',
        categoryDetail: 'CS412',
        lookingFor: ['Python', 'ML'],
        maxMembers: 4,
        owner: _can,
        members: [_can, _ece],
        pendingRequests: [_azra],
      ),
      status: RequestStatus.pending,
    ),
    JoinRequest(
      group: Group(
        id: 'bologna-erasmus',
        title: 'Going to Bologna in Fall 2027',
        category: 'Erasmus',
        categoryDetail: 'Bologna',
        lookingFor: ['Flatmate'],
        maxMembers: 3,
        owner: _elif,
        members: [_elif, _ece, _mert],
        pendingRequests: [],
      ),
      status: RequestStatus.declined,
    ),
  ];
}
