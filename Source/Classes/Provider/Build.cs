using System;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using System.Xml.Serialization;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Build : Leaf
   {
      public Queue Queue { get; }
      public string Status { get; set; }
      public string Result { get; set; }
      public string BuildNumber { get; set; }
      public DateTime? StartTime { get; set; }
      public UserEntitlement RequestedBy { get; }
      public UserEntitlement RequestedFor { get; }
      public UserEntitlement LastChangedBy { get; }
      public BuildDefinition BuildDefinition { get; }
      public Project Project { get; }

      // Properties below were in the old type file and are
      // here to break as little as possible for those that
      // upgrade.
      [XmlAttribute("definition.name")]
      public string DefinitionName { get; set; }
      [XmlAttribute("queue.id")]
      public string QueueId { get; set; }
      [XmlAttribute("queue.name")]
      public string QueueName { get; set; }
      [XmlAttribute("repository.type")]
      public string RepositoryType { get; set; }
      public string RequestedByUser => this.RequestedBy.DisplayName;
      public string RequestedForUser => this.RequestedFor.DisplayName;
      public string LastChangedByUser => this.LastChangedBy.DisplayName;

      public Build(PSObject obj, string projectName, IPowerShell powerShell) :
         base(obj, obj.GetValue("buildNumber"), obj.GetValue("Id"), projectName)

      {
         this.RequestedBy = new UserEntitlement(obj.GetValue<PSObject>("requestedBy"), projectName);
         this.RequestedFor = new UserEntitlement(obj.GetValue<PSObject>("requestedFor"), projectName);
         this.LastChangedBy = new UserEntitlement(obj.GetValue<PSObject>("lastChangedBy"), projectName);

         this.Project = new Project(obj.GetValue<PSObject>("project"), powerShell);
         this.Queue = new Queue(obj.GetValue<PSObject>("queue"), projectName, powerShell);
         this.BuildDefinition = new BuildDefinition(obj.GetValue<PSObject>("definition"), projectName, powerShell);
      }

      [ExcludeFromCodeCoverage]
      public Build(PSObject obj, string projectName) :
         this(obj, projectName, new PowerShellWrapper(RunspaceMode.CurrentRunspace))
      {         
      }
   }
}
