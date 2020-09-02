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
   public class ReleaseDefinitionCompleterTests
   {
      private readonly Collection<string> _releases = new Collection<string>() { "Item1", "Item 2" };

      [TestMethod]
      public void ReleaseDefinitionCompleter_GetValues()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._releases);

         var target = new ReleaseDefinitionCompleter(ps);
         var fakeBoundParameters = new Dictionary<string, string>
         {
            { "ProjectName", "UnitTestProject" }
         };

         // Act
         var actual = target.CompleteArgument("Add-VSTeamBuild", "BuildDefinition", "", null, fakeBoundParameters);

         // Assert
         Assert.AreEqual(2, actual.Count());
      }
   }
}
