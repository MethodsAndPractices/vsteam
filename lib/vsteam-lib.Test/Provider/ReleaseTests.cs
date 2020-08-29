using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class ReleaseTests
   {
      [TestMethod]
      public void Constructor()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("./SampleFiles/Get-VSTeamRelease.json");

         // Act
         var target = new Release(obj[0], ps, "Project Name");

         // Assert
         Assert.AreEqual(259, target.Id, "Id");
         Assert.IsNull(target.Environments, "Environments");
         Assert.AreEqual("active", target.Status, "Status");
         Assert.AreEqual("PTracker-CD", target.DefinitionName, "DefinitionName");

         Assert.IsNotNull(target.ReleaseDefinition, "ReleaseDefinition");
         
         Assert.AreEqual(null, target.RequestedFor.DisplayName, "RequestedFor.DisplayName");
         Assert.AreEqual("Test@Test.com", target.ModifiedBy.UniqueName, "ModifiedBy.UniqueName");
         Assert.AreEqual("Donovan Brown", target.CreatedBy.DisplayName, "CreatedBy.DisplayName");
         Assert.AreEqual("11/14/2019 12:56:09 AM", target.CreatedOn.ToString(), "CreatedOn.ToString()");
      }
   }
}
