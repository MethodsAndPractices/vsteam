<!-- #include "./common/header.md" -->

# Set-VSTeamPipelineBilling

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamPipelineBilling.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Set-VSTeamPipelineBilling.md" --> A minimum of owner or project collection administrator permissions are required to trigger billing actions.

## EXAMPLES

### Example 1: Set Microsoft hosted pipeline jobs

```powershell
$myProfile = Get-VSTeamUserProfile -MyProfile
$orgs = Get-VSTeamAccounts -MemberId $myProfile.id
Set-VSTeamPipelineBilling -Type HostedPipeline -Quantity 1 -OrganizationId $orgs[0].accountId
```

Sets the concurrent jobs on organization `$orgs[0].accountId` for hosted pipelines to 1. Depending on the original value either the number has been reduced or new concurrent jobs have been purchased.
The organization id and the connected subscription for the organization are required. To get the id you can use `Get-VSTeamAccounts` and `Get-VSTeamUserProfile`.

### Example 2: Set private hosted pipeline jobs

```powershell
Set-VSTeamPipelineBilling -Type PrivatePipeline -Quantity 1 -OrganizationId 9de24e7c-2e01-496c-bde5-71f92195ae2c
```

Sets the concurrent jobs for private agents on organization `9de24e7c-2e01-496c-bde5-71f92195ae2c` for hosted pipelines to 1. Depending on the original value either the number has been reduced or new concurrent jobs have been purchased.

### Example 3: Set private hosted pipeline jobs with current organization

```powershell
Set-VSTeamPipelineBilling -Type PrivatePipeline -Quantity 1
```

Sets the concurrent jobs for private agents on the current set organization for hosted pipelines to 1. Depending on the original value either the number has been reduced or new concurrent jobs have been purchased.

## PARAMETERS

### Type

The type of billing to be set.

```yaml
Type: string
Accepted values: HostedPipeline, PrivatePipeline
Required: true
```

### OrganizationId

The organization to be billed.

```yaml
Type: string
Required: true
```

### Quantity

The quantity to which the billing should be set. E.g. for Microsoft-hosted pipelines you would set the concurred jobs.

```yaml
Type: int
Required: true
```

## INPUTS

## OUTPUTS

## NOTES

Beware that these operations are potentially producing costs. This is why you need to confirm or force the command.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS



[Get-VSTeamUserProfile](Get-VSTeamUserProfile.md)

[Get-VSTeamUserProfile](Get-VSTeamAccounts.md)

[Get-VSTeamAccountBilling](Get-VSTeamAccountBilling.md)
