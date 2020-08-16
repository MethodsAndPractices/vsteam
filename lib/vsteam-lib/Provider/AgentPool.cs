using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using System.Xml.Serialization;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class AgentPool : Directory
   {
      /// <summary>
      /// The id of the agent pool. This can be used to find and return
      /// this item.
      /// </summary>
      public long Id { get; set; }

      /// <summary>
      ///  The number of agents in the pool
      /// </summary>
      [XmlAttribute("size")]
      public long Count { get; set; }

      /// <summary>
      /// True when this is a hosted pool managed by Azure DevOps
      /// </summary>
      public bool IsHosted { get; set; }

      public AgentPool(PSObject obj, IPowerShell powerShell) :
         base(obj, obj.GetValue("name"), "Agent", powerShell, null)
      {
         Common.MoveProperties(this, obj);

         if (this.IsHosted)
         {
            this.DisplayMode = "d-r-s-";
         };
      }

      [ExcludeFromCodeCoverage]
      public AgentPool(PSObject obj) :
         this(obj, new PowerShellWrapper(RunspaceMode.CurrentRunspace))
      {
      }

      protected override object[] GetChildren()
      {
         this.PowerShell.Commands.Clear();

         var children = this.PowerShell.AddCommand(this.Command)
                                       .AddParameter("PoolId", this.Id)
                                       .Invoke();

         // This is important so the correct formatting is applied
         foreach (var child in children)
         {
            child.AddTypeName(this.TypeName);
         }

         return children.ToArray();
      }
   }
}
