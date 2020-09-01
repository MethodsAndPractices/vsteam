using NSubstitute;
using NSubstitute.Extensions;
using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Management.Automation.Abstractions;

namespace vsteam_lib.Test
{
   [ExcludeFromCodeCoverage]
   internal class BaseTests
   {
      internal static IPowerShell PrepPowerShell()
      {
         var ps = Substitute.For<IPowerShell>();
         ps.ReturnsForAll(ps);
         ps.Commands.Returns(new PSCommand());
         return ps;
      }

      internal static Collection<PSObject> LoadJson(string file, bool selectValue = true)
      {
         var fullPath = $"../../../../SampleFiles/{file}";
         var contents = System.IO.File.ReadAllText(fullPath);

         var cmdlet = PowerShell.Create().AddCommand("ConvertFrom-Json")
                                         .AddParameter("InputObject", contents)
                                         .AddParameter("Depth", 100);

         if (selectValue)
         {
            cmdlet.AddCommand("Select-Object")
                  .AddParameter("ExpandProperty", "value");
         }

         return cmdlet.Invoke();
      }
   }
}
