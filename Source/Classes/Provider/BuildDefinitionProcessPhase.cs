using System;
using System.Collections.Generic;
using System.Linq;
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
         this.Steps = new List<BuildDefinitionProcessPhaseStep>();

         if (obj.HasValue("steps"))
         {
            var i = 1;
            foreach (var item in obj.GetValue<object[]>("steps"))
            {
               this.Steps.Add(new BuildDefinitionProcessPhaseStep((PSObject)item, i++, projectName));
            }

            this.StepCount = this.Steps.Count;
         }
      }

      protected override object[] GetChildren()
      {
         // Wrap in a PSObject so a type can be applied so the correct
         // formatter is selected
         var items = this.Steps.Select(p => PSObject.AsPSObject(p)).ToArray();
         Array.ForEach(items, i => i.AddTypeName("vsteam_lib.Provider.BuildDefinitionProcessPhaseStep"));
         return items;
      }
   }
}
