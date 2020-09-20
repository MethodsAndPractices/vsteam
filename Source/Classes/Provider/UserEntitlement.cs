using System.Management.Automation;
using System.Xml.Serialization;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class UserEntitlement : Leaf
   {
      public string UniqueName { get; set; }
      public string DisplayName { get; set; }
      [XmlAttribute("user.mailAddress")]
      public string Email { get; set; }
      [XmlAttribute("user.displayName")]
      public string UserName { get; set; }
      [XmlAttribute("accessLevel.licenseDisplayName")]
      public string AccessLevelName { get; set; }
      public User User { get; }

      public UserEntitlement(PSObject obj, string projectName) : 
         base(obj, null, null, projectName)
      {
         this.User = new User(obj.GetValue<PSObject>("user"));
      }

      public UserEntitlement(PSObject obj) :
         this(obj, null)
      {
      }

      public override string ToString() => this.DisplayName;
   }
}
