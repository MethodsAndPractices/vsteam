using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Descriptor : Leaf
   {
      public Link Links { get; }

      public Descriptor(PSObject obj) :
         base(obj, obj.GetValue("value"), obj.GetValue("value"), null)
      {
         if (obj.HasValue("_links"))
         {
            this.Links = new Link(obj);
         }
      }

      public override string ToString() => base.Name;
   }
}
