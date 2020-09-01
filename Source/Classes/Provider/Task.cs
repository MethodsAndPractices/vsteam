using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Task : Leaf
   {
      public string LogUrl { get; set; }
      public string Status { get; set; }
      public string AgentName { get; set; }

      public Task(PSObject obj, string projectName) :
         base(obj, obj.GetValue("name"), obj.GetValue("id"), projectName)
      {
      }
   }
}
