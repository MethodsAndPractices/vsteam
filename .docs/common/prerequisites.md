Prerequisites: 

Once per session:

Set the account that all calls will use with Set-VSTeamAccount.

Set the API version that all calls will use based on your environment using Set-VSTeamAPIVersion.  Not setting this will use the default which at this time is 3.0, TFS2017.  Using the default could limit API functionality.

You can check what version of the API will be called with Get-VSTeamAPIVersion.

Optional:

Generally, once per session:

Use Set-VSTeamDefaultProject so you don't have to provide the -ProjectName parameter with the rest of the calls in the module.  However, the -ProjectName parameter is dynamic and you can use tab completion to cycle through all the projects.

Use Set-VSTeamDefaultAPITimeout to change the default timeout of 60 seconds for all calls.