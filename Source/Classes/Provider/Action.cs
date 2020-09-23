using System;
using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Action : Leaf
   {
      public long Bit { get; set; }
      public Guid NamespaceId { get; set; }
      public string DisplayName { get; set; }

      public Action(PSObject obj) :
         base(obj, obj.GetValue("name"), obj.GetValue("bit").ToString(), null)
      {
      }
   }
}
