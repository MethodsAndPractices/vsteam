using System.Management.Automation;

namespace vsteam_lib
{
   public class Group : SecurityLeaf
   {
      public string Description { get; set; }

      /// <summary>
      /// Used to pass down pipelines
      /// </summary>
      public string ContainerDescriptor => this.Descriptor;

      public Group(PSObject obj) :
         base(obj)
      {
         this.ProjectName = this.PrincipalName.Split('\\')[0].Replace("[", string.Empty).Replace("]", string.Empty);
      }
   }
}
