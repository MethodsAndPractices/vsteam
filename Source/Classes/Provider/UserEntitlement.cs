using System;
using System.Management.Automation;
using System.Xml.Serialization;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class UserEntitlement : Leaf
   {
      public string UniqueName => this.User.UniqueName;
      
      public string DisplayName => this.User.DisplayName;
      
      public string Email => this.User.MailAddress;
      
      public string UserName => this.User.DisplayName;
      
      [XmlAttribute("accessLevel.licenseDisplayName")]
      public string AccessLevelName { get; set; }

      public DateTime LastAccessedDate { get; set; }

      public User User { get; }

      public UserEntitlement(PSObject obj, string projectName) : 
         base(obj, null, obj.GetValue("id"), projectName)
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
