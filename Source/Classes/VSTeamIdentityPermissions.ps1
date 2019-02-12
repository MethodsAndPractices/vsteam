# https://dev.azure.com/<organization>/_apis/securitynamespaces?api-version=5.0
[flags()] Enum ADOIdentityPermissions
{
    Read = 1
    Write = 2
    Delete = 4
    ManageMembership = 8
    CreateScope = 16
    RestoreScope = 32
}