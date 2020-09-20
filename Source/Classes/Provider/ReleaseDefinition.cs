using System;
using System.Collections.Generic;
using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class ReleaseDefinition : Leaf
   {
      public string Url { get; set; }
      public string Path { get; set; }
      public long Revision { get; set; }
      public IList<string> Tags { get; }
      public string Description { get; set; }
      public bool IsDeleted { get; set; }
      public IList<object> Triggers { get; set; }
      public object Artifacts { get; set; }
      public object Variables { get; set; }
      public object Properties { get; set; }
      public object Environments { get; set; }
      public object VariableGroups { get; set; }
      public string ReleaseNameFormat { get; set; }
      public DateTime CreatedOn { get; set; }
      public DateTime ModifiedOn { get; set; }
      public User CreatedBy { get; }
      public User ModifiedBy { get; }
      public Link Links { get; }
      /// <summary>
      /// Used to pass on pipeline to Get-VSTeamPermissionInheritance
      /// </summary>
      public string ResourceType => "ReleaseDefinition";
      /// <summary>
      /// Before this class was added to the provider there
      /// was a type file to expose createdByUser. The type
      /// was deleted when this class was added. So this
      /// property is for backwards compatibility.
      /// </summary>
      public string CreatedByUser => this.CreatedBy.DisplayName;

      public ReleaseDefinition(PSObject obj, string projectName) :
         base(obj, obj.GetValue("name"), obj.GetValue("id"), projectName)
      {
         this.Links = new Link(obj);
         this.Tags = obj.GetStringArray("tags");

         // These may not be present when nested in a release
         if (obj.HasValue("createdBy"))
         {
            this.CreatedBy = new User(obj.GetValue<PSObject>("createdBy"));
         }

         if (obj.HasValue("modifiedBy"))
         {
            this.ModifiedBy = new User(obj.GetValue<PSObject>("modifiedBy"));
         }
      }
   }
}
