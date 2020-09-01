using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class AttemptTests
   {
      [TestMethod]
      public void Constructor()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-VSTeamRelease-id178-expandEnvironments.json", false);
         var envs = obj[0].GetValue<object[]>("environments");
         var attempts = ((PSObject)envs[0]).GetValue<object[]>("deploySteps");

         // ActRT
         var target = new Attempt((PSObject)attempts[0], "projectName");

         // Assert
         Assert.AreEqual(3578, target.Id, "Id");
         Assert.AreEqual(4, target.Tasks.Count, "Task.Count");
         //Assert.AreEqual("name", target.Name, "Name");
         //Assert.AreEqual(1, target.AttemptNo, "AttemptNo");
         //Assert.AreEqual("status", target.Status, "Status");
         //Assert.AreEqual("projectName", target.ProjectName, "ProjectName");
      }

      [TestMethod]
      public void GetChildItem()
      {
         // Arrange

         // Act

         // Assert
      }
   }
}
