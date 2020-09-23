using System;
using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class GitUserDate : Leaf
   {
      public string Email { get; set; }
      public DateTime Date { get; set; }

      public GitUserDate(PSObject obj, string projectname) :
         base(obj, obj.GetValue("email"), obj.GetValue("email"), projectname)
      {
      }
   }
}
