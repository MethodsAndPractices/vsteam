using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Group : Leaf
   {
      public Link Links { get; }
      public string Url { get; set; }
      public string Domain { get; set; }
      public string Origin { get; set; }
      public string OriginId { get; set; }
      public string Descriptor { get; set; }
      public string SubjectKind { get; set; }
      public string Description { get; set; }
      public string DisplayName { get; set; }
      public string MailAddress { get; set; }
      public string PrincipalName { get; set; }

      public Group(PSObject obj) :
         base(obj, obj.GetValue("displayName"), obj.GetValue("descriptor"), null)
      {
         Common.MoveProperties(this, obj);
         
         this.Links = new Link(obj);
         this.ProjectName = this.PrincipalName.Split('\\')[0].Replace("[", string.Empty).Replace("]", string.Empty);
      }
   }
}
