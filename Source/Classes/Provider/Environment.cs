using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Environment : Directory
   {
      public long Id { get; set; }
      public long ReleaseId { get; }
      public string Status { get; set; }
      public long EnvironmentId => this.Id;
      public List<Attempt> Attempts { get; }

      public Environment(PSObject obj, long releaseId, string projectName, IPowerShell powerShell) :
         base(obj, obj.GetValue("name"), "Attempt", powerShell, projectName)
      {
         this.ReleaseId = releaseId;

         this.Attempts = new List<Attempt>();
         foreach (var item in obj.GetValue<object[]>("deploySteps"))
         {
            this.Attempts.Add(new Attempt((PSObject)item, this.ProjectName));
         }
      }

      [ExcludeFromCodeCoverage]
      public Environment(PSObject obj, long releaseId, string projectName) :
         this(obj, releaseId, projectName, new PowerShellWrapper(RunspaceMode.CurrentRunspace))
      {
      }

      protected override object[] GetChildren() => this.Attempts.AddTypeName(this.TypeName);
   }
}
