using Microsoft.PowerShell.SHiPS;
using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Abstractions;

namespace vsteam_lib.Provider
{
   public class Directory : SHiPSDirectory
   {
      protected IPowerShell PowerShell { get; }

      protected string ProjectName { get; }

      public PSObject InternalObject { get; set; }

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
      public string Command { get; }

      /// <summary>
      /// The type to insert into the type names so the correct format
      /// is selected to display on screen.
      /// </summary>
      public string TypeName { get; }

      public Directory(PSObject obj, string name, string command, string typeName, IPowerShell powerShell, string projectName) :
         base(name)
      {
         this.Command = command;
         this.TypeName = typeName;
         this.InternalObject = obj;
         this.PowerShell = powerShell;
         this.ProjectName = projectName;
      }

      /// <summary>
      /// This version is for use in classes still in PowerShell
      /// </summary>
      /// <param name="name"></param>
      /// <param name="command"></param>
      /// <param name="typeName"></param>
      public Directory(string name, string command, string typeName, string projectName) :
        this(null, name, command, typeName, new PowerShellWrapper(RunspaceMode.CurrentRunspace), projectName)
      {
      }

      public Directory(string name, string command, string typeName, IPowerShell powerShell) :
         this(null, name, command, typeName, powerShell, null)
      {
         DisplayMode = "d-r-s-";
      }

      public override object[] GetChildItem() => this.GetChildren();

      protected virtual object[] GetChildren()
      {

         this.PowerShell.Commands.Clear();

         var cmd = this.PowerShell.Create(RunspaceMode.CurrentRunspace)
                       .AddCommand(this.Command);

         if (!string.IsNullOrEmpty(this.ProjectName))
         {
            cmd = cmd.AddParameter("ProjectName", this.ProjectName);
         }

         var children = cmd.AddCommand("Sort-Object")
                           .AddArgument("name")
                           .Invoke();

         PowerShellWrapper.LogPowerShellError(cmd, children);

         foreach (var child in children)
         {
            child.TypeNames.Insert(0, this.TypeName);
         }

         return children.ToArray();
      }
   }
}
