using System.Collections;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using System.Management.Automation.Language;

namespace vsteam_lib
{
   public class InvokeCompleter : BaseCompleter
   {
      /// <summary>
      /// This constructor is used when running in a PowerShell session. It cannot be
      /// loaded in a unit test.
      /// </summary>
      [ExcludeFromCodeCoverage]
      public InvokeCompleter() : base() { }

      /// <summary>
      /// This constructor is used during unit testings
      /// </summary>
      /// <param name="powerShell">fake instance of IPowerShell used for testing</param>
      public InvokeCompleter(IPowerShell powerShell) : base(powerShell) { }

      public override IEnumerable<CompletionResult> CompleteArgument(string commandName,
                                                                     string parameterName,
                                                                     string wordToComplete,
                                                                     CommandAst commandAst,
                                                                     IDictionary fakeBoundParameters)
      {
         var values = new List<CompletionResult>();

         // If the user has explicitly added the -subDomain parameter
         // to the command use that to filter the results.
         var subDomain = fakeBoundParameters["subDomain"]?.ToString();

         // To complete resources you have to provide the area first
         var area = fakeBoundParameters["area"]?.ToString();

         var spat = new Dictionary<string, string>();

         if (!string.IsNullOrEmpty(subDomain))
         {
            spat.Add("subDomain", subDomain);
         }

         this._powerShell.Commands.Clear();

         if (string.Compare(parameterName, "Area", true) == 0)
         {
            var areas = this._powerShell.AddCommand("Get-VSTeamOption")
                                        .AddParameters(spat)
                                        .AddCommand("Select-Object")
                                        .AddParameter("ExpandProperty", "Area")
                                        .AddParameter("Unique")
                                        .AddCommand("Sort-Object")
                                        .Invoke<string>();

            PowerShellWrapper.LogPowerShellError(this._powerShell, areas);

            SelectValues(wordToComplete, areas, values);
         }
         else if (!string.IsNullOrEmpty(area))
         {
            var resources = this._powerShell.AddCommand("Get-VSTeamOption")
                                            .AddParameters(spat)
                                            .AddCommand("Where-Object")
                                            .AddParameter("Property", "area")
                                            .AddParameter("-EQ")
                                            .AddParameter("Value", area)
                                            .AddCommand("Select-Object")
                                            .AddParameter("ExpandProperty", "ResourceName")
                                            .AddParameter("Unique")
                                            .AddCommand("Sort-Object")
                                            .Invoke<string>();

            PowerShellWrapper.LogPowerShellError(this._powerShell, resources);

            SelectValues(wordToComplete, resources, values);
         }

         return values;
      }
   }
}
