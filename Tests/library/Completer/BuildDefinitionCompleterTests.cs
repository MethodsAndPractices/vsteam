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
   public class BuildDefinitionCompleterTests
   {
      private readonly Collection<string> _empty = new Collection<string>();

      [TestMethod]
      public void BuildDefinitionCompleter_GetValues()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._empty);

         var target = new BuildDefinitionCompleter(ps);
         var fakeBoundParameters = new Dictionary<string, string>
         {
            { "ProjectName", "UnitTestProject" }
         };

         // Act
         var actual = target.CompleteArgument("Add-VSTeamBuild", "BuildDefinition", "", null, fakeBoundParameters);

         // Assert
         Assert.AreEqual(0, actual.Count());
      }
   }
}
