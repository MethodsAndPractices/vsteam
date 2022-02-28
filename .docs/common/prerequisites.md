Prerequisites:

Set the account and version that all calls will use with Set-VSTeamAccount.
Default version sets to API version 3.0 (AzD2019) if not manually set.

tips:

* check called version of the API with Get-VSTeamAPIVersion or Get-VSTeamInfo
* use Set-VSTeamDefaultProject to set default project for every call
* use Set-VSTeamDefaultAPITimeout to change the default timeout of 60 seconds for all calls.
* use Profiles to load an account and the correct version
