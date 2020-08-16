using System;
using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class InstallState : IInternalObject
   {
      public string Flags { get; set; }
      public DateTime LastUpdated { get; set; }
      public PSObject InternalObject { get; }

      public InstallState(PSObject obj)
      {
         this.InternalObject = obj;

         Common.MoveProperties(this, obj);
      }

      public override string ToString() => $"Flags: {this.Flags}, Last Updated: {this.LastUpdated}";
   }
}
