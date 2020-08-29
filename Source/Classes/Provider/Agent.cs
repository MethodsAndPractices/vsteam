using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using System.Xml.Serialization;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Agent : Directory
   {
      [XmlAttribute("osDescription")]
      public string OS { get; set; }
      public long PoolId { get; set; }
      public bool Enabled { get; set; }
      [XmlAttribute("id")]
      public long AgentId { get; set; }
      public string Status { get; set; }
      public string Version { get; set; }
      public PSObject SystemCapabilities { get; set; }

      public Agent(PSObject obj, long poolId, IPowerShell powerShell) :
         base(obj, obj.GetValue("name"), "JobRequest", powerShell, null)
      {
         this.PoolId = poolId;
      }

      [ExcludeFromCodeCoverage]
      public Agent(PSObject obj, long poolId) :
         this(obj, poolId, new PowerShellWrapper(RunspaceMode.CurrentRunspace))
      {
      }

      protected override object[] GetChildren()
      {
         this.PowerShell.Commands.Clear();

         var children = this.PowerShell.AddCommand(this.Command)
                                       .AddParameter("PoolId", this.PoolId)
                                       .AddParameter("AgentId", this.AgentId)
                                       .Invoke();

         PowerShellWrapper.LogPowerShellError(this.PowerShell, children);

         return children.AddTypeName(this.TypeName);
      }
   }
}
