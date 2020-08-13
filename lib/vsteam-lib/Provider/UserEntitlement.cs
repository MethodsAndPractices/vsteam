using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class UserEntitlement : Leaf
   {
      public string UniqueName { get; }
      public string DisplayName { get; }

      public UserEntitlement(PSObject obj, string projectName) : 
         base(obj, null, null, projectName)
      {
         this.UniqueName = obj.GetValue<string>("uniqueName");
         this.DisplayName = obj.GetValue<string>("displayName");
      }

      public override string ToString() => this.DisplayName;
   }
}
