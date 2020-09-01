using System.Collections.Generic;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class BuildDefinitionProcess : Directory
   {
      /// <summary>
      /// 1 = classic
      /// 2 = YAML
      /// </summary>
      public long Type { get; set; }
      public string YamlFilename { get; set; }
      public IList<BuildDefinitionProcessPhase> Phases { get; }

      public BuildDefinitionProcess(PSObject obj, string projectName, IPowerShell powerShell) :
         base(obj, "Process", string.Empty, powerShell, projectName)
      {
         if (this.Type == 1)
         {
            this.TypeName = "BuildDefinitionPhasedProcess";

            this.Phases = new List<BuildDefinitionProcessPhase>();
            foreach (var item in obj.GetValue<object[]>("phases"))
            {
               this.Phases.Add(new BuildDefinitionProcessPhase((PSObject)item, projectName, powerShell));
            }
         }
         else
         {
            this.DisplayMode = "------";
            this.TypeName = "BuildDefinitionYamlProcess";
         }
      }

      public override string ToString() => this.Type == 1 ? $"Number of phases: {this.Phases.Count}" : this.YamlFilename;
   }
}
