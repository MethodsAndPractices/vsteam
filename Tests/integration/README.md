# Running Integration tests

Many of the tests require a project to run. The naming of the files is used to ensure the tests that create the project can be run before the others. Nevertheless, in the BeforeAll of each file you can search for an existing project with 'Project for VSTeam integration testing.' as the description. If you find it you can use that project. If you don't your tests should create it's own project with that description. 

- Install SonarQube extension
- Set the following Environment variables.
  - `$env:ACCT = VSTS` Account Name or full TFS URL including collection
  - `$env:API_VERSION = TFS2017` or TFS2018 / AzD2019 for on-prem versions, or VSTS for the Service variant, depending on the value used for ACCT
  - `$env:EMAIL` = Email of user to remove and re-add to account
  - `$env:PAT` = Personal Access token of ACCT