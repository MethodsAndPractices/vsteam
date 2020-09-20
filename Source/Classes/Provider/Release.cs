using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Release : Directory
   {
      public long Id { get; set; }
      public string Status { get; set; }
      public User CreatedBy { get; }
      public User ModifiedBy { get; }
      public DateTime CreatedOn { get; set; }
      public ReleaseDefinition ReleaseDefinition { get; }
      public List<PSObject> Environments { get; private set; }
      public object Variables { get; set; }
      public Project Project { get; }

      // Properties below were in the old type file and are
      // here to break as little as possible for those that
      // upgrade.
      public long ReleaseId => this.Id;
      public string ProjectId => this.Project.Id;
      public string DefinitionId => this.ReleaseDefinition.Id;
      public string CreatedByUser => this.CreatedBy.DisplayName;
      public string DefinitionName => this.ReleaseDefinition.Name;
      public string ModifiedByUser => this.ModifiedBy.DisplayName;

      public Release(PSObject obj, IPowerShell powerShell, string projectName) :
         base(obj, obj.GetValue("name"), "Release", powerShell, projectName)
      {
         this.CreatedBy = new User(obj.GetValue<PSObject>("createdBy"));
         this.ModifiedBy = new User(obj.GetValue<PSObject>("modifiedBy"));

         this.Project = new Project(obj.GetValue<PSObject>("projectReference"), powerShell);

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
               this.Environments.Add(PSObject.AsPSObject(new Environment((PSObject)item, this.Id, this.ProjectName, this.PowerShell)));
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
         return children.AddTypeName("vsteam_lib.Provider.Environment");
      }
   }
}
