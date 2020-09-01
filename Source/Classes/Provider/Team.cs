using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Team : Leaf
   {
      public string Description { get; set; }

      public Team(PSObject obj, string projectName) :
         base(obj, obj.GetValue("name"), obj.GetValue("id"), projectName)
      {
      }
   }
}
