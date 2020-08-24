using System.Collections.Generic;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class BuildDefinitionProcessPhase : Directory
   {
      public object Target { get; set; }
      public long StepCount { get; set; }
      public string Condition { get; set; }
      public string JobAuthorizationScope { get; set; }
      public long JobCancelTimeoutInMinutes { get; set; }
      public IList<BuildDefinitionProcessPhaseStep> Steps { get; }

      public BuildDefinitionProcessPhase(PSObject obj, string projectName, IPowerShell powerShell) :
         base(obj, obj.GetValue("name"), "BuildDefinitionProcessPhase", powerShell, projectName)
      {
         Common.MoveProperties(this, obj);

         if (obj.HasValue("steps"))
         {
            var i = 1;
            var steps = new List<BuildDefinitionProcessPhaseStep>();
            foreach (var item in obj.GetValue<object[]>("steps"))
            {
               steps.Add(new BuildDefinitionProcessPhaseStep((PSObject)item, i++, projectName));
            }

            this.Steps = steps;
            this.StepCount = steps.Count;
         }
      }
   }
}
