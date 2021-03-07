using Microsoft.VisualStudio.TestTools.UnitTesting;
using NSubstitute;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class AgentTests
   {
      [TestMethod]
      public void Agent_Constructor()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var agents = BaseTests.LoadJson("Get-VSTeamAgent-PoolId1.json");

         // Act
         var target = new Agent(agents[0], 1, ps);

         // Assert
         Assert.IsNotNull(target.SystemCapabilities);
         Assert.AreEqual(1, target.PoolId, "PoolId");
         Assert.AreEqual(111, target.AgentId, "AgentId");
         Assert.AreEqual(true, target.Enabled, "Enabled");
         Assert.AreEqual("offline", target.Status, "Status");
         Assert.AreEqual("2.155.1", target.Version, "Version");
         Assert.AreEqual("WinBldBox-3_Service2", target.Name, "Name");
         Assert.AreEqual("Microsoft Windows 6.3.9600 ", target.OS, "OS");
      }

      [TestMethod]
      public void Agent_GetChildItem()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var agents = BaseTests.LoadJson("Get-VSTeamPool.json");
         var jobRequests = BaseTests.LoadJson("Get-VSTeamJobRequest-PoolId1-AgentID111.json");

         ps.Invoke().Returns(jobRequests);

         var target = new Agent(agents[0], 1, ps);

         // Act
         var actual = target.GetChildItem();

         // Assert
         Assert.AreEqual(3, actual.Length);
         ps.Received().AddCommand("Get-VSTeamJobRequest");
      }
   }
}
