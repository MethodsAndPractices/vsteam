using System.Management.Automation;
using System.Xml.Serialization;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Link : IInternalObject
   {
      [XmlAttribute("_links.self.href")]
      public string Self { get; set; }

      [XmlAttribute("_links.parent.href")]
      public string Parent { get; set; }

      [XmlAttribute("_links.memberships.href")]
      public string Memberships { get; set; }

      [XmlAttribute("_links.membershipState.href")]
      public string MembershipState { get; set; }

      [XmlAttribute("_links.storageKey.href")]
      public string StorageKey { get; set; }

      [XmlAttribute("_links.avatar.href")]
      public string Avatar { get; set; }

      [XmlAttribute("_links.web.href")]
      public string Web { get; set; }

      [XmlAttribute("_links.subject.href")]
      public string Subject { get; set; }

      public PSObject InternalObject { get; }

      public Link(PSObject obj)
      {
         this.InternalObject = obj;

         Common.MoveProperties(this, obj);
      }
   }
}
