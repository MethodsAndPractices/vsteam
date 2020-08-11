using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class AgentPool : Directory
   {
      public AgentPool(string name, IPowerShell powerShell) : base(name, null, null, powerShell, null)
      {
      }

      public AgentPool(PSObject obj) : this(obj.GetValue<string>("name"), new PowerShellWrapper(RunspaceMode.CurrentRunspace))
      {
         this.Id = obj.GetValue<long>("id");
         this.Count = obj.GetValue<long>("size");
         this.IsHosted = obj.GetValue<bool>("isHosted");

         if (this.IsHosted)
         {
            this.DisplayMode = "d-r-s-";
         }
      }

      /// <summary>
      /// The id of the agent pool. This can be used to find and return
      /// this item.
      /// </summary>
      public long Id { get; }

      /// <summary>
      /// True when this is a hosted pool managed by Azure DevOps
      /// </summary>
      public bool IsHosted { get; }

      /// <summary>
      ///  The number of agents in the pool
      /// </summary>
      public long Count { get; }

      protected override object[] GetChildren()
      {
         this.PowerShell.Commands.Clear();

         var children = this.PowerShell.AddCommand("Get-VSTeamAgent")
                                       .AddParameter("PoolId", this.Id)
                                       .Invoke();

         // This is important so the correct formatting is applied
         foreach (var child in children)
         {
            child.AddTypeName("Team.Provider.Agent");
         }

         return children.ToArray();
      }
   }
}
