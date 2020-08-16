using System;
using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class InstallState : IInternalObject
   {
      public string Flags { get; }
      public DateTime LastUpdated { get; }
      public PSObject InternalObject { get; set; }

      public InstallState(PSObject obj)
      {
         this.InternalObject = obj;
         this.Flags = obj.GetValue("flags");
         this.LastUpdated = obj.GetValue<DateTime>("lastUpdated");
      }

      public override string ToString() => $"Flags: {this.Flags}, Last Updated: {this.LastUpdated}";
   }
}
