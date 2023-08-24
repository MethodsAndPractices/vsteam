Retrieves a list of relations from a single work item.
This cmdlet is a shortcut for `Get-VSTeamWorkItem -Id $Id -Expand Relations | Select-Object -ExpandProperty Relations` and returns a list of relations compatible with the *-VSTeamWorkItemRelation and Switch-VSTeamWorkItemParent cmdlets
