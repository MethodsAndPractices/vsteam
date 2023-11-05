<!-- #include "./common/header.md" -->

# Get-VSTeamUserEntitlement

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamUserEntitlement.md" -->

Please note that Filter, Name, UserType and License parameters only works when MemberEntitlementManagement module version is 6.0 or upper
In the same way Top and Skip paramerers only works up to version 5.1

You can setup the specific version for the MemberEntitlementManagement calling Set-VSTeamAPIVersion -Service MemberEntitlementManagement -Version VersionNumberYouNeed.

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamUserEntitlement.md" -->

## EXAMPLES

### Example 1: Get user by Id

```powershell
Get-VSTeamUserEntitlement -Id f1ef22eb-5dd6-4e26-907c-986a0311b106
```

This command gets the user entitlement of the user identified by id.

### Example 2: Get users by name

```powershell
Get-VSTeamUserEntitlement -Name username
```

This command gets a list of users which mail or user name contains 'username'.
Filtering by Name, License, or UserType is available only when MemberEntitlementManagement service version is 6.0 or upper. See Get-VSTeamAPIVersion and Set-VSTeamAPIVersion commands


### Example 3: Filter with some conditions

```powershell
Get-VSTeamUserEntitlement -Filter "licenseId eq 'Account-Express' and licenseStatus eq 'Disabled'"
```

This command gets a list of users that match the license status and license type conditions.
The -Filter parameter is available only when MemberEntitlementManagement service version is 6.0 or upper. See Get-VSTeamAPIVersion and Set-VSTeamAPIVersion commands


### Example 4: List paged users

```powershell
Get-VSTeamUserEntitlement -Skip 100 -Top 100
```

This command list the from the user in the 101 position, the next 100 users
Filtering using the -Top -Skip parameters only works when MemberEntitlementManagement service version is below 6.0. See Get-VSTeamAPIVersion and Set-VSTeamAPIVersion commands


## PARAMETERS

### Skip

The number of items to skip.

```yaml
Type: Int32
Parameter Sets: List
```

### Id

The id of the user to retrieve.

```yaml
Type: String[]
Aliases: UserId
Parameter Sets: ByID
```

### Top

Specifies the maximum number to return.

```yaml
Type: Int32
Parameter Sets: List
```

### Select

Comma (",") separated list of properties to select in the result entitlements.  The acceptable values for this parameter are:

- Projects
- Extensions
- GroupRules

```yaml
Type: String
Parameter Sets: List,PagedFilter,PagedParams
Required: True
Default value: None
```

### MaxPages

User entlitement API returs a paged result. This parameter allows to limit the number of pages to be retrieved. Default is 0 = all pages.

```yaml
Type: int
Parameter Sets: PagedFilter,PagedParams
Required: False
Default value: $null
```

### Filter

Equality operators relating to searching user entitlements seperated by and clauses. Valid filters include: licenseId, licenseStatus, userType, and name.
- licenseId: filters based on license assignment using license names. i.e. licenseId eq 'Account-Stakeholder' or licenseId eq 'Account-Express'.
- licenseStatus: filters based on license status. currently only supports disabled. i.e. licenseStatus eq 'Disabled'. To get disabled basic licenses, you would pass (licenseId eq 'Account-Express' and licenseStatus eq 'Disabled')
- userType: filters off identity type. Suppored types are member or guest i.e. userType eq 'member'.
- name: filters on if the user's display name or email contians given input. i.e. get all users with "test" in email or displayname is "name eq 'test'".

A valid query could be: (licenseId eq 'Account-Stakeholder' or (licenseId eq 'Account-Express' and licenseStatus eq 'Disabled')) and name eq 'test' and userType eq 'guest'.

Currently, filter names and values must match exactly the case. i.e.:
* LicenseID will throw Invalid filter message.
* licenseId eq 'account-stakeholder' will return an empty list

```yaml
Type: string
Parameter Sets: PagedFilter
Required: False
Default value: None
```

### License

Filters based on license assignment using license names

The acceptable values for this parameter are:
- Account-Stakeholder: Stakeholder
- Account-Express: Basic
- Account-Advanced: Basic + Test Plans

Other licenses which source (licenseSource) is MSDN cannot be filtered here
Parameter values are case sensitive

```yaml
Type: string
Parameter Sets: PagedParams
Required: False
Default value: None
```

### LicenseId

Filters based on license id.

The acceptable values for this parameter are:
- Account-Stakeholder (Stakeholder)
- Account-Express (Basic)
- Account-Advanced (Basic + Test Plans)

```yaml
Type: string
Parameter Sets: PagedParams
Required: False
Default value: None
```

### UserType

Filters based on user type

The acceptable values for this parameter are:
- member
- guest

Parameter values are case sensitive

```yaml
Type: string
Parameter Sets: PagedParams
Required: False
Default value: None
```

### Name

Filters on if the user's display name or email contains given input

```yaml
Type: string
Parameter Sets: PagedParams
Required: False
Default value: None
```


## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
