using namespace System.Management.Automation

# Work item types might come from
# * the current default project
# * a different project
# * a process template.
# In the completer we can look at the other parameters on the command line,
# and fill in the type names appropriate to the process/project given.
# In the validator we can only find other parameters via $PSCmdlet.MyInvocation.BoundParameters.
# ($psboundparameters gives a method's parameters). Doing that needs two warnings
# 1. ProjectName or processTemplate must being specified BEFORE the WorkItemType. Otherwise it tries to validate the WIT before they are bound
# 2. pscmdlet is only visible if the function using the class is also defined in the class's module
class WorkItemTypeValidateAttribute : ValidateArgumentsAttribute {
   [void] Validate(
      [object] $arguments,
      [EngineIntrinsics] $EngineIntrinsics) {

      # Do not fail on null or empty, leave that to other validation conditions
      if (-not [string]::IsNullOrEmpty($arguments)) {
         $workitemTypes = $null
         $msg = ""

         # If a process template was specified get the workitemtypes for that template.
         # If a (non-default) project was specified get the workitemtypes for that project
         # If no project (or the default project) was specified, get the default work item types.
         $processTemplate = ''

         if (Test-Path Variable:PSCmdlet) {
            $processTemplate = $pscmdlet.MyInvocation.BoundParameters['ProcessTemplate']
         }

         if ($processTemplate) {
            #Process work item cache holds full object. Using select-object avoids an error if nothing returned.
            $workitemTypes = [VSTeamWorkItemTypeCache]::GetCurrent($processTemplate)
            $msg = " in process '$processtemplate'"
         }
         else {
            $projectName = $pscmdlet.MyInvocation.BoundParameters['ProjectName']
            if (-not $projectName -or $projectName -eq ( _getDefaultProject) ) {
               $workitemTypes = [VSTeamWorkItemTypeCache]::GetCurrent($null)
            }
            else {
               $workitemTypes = Get-VSTeamWorkItemType -Project $projectname
               $msg = " in project '$projectname'"
            }
         }

         $workitemTypeNames = $workitemTypes | Select-Object -ExpandProperty Name | Sort-Object

         if ($workitemTypeNames -and (-not ($arguments -in $workitemTypeNames))) {
            throw [ValidationMetadataException]::new(
               "'$arguments' is not a valid WorkItemType$msg. Valid WorkItemTypes are: '" +
               ($workitemTypeNames -join "', '") + "'")
         }
      }
   }
}
