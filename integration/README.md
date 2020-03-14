# Running Integration tests

**THESE TEST ARE DESTRUCTIVE. USE AN EMPTY ACCOUNT.**

- Install SonarQube extension
- Use an empty account to run the integration tests
- Set the following Environment variables.
  - `$env:ACCT = VSTS` Account Name or full TFS URL including collection
  - `$env:API_VERSION = TFS2017` or TFS2018 / AzD2019 for on-prem versions, or VSTS for the Service variant, depending on the value used for ACCT
  - `$env:EMAIL` = Email of user to remove and re-add to account
  - `$env:PAT` = Personal Access token of ACCT