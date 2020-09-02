using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class GitRefTests
   {
      [TestMethod]
      public void GitRef_Constructor()
      {
         // Arrange
         var obj = BaseTests.LoadJson("Get-VSTeamGitRef.json");

         // Act
         var actual = new GitRef(obj[0], "TestProject");

         // Assert
         Assert.IsNotNull(actual.Creator, "Creator");
         Assert.AreEqual("refs/heads/master", actual.RefName, "RefName");
      }
   }
}
