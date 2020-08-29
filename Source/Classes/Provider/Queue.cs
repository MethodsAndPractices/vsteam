using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using System.Xml.Serialization;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Queue : Leaf
   {
      public AgentPool Pool { get; }

      [XmlAttribute("pool.name")]
      public string PoolName { get; set; }

      public Queue(PSObject obj, string projectName, IPowerShell powerShell) : 
         base(obj, obj.GetValue("name"), obj.GetValue("id"), projectName)
      {
         this.Pool = new AgentPool(obj.GetValue<PSObject>("pool"), powerShell);
      }

      [ExcludeFromCodeCoverage]
      public Queue(PSObject obj, string projectName) : 
         this(obj, projectName, new PowerShellWrapper(RunspaceMode.CurrentRunspace))
      {
      }
   }
}
