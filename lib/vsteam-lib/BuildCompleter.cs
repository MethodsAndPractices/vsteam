using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation.Abstractions;

namespace vsteam_lib
{
   public class BuildCompleter : BaseProjectCompleter
   {
      /// <summary>
      /// This constructor is used when running in a PowerShell session. It cannot be
      /// loaded in a unit test.
      /// </summary>
      [ExcludeFromCodeCoverage]
      public BuildCompleter() : base() { }

      /// <summary>
      /// This constructor is used during unit testings
      /// </summary>
      /// <param name="powerShell">fake instance of IPowerShell used for testing</param>
      internal BuildCompleter(IPowerShell powerShell) : base(powerShell) { }

      internal override IEnumerable<string> GetValues(string projectName)
      {
         this._powerShell.Commands.Clear();
         var results = this._powerShell.AddCommand("Get-VSTeamBuild")
                                       .AddParameter("ProjectName", projectName)
                                       .AddCommand("Select-Object")
                                       .AddParameter("ExpandProperty", "BuildNumber")
                                       .AddParameter("Unique")
                                       .AddCommand("Sort-Object")
                                       .AddParameter("Descending")
                                       .Invoke<string>();

         PowerShellWrapper.LogPowerShellError(this._powerShell, results);

         return results;
      }
   }
}
