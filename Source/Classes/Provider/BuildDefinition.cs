using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using System.Xml.Serialization;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class BuildDefinition : Directory
   {
      public long Id { get; set; }
      public string Path { get; set; }
      public long Revision { get; set; }
      public IList<string> Tags { get; }
      public IList<string> Demands { get; }
      public IList<object> Options { get; set; }
      public IList<object> Triggers { get; set; }
      public IList<object> RetentionRules { get; set; }
      public object Variables { get; set; }
      public object Repository { get; set; }
      public GitRepository GitRepository { get; }
      [XmlAttribute("repository.type")]
      public string RepositoryType { get; set; }
      public Queue Queue { get; }
      public string BuildNumberFormat { get; set; }
      public long JobCancelTimeoutInMinutes { get; set; }
      public string JobAuthorizationScope { get; set; }
      [XmlAttribute("createdDate")]
      public DateTime CreatedOn { get; set; }
      public User AuthoredBy { get; }
      public IList<BuildDefinitionProcessPhaseStep> Steps { get; }
      public BuildDefinitionProcess Process { get; }
      /// <summary>
      /// Used to pass on pipeline to Get-VSTeamPermissionInheritance
      /// </summary>
      public string ResourceType => "BuildDefinition";

      public BuildDefinition(PSObject obj, string projectName, IPowerShell powerShell) :
         base(obj, obj.GetValue("name"), "BuildDefinition", powerShell, projectName)
      {
         this.Tags = obj.GetStringArray("tags");
         this.Demands = obj.GetStringArray("demands");

         if (obj.HasValue("authoredBy"))
         {
            this.AuthoredBy = new User(obj.GetValue<PSObject>("authoredBy"));
         }

         // Depending on the build definition you might have a build or
         // process element.
         if (obj.HasValue("build"))
         {
            var i = 1;
            this.Steps = new List<BuildDefinitionProcessPhaseStep>();
            foreach (var item in obj.GetValue<object[]>("build"))
            {
               this.Steps.Add(new BuildDefinitionProcessPhaseStep((PSObject)item, i++, projectName));
            }
         }

         if (obj.HasValue("process"))
         {
            this.Process = new BuildDefinitionProcess(obj.GetValue<PSObject>("process"), projectName, powerShell);
         }

         if (obj.HasValue("queue"))
         {
            this.Queue = new Queue(obj.GetValue<PSObject>("queue"), this.ProjectName, powerShell);
         }

         if (this.RepositoryType == "TfsGit")
         {
            this.GitRepository = new GitRepository(obj.GetValue<PSObject>("repository"), this.ProjectName, powerShell);
         }
      }

      [ExcludeFromCodeCoverage]
      public BuildDefinition(PSObject obj, string projectName) :
         this(obj, projectName, new PowerShellWrapper(RunspaceMode.CurrentRunspace))
      {
      }

      public override string ToString() => this.Name;

      protected override object[] GetChildren()
      {
         // Wrap in a PSObject so a type can be applied so the correct
         // formatter is selected
         if (this.Steps != null)
         {
            return this.Steps.AddTypeName("vsteam_lib.Provider.BuildDefinitionProcessPhaseStep");
         }

         if (this.Process.Type == 1)
         {
            return this.Process.Phases.AddTypeName("vsteam_lib.Provider.BuildDefinitionProcessPhase");
         }

         var process = PSObject.AsPSObject(this.Process);

         if (this.Process.Type == 2)
         {
            process.AddTypeName("vsteam_lib.Provider.BuildDefinitionYamlProcess");
         }

         return new object[] { process };
      }
   }
}