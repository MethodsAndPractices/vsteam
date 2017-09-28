#include "./common/header.md"

# Set-VSTeamApproval

## SYNOPSIS
#include "./synopsis/Set-VSTeamApproval.md"

## SYNTAX

```
Set-VSTeamApproval [-ProjectName] <String> [-Id] <Int32[]> [-Status] <String> [[-Approver] <String>]
 [[-Comment] <String>] [-Force]
```

## DESCRIPTION
Set-VSTeamApproval sets the status of approval to Approved, Rejected, Pending, or ReAssigned.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Get-VSTeamApproval | Set-VSTeamApproval
```

This command sets all pending approvals to approved.

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> Set-VSTeamApproval -Id 1 -Status Rejected
```

This command rejects approval with Id of 1.

## PARAMETERS

#include "./params/projectName.md"

### -Id
Specifies the approval IDs of the approvals to set.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Status
Specifies the status to set for the approval.

Valid values: 'Approved', 'Rejected', 'Pending', 'ReAssigned'

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: Approved
Accept pipeline input: False
Accept wildcard characters: False
```

### -Approver
Specifies the user to whom the approval has been re-assigned to
Alias of the user.
chuckreinhart@outlook.com, for example.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Comment
Specifies the comment to be stored with this approval.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#include "./params/force.md"

## INPUTS

### System.Int32[]
System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS