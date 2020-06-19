



# Remove-VSTeamAccessControlEntry

## SYNOPSIS

Removes specified ACEs in the ACL for the provided token. The request URI contains the namespace ID, the target token, and a single or list of descriptors that should be removed. Only supports removing AzD based users/groups.

## SYNTAX

## DESCRIPTION

Removes specified ACEs in the ACL for the provided token. The request URI contains the namespace ID, the target token, and a single or list of descriptors that should be removed. Only supports removing AzD based users/groups.

## EXAMPLES
### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Remove-VSTeamAccessControlEntry -securityNamespaceId "2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87" -token "repov2/$projectid/$repoid" -descriptor @("vssgp.Uy0xLTktMTU1MTM3NDI0NS0xMzk4ODc2NjMwLTEwMTQ0ODQ4MTMtMzE5MDA4NTI4Ny0xNDU4NTkwODY1LTEtMzE1MjE3NTkwMy03NjE1NjY3OTMtMjgwMTUwMjI2Ny0zMjU5Mjg5MTIy")
```

This will remove the specified descriptor from the specified repository, using the security namespace id, while confirming for the remove action.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Remove-VSTeamAccessControlEntry -securityNamespaceId "2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87" -token "repov2/$projectid/$repoid" -descriptor @("vssgp.Uy0xLTktMTU1MTM3NDI0NS0xMzk4ODc2NjMwLTEwMTQ0ODQ4MTMtMzE5MDA4NTI4Ny0xNDU4NTkwODY1LTEtMzE1MjE3NTkwMy03NjE1NjY3OTMtMjgwMTUwMjI2Ny0zMjU5Mjg5MTIy") -confirm:$false
```

