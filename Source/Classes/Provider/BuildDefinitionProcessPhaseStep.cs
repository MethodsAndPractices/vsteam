using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class BuildDefinitionProcessPhaseStep : Leaf
   {
      public bool Enabled { get; set; }
      public bool ContinueOnError { get; set; }
      public bool AlwaysRun { get; set; }
      public long TimeoutInMinutes { get; set; }
      public object Inputs { get; set; }
      public object Task { get; set; }
      public string Condition { get; set; }

      public BuildDefinitionProcessPhaseStep(PSObject obj, int stepNumber, string projectName) :
         base(obj, obj.GetValue("displayName"), stepNumber.ToString(), projectName)
      {
      }
   }
}
