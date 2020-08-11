using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using System.Text;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Agent : Directory
   {
      public Agent(string name, IPowerShell powerShell) : base(name, null, null, powerShell, null)
      {
      }

      public Agent(PSObject obj, long poolId) : this(obj.GetValue<string>("name"), new PowerShellWrapper(RunspaceMode.CurrentRunspace))
      {
         this.PoolId = poolId;
         this.AgentId = obj.GetValue<long>("Id");
         this.Status = obj.GetValue<string>("status");
         this.Enabled = obj.GetValue<bool>("enabled");
         this.Version = obj.GetValue<string>("version");
         this.OS = obj.GetValue<string>("osDescription");
         this.SystemCapabilities = obj.GetValue<PSObject>("systemCapabilities");

         this.InternalObject = obj;
      }

      public long PoolId { get; }
      public long AgentId { get; }
      public string Status { get; }
      public bool Enabled { get; }
      public string Version { get; }
      public string OS { get; }
      public PSObject SystemCapabilities { get; }

      protected override object[] GetChildren()
      {
         this.PowerShell.Commands.Clear();

         var children = this.PowerShell.AddCommand("Get-VSTeamJobRequest")
                                       .AddParameter("PoolId", this.PoolId)
                                       .AddParameter("AgentId", this.AgentId)
                                       .Invoke();

         PowerShellWrapper.LogPowerShellError(this.PowerShell, children);

         return children.ToArray();
      }
   }
}
