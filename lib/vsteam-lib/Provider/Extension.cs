using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Extension : Leaf
   {
      public string Version { get; }
      public string ExtensionId { get; }
      public string PublisherId { get; }
      public string PublisherName { get; }
      public InstallState InstallState { get; }

      public Extension(PSObject obj) :
         base(obj, obj.GetValue("extensionName"), obj.GetValue("extensionId"), null)
      {
         this.Version = obj.GetValue("version");
         this.ExtensionId = obj.GetValue("extensionId");
         this.PublisherId = obj.GetValue("publisherId");
         this.PublisherName = obj.GetValue("publisherName");
         this.InstallState = new InstallState(obj.GetValue<PSObject>("installState"));
      }
   }
}
