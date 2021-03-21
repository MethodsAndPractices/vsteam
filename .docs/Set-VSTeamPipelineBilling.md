<!-- #include "./common/header.md" -->

# Set-VSTeamPipelineBilling

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamPipelineBilling.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Set-VSTeamPipelineBilling.md" --> This cmdlet covers what can be bought on the billing tab on organization level. At least owner or project collection administrator permissions are needed to trigger billing actions.

## EXAMPLES

### Example 1: Set Microsoft hosted pipeline jobs

```powershell
$myProfile = Get-VSTeamUserProfile -MyProfile
$orgs = Get-VSTeamAccounts -MemberId $myProfile.id
Set-VSTeamPipelineBilling -Type HostedPipeline -Quantity 1 -OrganizationId $orgs[0].accountId -SubscriptionId ebd42dd8-e50e-4608-aa5d-cf0c28e9aeef
```

Sets the concurrent jobs on organization `$orgs[0].accountId` and subscription `ebd42dd8-e50e-4608-aa5d-cf0c28e9aeef` for hosted pipelines to 1. This means depending on what was configured before either the number has been reduced or new concurrent jobs have been bought.
The cmdlet needs the organization id and the connected subscription for the organization. To get the id you can use `Get-VSTeamAccounts` and `Get-VSTeamUserProfile` to get the required data.

### Example 2: Set private hosted pipeline jobs

```powershell
Set-VSTeamPipelineBilling -Type PrivatePipeline -Quantity 1 -OrganizationId 9de24e7c-2e01-496c-bde5-71f92195ae2c -SubscriptionId ebd42dd8-e50e-4608-aa5d-cf0c28e9aeef
```

Sets the concurrent jobs for private agents on organization `9de24e7c-2e01-496c-bde5-71f92195ae2c` and subscription `ebd42dd8-e50e-4608-aa5d-cf0c28e9aeef` for hosted pipelines to 1. This means depending on what was configured before either the number has ben reduced of new concurrent jobs have been bought.

## PARAMETERS

### -Type

The type of billing that is supposed to be set.

```yaml
Type: string
Accepted values: HostedPipeline, PrivatePipeline
Required: true
```

### -OrganizationId

The organization where the billing should be set.

```yaml
Type: string
Required: true
```

### -SubscriptionId

The subscription id which the organization is using.

```yaml
Type: string
Required: true
```

### -Quantity

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

<!-- #include "./common/related.md" -->

[Get-VSTeamUserProfile](Get-VSTeamUserProfile.md)

[Get-VSTeamUserProfile](Get-VSTeamAccounts.md)
