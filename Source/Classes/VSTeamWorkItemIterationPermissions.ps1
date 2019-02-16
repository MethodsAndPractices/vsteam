# https://dev.azure.com/<organization>/_apis/securitynamespaces?api-version=5.0
[flags()] Enum AzDWorkItemIterationPermissions
{
    GENERIC_READ = 1
    GENERIC_WRITE = 2
    CREATE_CHILDREN = 4
    DELETE = 8
}
