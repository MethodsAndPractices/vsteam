using System.Diagnostics.CodeAnalysis;
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
      public Project Project { get; }
      public string SSHUrl { get; set; }
      public string RemoteUrl { get; set; }
      public string DefaultBranch { get; set; }
      /// <summary>
      /// Used to pass on pipeline to Get-VSTeamPermissionInheritance
      /// </summary>
      public string ResourceType => "Repository";
      /// <summary>
      /// This is used for passing the id down the pipeline into
      /// functions like Get-VSTeamGitCommit
      /// </summary>
      public string RepositoryID => this.Id;

      public GitRepository(PSObject obj, string projectName, IPowerShell powerShell) :
       base(obj, obj.GetValue("Name"), "GitRef", powerShell, projectName)
      {
         if (obj.HasValue("project"))
         {
            this.Project = new Project(obj.GetValue<PSObject>("project"), powerShell);
            this.ProjectName = this.Project.Name;
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

         var children = this.PowerShell.AddCommand(this.Command)
                                       .AddParameter("ProjectName", this.ProjectName)
                                       .AddParameter("RepositoryId", this.Id)
                                       .AddCommand("Sort-Object")
                                       .AddArgument("name")
                                       .Invoke();

         PowerShellWrapper.LogPowerShellError(this.PowerShell, children);

         // This applies types to select correct formatter.
         return children.AddTypeName(this.TypeName);
      }
   }
}
