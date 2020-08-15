using Microsoft.VisualStudio.TestTools.UnitTesting;
using NSubstitute;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class AgentPoolTests
   {
      [TestMethod]
      public void Constructor_NotHosted()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var contents = System.IO.File.ReadAllText("./SampleFiles/Get-VSTeamPool.json");

         var obj = PowerShell.Create().AddCommand("ConvertFrom-Json")
                                      .AddParameter("InputObject", contents)
                                      .AddParameter("Depth", 100)
                                      .AddCommand("Select-Object")
                                      .AddParameter("ExpandProperty", "value")
                                      .Invoke();

         // Act
         var target = new AgentPool(obj[0], ps);

         // Assert
         Assert.AreEqual(1, target.Id, "Id");
         Assert.AreEqual(4, target.Count, "Count");
         Assert.AreEqual(false, target.IsHosted, "IsHosted");
         Assert.AreEqual("d-----", target.DisplayMode, "DisplayMode");
      }

      [TestMethod]
      public void Constructor_Hosted()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var contents = System.IO.File.ReadAllText("./SampleFiles/Get-VSTeamPool.json");

         var obj = PowerShell.Create().AddCommand("ConvertFrom-Json")
                                      .AddParameter("InputObject", contents)
                                      .AddParameter("Depth", 100)
                                      .AddCommand("Select-Object")
                                      .AddParameter("ExpandProperty", "value")
                                      .Invoke();

         // Act
         var target = new AgentPool(obj[1], ps);

         // Assert
         Assert.AreEqual(2, target.Id, "Id");
         Assert.AreEqual(15, target.Count, "Count");
         Assert.AreEqual(true, target.IsHosted, "IsHosted");
         Assert.AreEqual("d-r-s-", target.DisplayMode, "DisplayMode");
      }

      [TestMethod]
      public void GetChildItem()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var contents = System.IO.File.ReadAllText("./SampleFiles/Get-VSTeamPool.json");

         var pools = PowerShell.Create().AddCommand("ConvertFrom-Json")
                                      .AddParameter("InputObject", contents)
                                      .AddParameter("Depth", 100)
                                      .AddCommand("Select-Object")
                                      .AddParameter("ExpandProperty", "value")
                                      .Invoke();

         contents = System.IO.File.ReadAllText("./SampleFiles/Get-VSTeamAgent-PoolId1.json");

         var agents = PowerShell.Create().AddCommand("ConvertFrom-Json")
                                      .AddParameter("InputObject", contents)
                                      .AddParameter("Depth", 100)
                                      .AddCommand("Select-Object")
                                      .AddParameter("ExpandProperty", "value")
                                      .Invoke();

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
