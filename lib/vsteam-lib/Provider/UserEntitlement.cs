using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class UserEntitlement : Leaf
   {
      public UserEntitlement(PSObject obj) : base(obj, null, null, null)
      {

      }
   }
}
