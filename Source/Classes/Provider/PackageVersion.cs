using System;
using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class PackageVersion : Leaf
   {
      public string Url { get; set; }
      public bool IsLatest { get; set; }
      public bool IsListed { get; set; }
      public string Version { get; set; }
      public string Author { get; set; }
      public string Description { get; set; }
      public DateTime PublishDate { get; set; }

      public PackageVersion(PSObject obj) :
         base(obj, obj.GetValue("version"), obj.GetValue("id"), null)
      {
      }
   }
}
