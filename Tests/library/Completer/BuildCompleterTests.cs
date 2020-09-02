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
   public class BuildCompleterTests
   {
      private readonly Collection<string> _empty = new Collection<string>();
      private readonly Collection<string> _builds = new Collection<string>() { "602", "700" };
      private readonly Collection<string> _nullDefaultProject = new Collection<string>() { null };

      [TestMethod]
      public void BuildCompleter_NoDefaultProject()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._nullDefaultProject);

         var target = new BuildCompleter(ps);
         var fakeBoundParameters = new Dictionary<string, string>();

         // Act
         var actual = target.CompleteArgument("Add-VSTeamRelease", "BuildNumber", "", null, fakeBoundParameters);

         // Assert
         Assert.AreEqual(0, actual.Count());
      }

      [TestMethod]
      public void BuildCompleter_NoBuilds()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();

         // Make the return of Get-VSTeamBuild to return zero builds
         ps.Invoke<string>().Returns(this._empty);

         var target = new BuildCompleter(ps);
         var fakeBoundParameters = new Dictionary<string, string>
         {
            { "ProjectName", "UnitTestProject" }
         };

         // Act
         var actual = target.CompleteArgument(null, null, "", null, fakeBoundParameters);

         // Assert
         Assert.AreEqual(0, actual.Count());
      }

      [TestMethod]
      public void BuildCompleter_HasBuilds()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();

         ps.Invoke<string>().Returns(this._builds);

         var target = new BuildCompleter(ps);
         var fakeBoundParameters = new Dictionary<string, string>
         {
            { "ProjectName", "UnitTestProject" }
         };

         // Act
         var actual = target.CompleteArgument(null, null, "", null, fakeBoundParameters);

         // Assert
         Assert.AreEqual(2, actual.Count());
      }

      [TestMethod]
      public void BuildCompleter_Build602()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();

         ps.Invoke<string>().Returns(this._builds);

         var target = new BuildCompleter(ps);
         var fakeBoundParameters = new Dictionary<string, string>
         {
            { "ProjectName", "UnitTestProject" }
         };

         // Act
         var actual = target.CompleteArgument(null, null, "6", null, fakeBoundParameters);

         // Assert
         Assert.AreEqual(1, actual.Count());
      }

      [TestMethod]
      public void BuildCompleter_Build800()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();

         ps.Invoke<string>().Returns(this._builds);

         var target = new BuildCompleter(ps);
         var fakeBoundParameters = new Dictionary<string, string>
         {
            { "ProjectName", "UnitTestProject" }
         };

         // Act
         var actual = target.CompleteArgument(null, null, "8", null, fakeBoundParameters);

         // Assert
         Assert.AreEqual(0, actual.Count());
      }
   }
}
