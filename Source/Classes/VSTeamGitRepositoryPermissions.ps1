# https://dev.azure.com/<organization>/_apis/securitynamespaces?api-version=5.0
[flags()] Enum AzDGitRepositoryPermissions
{
    Administer = 1
    GenericRead = 2
    GenericContribute = 4
    ForcePush = 8
    CreateBranch = 16
    CreateTag = 32
    ManageNote = 64
    PolicyExempt = 128
    CreateRepository = 256
    DeleteRepository = 512
    RenameRepository = 1024
    EditPolicies = 2048
    RemoveOthersLocks = 4096
    ManagePermissions = 8192
    PullRequestContribute = 16384
    PullRequestBypassPolicy = 32768
}