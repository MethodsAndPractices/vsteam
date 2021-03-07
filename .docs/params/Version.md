### Version

Specifies the version to use. The acceptable values for this parameter are:

- TFS2017
- TFS2017U1
- TFS2017U2
- TFS2017U3
- TFS2018
- TFS2018U1
- TFS2018U2
- TFS2018U3
- AzD2019
- AzD2019U1
- VSTS
- AzD

If you are on AzD it will default to Azd otherwise it will default to TFS2017.

```yaml
Type: String
Parameter Sets: Secure, Plain, Windows
Required: True
Position: 3
Default value: TFS2017 for TFS and AzD for AzD
```