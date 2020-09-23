using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class EnvironmentTests
   {
      [TestMethod]
      public void Environment_Constructor()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-VSTeamRelease-id178-expandEnvironments.json", false);
         var envs = obj[0].GetValue<object[]>("environments");

         // Act
         var target = new Environment((PSObject)envs[0], 178, "projectName", ps);

         // Assert
         Assert.AreEqual(2149, target.Id, "Id");
         Assert.AreEqual(178, target.ReleaseId, "ReleaseId");
         Assert.AreEqual("succeeded", target.Status, "Status");
         Assert.AreEqual(2149, target.EnvironmentId, "EnvironmentId");
      }

      [TestMethod]
      public void Environment_GetChildItem()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-VSTeamRelease-id178-expandEnvironments.json", false);
         var envs = obj[0].GetValue<object[]>("environments");
         var target = new Environment((PSObject)envs[0], 178, "projectName", ps);

         // Act
         var children = target.GetChildItem();

         // Assert
         Assert.AreEqual(1, children.Length);
      }
   }
}
