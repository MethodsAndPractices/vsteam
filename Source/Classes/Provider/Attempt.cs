using System.Collections.Generic;
using System.Management.Automation;
using System.Xml.Serialization;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Attempt : Directory
   {
      public long Id { get; set; }
      public string Status { get; set; }
      [XmlAttribute("attempt")]
      public long AttemptNo { get; set; }
      public IList<Task> Tasks { get; }

      public Attempt(PSObject obj, string projectName) :
         base(obj, $"Attempt {obj.GetValue("attempt")}", "Task", null, projectName)
      {
         this.Tasks = new List<Task>();
         var phases = obj.GetValue<object[]>("releaseDeployPhases");

         if (phases.Length > 0)
         {
            var jobs = ((PSObject)phases[0]).GetValue<object[]>("deploymentJobs");

            if (jobs.Length > 0)
            {
               foreach (var item in ((PSObject)jobs[0]).GetValue<object[]>("tasks"))
               {
                  this.Tasks.Add(new Task((PSObject)item, this.ProjectName));
               }
            }
         }
      }

      /// <summary>
      /// Return the list with the correct type applied for formatting. 
      /// </summary>
      /// <returns></returns>
      protected override object[] GetChildren() => this.Tasks.AddTypeName(this.TypeName);
   }
}
