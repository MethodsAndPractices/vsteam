Add or update ACEs in the ACL for the provided token. The request contains the target token, a list of ACEs and a optional merge parameter. In the case of a collision (by identity descriptor) with an existing ACE in the ACL, the "merge" parameter determines the behavior. If set, the existing ACE has its allow and deny merged with the incoming ACE's allow and deny. If unset, the existing ACE is displaced.

Note: This is a low-level function. You should really use a high level function (Add-VSTeam*Permission / Set-VSTeam*Permission / Get-VSTeam*Permission) unless you know what you are doing.
