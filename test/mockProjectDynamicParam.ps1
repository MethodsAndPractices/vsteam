Mock _buildProjectNameDynamicParam {
   # Set the dynamic parameters' name
   $ParameterName = 'Project'
   # Create the dictionary 
   $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
   # Create the collection of attributes
   $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
   # Create and set the parameters' attributes
   $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
   $ParameterAttribute.Mandatory = $true
   $ParameterAttribute.Position = 1
   $ParameterAttribute.ValueFromPipelineByPropertyName = $true
   # Add the attributes to the attributes collection
   $AttributeCollection.Add($ParameterAttribute)
   # Create and return the dynamic parameter
   $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
   $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
   return $RuntimeParameterDictionary
}