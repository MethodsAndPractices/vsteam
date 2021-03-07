using Microsoft.VisualStudio.TestTools.UnitTesting;
using NSubstitute;
using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Management.Automation;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class ReleasesTests
   {
      [TestMethod]
      public void Releases_Constructor()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();

         // Act
         var target = new Releases(ps, "Project Name");

         // Assert
         Assert.AreEqual("vsteam_lib.Provider.Release", target.TypeName, "TypeName");
      }

      [TestMethod]
      public void Releases_GetChildItem()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var target = new Releases(ps, "Project Name");
         var obj = BaseTests.LoadJson("Get-VSTeamRelease.json");
         var releases = new Collection<PSObject>(obj.Select(o => PSObject.AsPSObject(o)).ToList());
         ps.Invoke().Returns(releases);

         // Act
         var children = target.GetChildItem();

         // Assert
         Assert.AreEqual(2, children.Length, "Length");
      }
   }
}
