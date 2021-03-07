using System.Management.Automation;
using System.Xml.Serialization;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class GitRef : Leaf
   {
      /// The name passed to the base class is changed. For example if you pass
      /// refs/heads/appcenter as the name it is converted into refs-heads-appcenter.
      /// So I store it twice so I have the original value as well.
      [XmlAttribute("name")]
      public string RefName { get; set; }
      public User Creator { get; }

      public GitRef(PSObject obj, string projectName) :
         base(obj, obj.GetValue("name"), obj.GetValue("objectId"), projectName)
      {
         this.Creator = new User(obj.GetValue<PSObject>("creator"));
      }
   }
}
