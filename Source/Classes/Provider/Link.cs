using System.Management.Automation;
using System.Text;
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

      public override string ToString()
      {
         var sb = new StringBuilder();

         AddLink(sb, nameof(this.Self), this.Self);
         AddLink(sb, nameof(this.Parent), this.Parent);
         AddLink(sb, nameof(this.MembershipState), this.MembershipState);
         AddLink(sb, nameof(this.StorageKey), this.StorageKey);
         AddLink(sb, nameof(this.Avatar), this.Avatar);
         AddLink(sb, nameof(this.Web), this.Web);
         AddLink(sb, nameof(this.Subject), this.Subject);

         return sb.ToString();
      }

      private void AddLink(StringBuilder sb, string name, string value)
      {
         if(!string.IsNullOrEmpty(value))
         {
            sb.AppendLine($"{name}: {value}");
         }
      }
   }
}
