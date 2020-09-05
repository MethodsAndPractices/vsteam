using System;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Project : Directory
   {
      public string Id { get; set; }
      public string Url { get; set; }
      public string State { get; set; }
      public long Revision { get; set; }
      public string Visibility { get; set; }
      public string Description { get; set; }

      /// <summary>
      /// This is required so we can pipe this object to functions
      /// like Remove-VSTeamProject. Even though the base class has
      /// a name property, without it you will get an 
      /// error stating:
      ///
      /// The input object cannot be bound to any parameters for the 
      /// command either because the command does not take pipeline 
      /// input or the input and its properties do not match any of 
      /// the parameters that take pipeline input.
      ///
      /// Adding this property has it match the ProjectName alias for
      /// name on Remove-VSTeamProject.
      /// </summary>
      public new string ProjectName => base.ProjectName;

      /// <summary>
      /// Used for testing 
      /// </summary>
      public Project(PSObject obj, IPowerShell powerShell) :
         base(obj, obj.GetValue("name"), null, powerShell, obj.GetValue("name"))
      {
      }

      /// <summary>
      /// Used by PowerShell
      /// </summary>
      [ExcludeFromCodeCoverage]
      public Project(PSObject obj) :
         this(obj, new PowerShellWrapper(RunspaceMode.CurrentRunspace))
      {
      }

      public override string ToString() => base.Name;

      protected override object[] GetChildren() => new object[]
         {
            new Directory(null, "Build Definitions", "BuildDefinition", this.PowerShell, this.Name),
            new Directory(null, "Builds", "Build", this.PowerShell, this.Name),
            new Directory(null, "Queues", "Queue", this.PowerShell, this.Name),
            new Directory(null, "Release Definitions", "ReleaseDefinition", this.PowerShell, this.Name),
            new Releases(this.PowerShell, this.Name),
            new Directory(null, "Repositories", "GitRepository", this.PowerShell, this.Name),
            new Directory(null, "Teams", "Team", this.PowerShell, this.Name),
         };
   }
}
