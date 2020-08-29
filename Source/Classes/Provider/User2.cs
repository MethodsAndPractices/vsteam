using System.Management.Automation;

namespace vsteam_lib
{
   public class User2 : SecurityLeaf
   {
      public string MetaType { get; set; }

      public User2(PSObject obj) : base(obj)
      {
      }
   }
}
