using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class QueueTests
   {
      [TestMethod]
      public void Constructor()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("./SampleFiles/Get-VSTeamQueue.json");

         // Act
         var target = new Queue(obj[0], "Project Name", ps);

         // Assert
         Assert.IsNotNull(target.Pool, "Pool");
         Assert.AreEqual("81", target.ID, "ID");
         Assert.AreEqual("DefaultPool", target.PoolName, "PoolName");
      }
   }
}
