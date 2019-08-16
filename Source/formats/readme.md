# Format

Make sure the table views are listed before the list views. If not when Get-ChildItem is called the list format will be used instead of the table. You can control the order the files are merged using the _formats.json file.

There are also needs to be a different format for the types returned from the provider which are PowerShell classes vs the types added to the objects returned by the other functions.
