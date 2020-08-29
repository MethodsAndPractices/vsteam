using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Extension : Leaf
   {
      public string Version { get; set; }
      public string ExtensionId { get; set; }
      public string PublisherId { get; set; }
      public string PublisherName { get; set; }
      public InstallState InstallState { get; }

      public Extension(PSObject obj) :
         base(obj, obj.GetValue("extensionName"), obj.GetValue("extensionId"), null)
      {
         this.InstallState = new InstallState(obj.GetValue<PSObject>("installState"));
      }
   }
}
