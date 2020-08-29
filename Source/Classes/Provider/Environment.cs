using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Environment : Directory
   {
      public string Status { get; }
      public long ReleaseId { get; }
      public long EnvironmentId { get; }

      public Environment(string name, string status, string projectName, long releaseId, long environmentId, IPowerShell powerShell) :
         base(null, name, "Attempt", powerShell, projectName)
      {
         this.Status = status;
         this.ReleaseId = releaseId;
         this.EnvironmentId = environmentId;
      }

      [ExcludeFromCodeCoverage]
      public Environment(string name, string status, string projectName, long releaseId, long environmentId) :
         this(name, status, projectName, releaseId, environmentId, new PowerShellWrapper(RunspaceMode.CurrentRunspace))
      {
      }


   }
}
