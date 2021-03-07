using System;
using System.Collections.Generic;
using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class ClassificationNode : Leaf
   {
      public Link Links { get; }
      public string Url { get; set; }
      public string Path { get; set; }
      public Guid Identifier { get; set; }
      public bool HasChildren { get; set; }
      public string StructureType { get; set; }
      public string ParentUrl => this.Links?.Parent;
      public IList<ClassificationNode> Children { get; }
      public int NodeId => int.Parse(this.Id);

      public ClassificationNode(PSObject obj, string projectName) :
         base(obj, obj.GetValue("name"), obj.GetValue("id"), projectName)
      {
         if (obj.HasValue("_links"))
         {
            this.Links = new Link(obj);
         }

         if (obj.HasValue("children"))
         {
            this.Children = new List<ClassificationNode>();

            foreach (var item in obj.GetValue<object[]>("children"))
            {
               this.Children.Add(new ClassificationNode((PSObject)item, this.ProjectName));
            }
         }
      }
   }
}
