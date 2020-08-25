using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class GitRepository : Directory
   {
      public long Size { get; set; }
      public string Id { get; set; }
      public string Url { get; set; }
      public string SSHUrl { get; set; }
      public string RemoteUrl { get; set; }
      public string DefaultBranch { get; set; }
      public Project Project { get; }

      public GitRepository(PSObject obj, string projectName, IPowerShell powerShell) :
         base(obj, obj.GetValue("Name"), "GitRef", powerShell, projectName)
      {
         if (obj.HasValue("project"))
         {
            this.Project = new Project(obj.GetValue<PSObject>("project"), powerShell);
         }
      }

      [ExcludeFromCodeCoverage]
      public GitRepository(PSObject obj, string projectName) :
         this(obj, projectName, new PowerShellWrapper(RunspaceMode.CurrentRunspace))
      {
      }

      protected override object[] GetChildren()
      {
         this.PowerShell.Commands.Clear();

         var cmd = this.PowerShell.Create(RunspaceMode.CurrentRunspace)
                       .AddCommand(this.Command)
                       .AddParameter("ProjectName", this.ProjectName)
                       .AddParameter("RepositoryId", this.Id);

         var children = cmd.AddCommand("Sort-Object")
                           .AddArgument("name")
                           .Invoke();

         PowerShellWrapper.LogPowerShellError(cmd, children);

         // This applies types to select correct formatter.
         foreach (var child in children)
         {
            child.AddTypeName(this.TypeName);
         }

         return children.ToArray();
      }
   }
}
