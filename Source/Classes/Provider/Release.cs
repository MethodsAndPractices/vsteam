using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
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
      public List<PSObject> Environments { get; private set; }
      public object Variables { get; set; }

      public Release(PSObject obj, IPowerShell powerShell, string projectName) :
         base(obj, obj.GetValue("name"), "Release", powerShell, projectName)
      {
         this.CreatedBy = new UserEntitlement(obj.GetValue<PSObject>("createdBy"), projectName);
         this.ModifiedBy = new UserEntitlement(obj.GetValue<PSObject>("modifiedBy"), projectName);
         this.RequestedFor = new UserEntitlement(obj.GetValue<PSObject>("RequestedFor"), projectName);

         this.PopulateEnvironments(obj);

         this.ReleaseDefinition = new ReleaseDefinition(obj.GetValue<PSObject>("releaseDefinition"), projectName);
      }

      [ExcludeFromCodeCoverage]
      public Release(PSObject obj, string projectName) :
         this(obj, new PowerShellWrapper(RunspaceMode.CurrentRunspace), projectName)
      {
      }

      private void PopulateEnvironments(PSObject obj)
      {
         this.Environments = new List<PSObject>();
         if (obj.HasValue("environments"))
         {
            foreach (var item in obj.GetValue<object[]>("environments"))
            {
               this.Environments.Add(PSObject.AsPSObject(new Environment((PSObject)item, this.Id, this.ProjectName)));
            }
         }
      }

      protected override object[] GetChildren()
      {
         this.Environments = new List<PSObject>(this.GetPSObjects());

         return this.Environments.ToArray();
      }

      protected override IEnumerable<PSObject> GetPSObjects()
      {
         this.PowerShell.Commands.Clear();

         // We have to call this again because the amount of data you get back when you pass in the
         // Id must greater than when you don't. 
         var children = this.PowerShell.AddCommand(this.Command)
                                       .AddParameter("ProjectName", this.ProjectName)
                                       .AddParameter("id", this.Id)
                                       .AddParameter("Expand", "Environments")
                                       .AddCommand("Select-Object")
                                       .AddParameter("ExpandProperty", "Environments")
                                       .Invoke();

         PowerShellWrapper.LogPowerShellError(this.PowerShell, children);

         // This applies types to select correct formatter.
         return children.AddTypeName("Team.Provider.Environment");
      }
   }
}
