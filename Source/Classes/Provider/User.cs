using System.Management.Automation;

namespace vsteam_lib
{
   public class User : SecurityLeaf
   {
      public string MetaType { get; set; }

      /// <summary>
      /// Used to pass down pipelines
      /// </summary>
      public string MemberDescriptor => this.Descriptor;

      public User(PSObject obj) : base(obj)
      {
      }
   }
}
