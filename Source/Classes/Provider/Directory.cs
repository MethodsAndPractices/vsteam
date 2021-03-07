using Microsoft.PowerShell.SHiPS;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Abstractions;

namespace vsteam_lib.Provider
{
   public class Directory : SHiPSDirectory, IInternalObject
   {
      private string _typeName;
      public string ProjectName { get; protected set; }
      public PSObject InternalObject { get; }
      protected IPowerShell PowerShell { get; }

      /// <summary>
      /// I want the mode to resemble that of
      /// a normal file system.
      /// d - Directory
      /// a - Archive
      /// r - Read-only
      /// h - Hidden
      /// s - System
      /// l - Reparse point, symlink, etc.
      /// </summary>
      public string DisplayMode { get; set; } = "d-----";

      /// <summary>
      /// The name of the command to execute to get the list of
      /// child items.
      /// </summary>
      public string Command => ("Team" == this._typeName) ? "Get-VSTeam" : $"Get-VSTeam{this._typeName}";

      /// <summary>
      /// The type to insert into the type names so the correct format
      /// is selected to display on screen.
      /// </summary>
      public string TypeName
      {
         get => $"vsteam_lib.Provider.{this._typeName}";
         set => this._typeName = value;
      }

      /// <summary>
      /// This version is for use with Unit tests and called by all other
      /// constructors
      /// </summary>
      /// <param name="obj">PowerShell object returned by REST Call</param>
      /// <param name="name">The name displayed by provider</param>
      /// <param name="typeName">The noun of the type to be applied to the child items</param>
      /// <param name="powerShell">The PowerShell to use when calling other cmdlets</param>
      /// <param name="projectName">The name of the project used to query the child items</param>
      public Directory(PSObject obj, string name, string typeName, IPowerShell powerShell, string projectName) :
         base(name)
      {
         Common.MoveProperties(this, obj);

         this.TypeName = typeName;
         this.InternalObject = obj;
         this.PowerShell = powerShell;
         this.ProjectName = projectName;
      }

      /// <summary>
      /// This version is for use in classes still in PowerShell
      /// </summary>
      /// <param name="name">The name displayed by provider</param>
      /// <param name="typeName">The noun of the type to be applied to the child items</param>
      [ExcludeFromCodeCoverage]
      public Directory(string name, string typeName, string projectName) :
        this(null, name, typeName, new PowerShellWrapper(RunspaceMode.CurrentRunspace), projectName)
      {
      }

      /// <summary>
      /// This version is for use when no Project name is required
      /// </summary>
      /// <param name="name">The name displayed by provider</param>
      /// <param name="typeName">The noun of the type to be applied to the child items</param>
      /// <param name="powerShell">The PowerShell to use when calling other cmdlets</param>
      public Directory(string name, string typeName, IPowerShell powerShell) :
         this(null, name, typeName, powerShell, null)
      {
         this.DisplayMode = "d-r-s-";
      }

      public override object[] GetChildItem() => this.GetChildren();

      protected virtual object[] GetChildren() => this.GetPSObjects().ToArray();

      protected virtual IEnumerable<PSObject> GetPSObjects()
      {
         this.PowerShell.Commands.Clear();

         var cmd = this.PowerShell.AddCommand(this.Command);

         if (!string.IsNullOrEmpty(this.ProjectName))
         {
            cmd = cmd.AddParameter("ProjectName", this.ProjectName);
         }

         var children = cmd.AddCommand("Sort-Object")
                           .AddArgument("name")
                           .Invoke();

         PowerShellWrapper.LogPowerShellError(this.PowerShell, children);

         // This applies types to select correct formatter.
         return children.AddTypeName(this.TypeName);
      }
   }
}
