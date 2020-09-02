using Microsoft.VisualStudio.TestTools.UnitTesting;
using NSubstitute;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;
using System.Linq;

namespace vsteam_lib.Test
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class InvokeCompleterTests
   {
      private readonly Collection<string> _resources = new Collection<string>() { "approvals" };
      private readonly Collection<string> _areas = new Collection<string>() { "approval", "release" };

      [TestMethod]
      public void InvokeCompleter_Get_Areas_With_SubDomain_And_Area()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._areas);

         var target = new InvokeCompleter(ps);
         var fakeBoundParameters = new Dictionary<string, string>();

         // Act
         var actual = target.CompleteArgument("Invoke-VSTeamRequest", "area", "", null, fakeBoundParameters);

         // Assert
         Assert.AreEqual(2, actual.Count());
      }

      [TestMethod]
      public void InvokeCompleter_Get_Resources_With_SubDomain_And_Area()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._resources);

         var target = new InvokeCompleter(ps);
         var fakeBoundParameters = new Dictionary<string, string>
         {
            { "area", "approval" },
            { "subDomain", "vsrm" }
         };

         // Act
         var actual = target.CompleteArgument("Invoke-VSTeamRequest", "resource", "", null, fakeBoundParameters);

         // Assert
         Assert.AreEqual(1, actual.Count());
      }
   }
}
