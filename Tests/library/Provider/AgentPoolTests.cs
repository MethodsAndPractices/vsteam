using Microsoft.VisualStudio.TestTools.UnitTesting;
using NSubstitute;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class AgentPoolTests
   {
      [TestMethod]
      public void AgentPool_Constructor_NotHosted()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-VSTeamPool.json");

         // Act
         var target = new AgentPool(obj[0], ps);

         // Assert
         Assert.AreEqual(1, target.Id, "Id");
         Assert.AreEqual(4, target.Count, "Count");
         Assert.AreEqual(1, target.PoolId, "PoolId");
         Assert.AreEqual(false, target.IsHosted, "IsHosted");
         Assert.AreEqual("d-----", target.DisplayMode, "DisplayMode");
      }

      [TestMethod]
      public void AgentPool_Constructor_Hosted()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-VSTeamPool.json");

         // Act
         var target = new AgentPool(obj[1], ps);

         // Assert
         Assert.AreEqual(2, target.Id, "Id");
         Assert.AreEqual(15, target.Count, "Count");
         Assert.AreEqual(true, target.IsHosted, "IsHosted");
         Assert.AreEqual("d-r-s-", target.DisplayMode, "DisplayMode");
      }

      [TestMethod]
      public void AgentPool_GetChildItem()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var pools = BaseTests.LoadJson("Get-VSTeamPool.json");
         var agents = BaseTests.LoadJson("Get-VSTeamAgent-PoolId1.json");

         ps.Invoke().Returns(agents);

         var target = new AgentPool(pools[0], ps);

         // Act
         var actual = target.GetChildItem();

         // Assert
         Assert.AreEqual(4, actual.Length);
         ps.Received().AddCommand("Get-VSTeamAgent");
      }
   }
}
