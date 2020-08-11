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

      public Directory(string name, string command, string typeName, IPowerShell powerShell, string projectName) : base(name)
      {
         this.Command = command;
         this.TypeName = typeName;
         this.PowerShell = powerShell;
         this.ProjectName = projectName;
      }

      public override object[] GetChildItem() => this.GetChildren();

      protected virtual object[] GetChildren()
      {
         
         this.PowerShell.Commands.Clear();

         var children = this.PowerShell.Create(RunspaceMode.CurrentRunspace)
                                       .AddCommand(this.Command)
                                       .AddCommand("Sort-Object")
                                       .AddArgument("name")
                                       .Invoke();

         foreach (var child in children)
         {
            child.TypeNames.Insert(0, this.TypeName);
         }

         return children.ToArray();
      }
   }
}
