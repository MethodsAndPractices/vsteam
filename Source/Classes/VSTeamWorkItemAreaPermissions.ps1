# https://dev.azure.com/<organization>/_apis/securitynamespaces?api-version=5.0
[flags()] Enum VSTeamWorkItemAreaPermissions
{
    GENERIC_READ = 1
    GENERIC_WRITE = 2
    CREATE_CHILDREN = 4
    DELETE = 8
    WORK_ITEM_READ = 16
    WORK_ITEM_WRITE = 32
    MANAGE_TEST_PLANS = 64
    MANAGE_TEST_SUITES = 128
}