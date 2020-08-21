using System.Collections;
using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class AccessControlList : Leaf
   {
      public string Token { get; set; }
      public bool InheritPermissions { get; set; }
      public Hashtable Aces { get; }

      public AccessControlList(PSObject obj) :
         base(obj, obj.GetValue("token"), obj.GetValue("token"), null)
      {
         this.Aces = new Hashtable();

         var props = ((PSObject)obj.Members["acesDictionary"].Value).Properties;

         foreach (var prop in props)
         {
            var entry = new AccessControlEntry((PSObject)prop.Value);
            this.Aces.Add(entry.Descriptor, entry);
         }
      }

      public override string ToString() => this.Token;
   }
}
