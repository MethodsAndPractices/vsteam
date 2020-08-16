using System.Collections.Generic;
using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Feed : Leaf
   {
      public string Url { get; }
      public string Description { get; }
      public bool? UpstreamEnabled { get; }
      public IList<UpstreamSource> UpstreamSources { get; }

      public Feed(PSObject obj) :
         base(obj, obj.GetValue("name"), obj.GetValue("id"), null)
      {
         this.Url = obj.GetValue("url");
         this.Description = obj.GetValue("description");
         this.UpstreamEnabled = obj.GetValue<bool?>("upstreamEnabled");

         var sources = new List<UpstreamSource>();
         foreach (PSObject item in ((object[])obj.Properties["upstreamSources"].Value))
         {
            sources.Add(new UpstreamSource(item));
         }

         this.UpstreamSources = sources;
      }
   }
}
