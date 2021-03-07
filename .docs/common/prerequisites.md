Prerequisites: 

Set the account and version that all calls will use with Set-VSTeamAccount. If you do not set the version it default to 3.0, TFS2017. Using the default could limit API functionality.

You can check what version of the API that will be called with Get-VSTeamAPIVersion, or Get-VSTeamInfo.

You can also use Set-VSTeamDefaultProject so you do not have to provide the -ProjectName parameter with the rest of the calls in the module. However, the -ProjectName parameter is dynamic and you can use tab completion to cycle through all the projects.

Use Set-VSTeamDefaultAPITimeout to change the default timeout of 60 seconds for all calls.

You can also use Profiles to load an account and the correct version.
