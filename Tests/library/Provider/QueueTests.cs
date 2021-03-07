using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class QueueTests
   {
      [TestMethod]
      public void Queue_Constructor()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-VSTeamQueue.json");

         // Act
         var target = new Queue(obj[0], "Project Name", ps);

         // Assert
         Assert.IsNotNull(target.Pool, "Pool");
         Assert.AreEqual("81", target.Id, "ID");
         Assert.AreEqual("DefaultPool", target.PoolName, "PoolName");
      }
   }
}
