using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using System.Xml.Serialization;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Release : Directory
   {
      public long Id { get; set; }
      public string Status { get; set; }
      [XmlAttribute("releaseDefinition.name")]
      public string DefinitionName { get; set; }
      public UserEntitlement CreatedBy { get; }
      public UserEntitlement ModifiedBy { get; }
      public UserEntitlement RequestedFor { get; }
      public DateTime CreatedOn { get; set; }
      public ReleaseDefinition ReleaseDefinition { get; }
      //public IList<Environment> Environments { get; }
      public object Environments { get; set; }

      public Release(PSObject obj, IPowerShell powerShell, string projectName) :
         base(obj, obj.GetValue("name"), "Release", powerShell, projectName)
      {
         this.CreatedBy = new UserEntitlement(obj.GetValue<PSObject>("createdBy"), projectName);
         this.ModifiedBy = new UserEntitlement(obj.GetValue<PSObject>("modifiedBy"), projectName);
         this.RequestedFor = new UserEntitlement(obj.GetValue<PSObject>("RequestedFor"), projectName);

         this.ReleaseDefinition = new ReleaseDefinition(obj.GetValue<PSObject>("releaseDefinition"), projectName);
      }

      [ExcludeFromCodeCoverage]
      public Release(PSObject obj, string projectName) :
         this(obj, new PowerShellWrapper(RunspaceMode.CurrentRunspace), projectName)
      {
      }

      protected override object[] GetChildren()
      {
         var children = this.GetPSObjects().Select(c => new Environment(c.GetValue("name"),
                                           c.GetValue("status"),
                                           this.ProjectName,
                                           this.Id,
                                           c.GetValue<long>("id")));

         // This applies types to select correct formatter.
         return children.AddTypeName("Team.Provider.Environment");
      }

      protected override IEnumerable<PSObject> GetPSObjects()
      {
         this.PowerShell.Commands.Clear();

         var children = this.PowerShell.Create(RunspaceMode.CurrentRunspace)
                                       .AddCommand(this.Command)
                                       .AddParameter("ProjectName", this.ProjectName)
                                       .AddParameter("Id", this.Id)
                                       .AddParameter("Expand", "Environments")
                                       .AddCommand("Select-Object")
                                       .AddParameter("ExpandProperty", "Environments")
                                       .Invoke();

         PowerShellWrapper.LogPowerShellError(this.PowerShell, children);

         return children;
      }
   }
}
