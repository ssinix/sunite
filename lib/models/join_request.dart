import 'package:sunite/models/group.dart';

// No "accepted": once the owner accepts, the group moves to My Groups > Joined
enum RequestStatus { pending, declined }

// A join request the current user sent to a group (My Groups > My Requests)
class JoinRequest {
  final Group group;
  final RequestStatus status;

  const JoinRequest({required this.group, required this.status});
}
