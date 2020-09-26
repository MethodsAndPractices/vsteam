using System.Collections.Generic;
using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Feed : Leaf
   {
      public string Url { get; set; }
      public string FeedId => this.Id;
      public string Description { get; set; }
      public bool? UpstreamEnabled { get; set; }
      public IList<UpstreamSource> UpstreamSources { get; }

      public Feed(PSObject obj) :
         base(obj, obj.GetValue("name"), obj.GetValue("id"), null)
      {
         var sources = new List<UpstreamSource>();
         foreach (PSObject item in ((object[])obj.Properties["upstreamSources"].Value))
         {
            sources.Add(new UpstreamSource(item));
         }

         this.UpstreamSources = sources;
      }
   }
}
