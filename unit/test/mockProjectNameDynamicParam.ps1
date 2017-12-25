Mock _buildProjectNameDynamicParam {
   param(
      # Set the dynamic parameters' name
      $ParameterName = 'ProjectName',
      $ParameterSetName,
      $AliasName,
      $Mandatory = $true
   )

   # Create the dictionary
   $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
   # Create the collection of attributes
   $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
   # Create and set the parameters' attributes
   $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
   $ParameterAttribute.Mandatory = $Mandatory
   $ParameterAttribute.Position = 0
   $ParameterAttribute.ParameterSetName = $ParameterSetName
   $ParameterAttribute.ValueFromPipelineByPropertyName = $true

   if ($AliasName) {
      $AliasAttribute = New-Object System.Management.Automation.AliasAttribute(@($AliasName))
      $AttributeCollection.Add($AliasAttribute)
   }
   
   # Add the attributes to the attributes collection
   $AttributeCollection.Add($ParameterAttribute)
   # Create and return the dynamic parameter
   $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
   $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
   return $RuntimeParameterDictionary
}

Mock _buildDynamicParam {
   param(
      # Set the dynamic parameters' name
      $ParameterName
   )

   # Create the dictionary
   $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
   # Create the collection of attributes
   $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
   # Create and set the parameters' attributes
   $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
   $ParameterAttribute.Mandatory = $false
   $ParameterAttribute.Position = 1
   $ParameterAttribute.ValueFromPipelineByPropertyName = $true
   # Add the attributes to the attributes collection
   $AttributeCollection.Add($ParameterAttribute)
   # Create and return the dynamic parameter
   return New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
}