This will remove the specified descriptor from the specified repository, using the security namespace id, with no confirmation for the remove action.

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> Remove-VSTeamAccessControlEntry -securityNamespaceId "2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87" -token "repov2/$projectid/$repoid" -descriptor @("descriptor1","descriptor2")
```

This will remove multiple descriptors from the specified repository, using the security namespace id, while confirming for the remove action.

### -------------------------- EXAMPLE 4 --------------------------

```PowerShell
PS C:\> Remove-VSTeamAccessControlEntry -securityNamespace [VSTeamSecurityNamespace]$securityNamespace -token "repov2/$projectid/$repoid" -descriptor @("vssgp.Uy0xLTktMTU1MTM3NDI0NS0xMzk4ODc2NjMwLTEwMTQ0ODQ4MTMtMzE5MDA4NTI4Ny0xNDU4NTkwODY1LTEtMzE1MjE3NTkwMy03NjE1NjY3OTMtMjgwMTUwMjI2Ny0zMjU5Mjg5MTIy")
```

This will remove the specified descriptor from the specified repository, using a security namespace object, while confirming for the remove action.

### -------------------------- EXAMPLE 5 --------------------------

```PowerShell
PS C:\> Remove-VSTeamAccessControlEntry -securityNamespace [VSTeamSecurityNamespace]$securityNamespace -token "repov2/$projectid/$repoid" -descriptor @("vssgp.Uy0xLTktMTU1MTM3NDI0NS0xMzk4ODc2NjMwLTEwMTQ0ODQ4MTMtMzE5MDA4NTI4Ny0xNDU4NTkwODY1LTEtMzE1MjE3NTkwMy03NjE1NjY3OTMtMjgwMTUwMjI2Ny0zMjU5Mjg5MTIy") -confirm:$false
```

This will remove the specified descriptor from the specified repository, using a security namespace object, with no confirmation for the remove action.

### -------------------------- EXAMPLE 6 --------------------------

```PowerShell
PS C:\> Remove-VSTeamAccessControlEntry -securityNamespace [VSTeamSecurityNamespace]$securityNamespace -token "repov2/$projectid/$repoid" -descriptor @("descriptor1","descriptor2")
```

This will remove multiple descriptors from the specified repository, using a security namespace object, while confirming for the remove action.

## PARAMETERS

### -SecurityNamespace

VSTeamSecurityNamespace object.

```yaml
Type: VSTeamSecurityNamespace
Required: True
```

### -SecurityNamespaceId

Security namespace identifier.

Valid IDs are:

AzD:
- Analytics (58450c49-b02d-465a-ab12-59ae512d6531)
- AnalyticsViews (d34d3680-dfe5-4cc6-a949-7d9c68f73cba)
- ReleaseManagement (7c7d32f7-0e86-4cd6-892e-b35dbba870bd)
- ReleaseManagement2 (c788c23e-1b46-4162-8f5e-d7585343b5de)
- Identity (5a27515b-ccd7-42c9-84f1-54c998f03866)
- WorkItemTrackingAdministration (445d2788-c5fb-4132-bbef-09c4045ad93f)
- DistributedTask (101eae8c-1709-47f9-b228-0e476c35b3ba)
- WorkItemQueryFolders (71356614-aad7-4757-8f2c-0fb3bff6f680)
- GitRepositories (2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87)
- VersionControlItems2 (3c15a8b7-af1a-45c2-aa97-2cb97078332e)
- EventSubscriber (2bf24a2b-70ba-43d3-ad97-3d9e1f75622f)
- WorkItemTrackingProvision (5a6cd233-6615-414d-9393-48dbb252bd23)
- ServiceEndpoints (49b48001-ca20-4adc-8111-5b60c903a50c)
- ServiceHooks (cb594ebe-87dd-4fc9-ac2c-6a10a4c92046)
- Chat (bc295513-b1a2-4663-8d1a-7017fd760d18)
- Collection (3e65f728-f8bc-4ecd-8764-7e378b19bfa7)
- Proxy (cb4d56d2-e84b-457e-8845-81320a133fbb)
- Plan (bed337f8-e5f3-4fb9-80da-81e17d06e7a8)
- Process (2dab47f9-bd70-49ed-9bd5-8eb051e59c02)
- AccountAdminSecurity (11238e09-49f2-40c7-94d0-8f0307204ce4)
- Library (b7e84409-6553-448a-bbb2-af228e07cbeb)
- Environment (83d4c2e6-e57d-4d6e-892b-b87222b7ad20)
- Project (52d39943-cb85-4d7f-8fa8-c6baac873819)
- EventSubscription (58b176e7-3411-457a-89d0-c6d0ccb3c52b)
- CSS (83e28ad4-2d72-4ceb-97b0-c7726d5502c3)
- TeamLabSecurity (9e4894c3-ff9a-4eac-8a85-ce11cafdc6f1)
- ProjectAnalysisLanguageMetrics (fc5b7b85-5d6b-41eb-8534-e128cb10eb67)
- Tagging (bb50f182-8e5e-40b8-bc21-e8752a1e7ae2)
- MetaTask (f6a4de49-dbe2-4704-86dc-f8ec1a294436)
- Iteration (bf7bfa03-b2b7-47db-8113-fa2e002cc5b1)
- Favorites (fa557b48-b5bf-458a-bb2b-1b680426fe8b)
- Registry (4ae0db5d-8437-4ee8-a18b-1f6fb38bd34c)
- Graph (c2ee56c9-e8fa-4cdd-9d48-2c44f697a58e)
- ViewActivityPaneSecurity (dc02bf3d-cd48-46c3-8a41-345094ecc94b)
- Job (2a887f97-db68-4b7c-9ae3-5cebd7add999)
- WorkItemTracking (73e71c45-d483-40d5-bdba-62fd076f7f87)
- StrongBox (4a9e8381-289a-4dfd-8460-69028eaa93b3)
- Server (1f4179b3-6bac-4d01-b421-71ea09171400)
- TestManagement  (e06e1c24-e93d-4e4a-908a-7d951187b483)
- SettingEntries (6ec4592e-048c-434e-8e6c-8671753a8418)
- BuildAdministration (302acaca-b667-436d-a946-87133492041c)
- Location (2725d2bc-7520-4af4-b0e3-8d876494731f)
- Boards (251e12d9-bea3-43a8-bfdb-901b98c0125e)
- UtilizationPermissions (83abde3a-4593-424e-b45f-9898af99034d)
- WorkItemsHub (c0e7a722-1cad-4ae6-b340-a8467501e7ce)
- WebPlatform (0582eb05-c896-449a-b933-aa3d99e121d6)
- VersionControlPrivileges (66312704-deb5-43f9-b51c-ab4ff5e351c3)
- Workspaces (93bafc04-9075-403a-9367-b7164eac6b5c)
- CrossProjectWidgetView (093cbb02-722b-4ad6-9f88-bc452043fa63)
- WorkItemTrackingConfiguration (35e35e8e-686d-4b01-aff6-c369d6e36ce0)
- Discussion Threads (0d140cae-8ac1-4f48-b6d1-c93ce0301a12)
- BoardsExternalIntegration (5ab15bc8-4ea1-d0f3-8344-cab8fe976877)
- DataProvider (7ffa7cf4-317c-4fea-8f1d-cfda50cfa956)
- Social (81c27cc8-7a9f-48ee-b63f-df1e1d0412dd)
- Security (9a82c708-bfbe-4f31-984c-e860c2196781)
- IdentityPicker (a60e0d84-c2f8-48e4-9c0c-f32da48d5fd1)
- ServicingOrchestration (84cc1aa4-15bc-423d-90d9-f97c450fc729)
- Build (33344d9c-fc72-4d6f-aba5-fa317101a7e9)
- DashboardsPrivileges (8adf73b7-389a-4276-b638-fe1653f7efc7)
- VersionControlItems (a39371cf-0841-4c16-bbd3-276e341bc052)

VSSPS:
- EventSubscriber (2bf24a2b-70ba-43d3-ad97-3d9e1f75622f) (VSSPS)
- EventSubscription (58b176e7-3411-457a-89d0-c6d0ccb3c52b) (VSSPS)
- Registry (4ae0db5d-8437-4ee8-a18b-1f6fb38bd34c) (VSSPS)
- Graph (c2ee56c9-e8fa-4cdd-9d48-2c44f697a58e) (VSSPS)
- Invitation (ea0b4d1e-577a-4797-97b5-2f5755e548d5) (VSSPS)
- SystemGraph (b24dfdf1-285a-4ea6-a55b-32549a68121d) (VSSPS)
- Job (2a887f97-db68-4b7c-9ae3-5cebd7add999) (VSSPS)
- CommerceCollectionSecurity (307be2d3-12ed-45c2-aacf-6598760efca7) (VSSPS)
- StrongBox (4a9e8381-289a-4dfd-8460-69028eaa93b3) (VSSPS)
- GroupLicensing (c6a4fd35-b508-49eb-8ea7-7189df5f3698) (VSSPS)
- Server (1f4179b3-6bac-4d01-b421-71ea09171400) (VSSPS)
- SettingEntries (6ec4592e-048c-434e-8e6c-8671753a8418) (VSSPS)
- RemotableTemplateTest (ccdcb71c-4780-4a42-9bb4-8bce07a7628f) (VSSPS)
- Location (2725d2bc-7520-4af4-b0e3-8d876494731f) (VSSPS)
- WebPlatform (0582eb05-c896-449a-b933-aa3d99e121d6) (VSSPS)
- DataProvider (7ffa7cf4-317c-4fea-8f1d-cfda50cfa956) (VSSPS)
- Security (9a82c708-bfbe-4f31-984c-e860c2196781) (VSSPS)
- IdentityPicker (a60e0d84-c2f8-48e4-9c0c-f32da48d5fd1) (VSSPS)
- ServicingOrchestration (84cc1aa4-15bc-423d-90d9-f97c450fc729) (VSSPS)

```yaml
Type: String
Required: True
```

### -Token

The security Token

Valid token formats are:

- Git Repository (repov2/$projectID/$repositoryID)
- Build Definition ($projectID/$buildDefinitionID)
- Release Definition ($projectID/$releaseDefinitionID, $projectID/Path/to/Release/$releaseDefinitionID)

```yaml
Type: String
Required: True
```

### -Descriptor

An array of descriptors of users/groups to be removed

```yaml
Type: System.Array
Required: True
```

## INPUTS

## OUTPUTS

## NOTES

This function outputs a non-terminating error if the ACE removal from the ACL returns $False. This can be due to the wrong descriptor being provided, or the descriptor already not being on the ACL.

## RELATED LINKS

