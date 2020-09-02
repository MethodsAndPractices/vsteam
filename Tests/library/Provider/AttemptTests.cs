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
      public void Attempt_Constructor()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-VSTeamRelease-id178-expandEnvironments.json", false);
         var envs = obj[0].GetValue<object[]>("environments");
         var attempts = ((PSObject)envs[0]).GetValue<object[]>("deploySteps");

         // Act
         var target = new Attempt((PSObject)attempts[0], "projectName");

         // Assert
         Assert.AreEqual(3578, target.Id, "Id");
         Assert.AreEqual(1, target.AttemptNo, "AttemptNo");
         Assert.AreEqual(4, target.Tasks.Count, "Task.Count");
         Assert.AreEqual("succeeded", target.Status, "Status");

         Assert.AreEqual("succeeded", target.Tasks[0].Status, "Tasks[0].Status");
         Assert.AreEqual("WinBldBox-3_Service3", target.Tasks[0].AgentName, "Tasks[0].AgentName");
         Assert.AreEqual("https://vsrm.dev.azure.com/test/00000000-0000-0000-0000-000000000000/_apis/Release/releases/178/environments/2149/deployPhases/1237/tasks/3/logs", target.Tasks[0].LogUrl, "Tasks[0].LogUrl");
      }

      [TestMethod]
      public void Attempt_GetChildItem()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-VSTeamRelease-id178-expandEnvironments.json", false);
         var envs = obj[0].GetValue<object[]>("environments");
         var attempts = ((PSObject)envs[0]).GetValue<object[]>("deploySteps");
         var target = new Attempt((PSObject)attempts[0], "projectName");

         // Act
         var children = target.GetChildItem();

         // Assert
         Assert.AreEqual(4, children.Length);
      }
   }
}
