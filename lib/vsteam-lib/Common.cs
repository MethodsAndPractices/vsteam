using System.Management.Automation.Abstractions;

namespace vsteam_lib
{
   public static class Common
   {
      public static string GetDefaultProject(IPowerShell powerShell)
      {
         powerShell.Commands.Clear();
         return powerShell.AddScript("$Global:PSDefaultParameterValues[\"*-vsteam*:projectName\"]").Invoke<string>()[0];
      }
   }
}
