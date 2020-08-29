using System.Management.Automation;

namespace vsteam_lib
{
   public class Group : SecurityLeaf
   {
      public string Description { get; set; }

      public Group(PSObject obj) :
         base(obj)
      {
         this.ProjectName = this.PrincipalName.Split('\\')[0].Replace("[", string.Empty).Replace("]", string.Empty);
      }
   }
}
