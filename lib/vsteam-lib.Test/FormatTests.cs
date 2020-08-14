using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Text;

namespace vsteam_lib.Test
{
   [TestClass]
   public class FormatTests
   {
      [TestMethod]
      public void MyTestMethod()
      {
         //var ss = InitialSessionState.CreateDefault2();
         //ss.ExecutionPolicy = Microsoft.PowerShell.ExecutionPolicy.Bypass;
         //var pwsh = PowerShell.Create(ss);
         //pwsh.Runspace.SessionStateProxy.SetVariable("InformationPreference", "Continue");

         //var results = pwsh.AddCommand("import-module")
         //    .AddArgument("..\\..\\..\\..\\..\\dist\\vsteam.psd1")
         //    .AddParameter("verbose").Invoke();

         //results = pwsh.AddScript("Set-VSTeamAccount -profile blackshirt")
         //    .AddParameter("Profile", "blackshirt")
         //    .AddParameter("Drive", "b")
         //    .AddCommand("iex")
         //    .Invoke();

         //results = pwsh.AddScript("Get-ChildItem b: > test.output")
         //    .Invoke();

         ////results = pwsh.AddCommand("Get-ChildItem")
         ////   .AddArgument("b:")
         ////   .AddArgument(">")
         ////   .AddArgument("test.ouput")
         ////    .Invoke();

         //foreach (var item in pwsh.Streams.Information.ReadAll())
         //{
         //   System.Diagnostics.Debug.WriteLine(item);
         //}
      }
   }
}
