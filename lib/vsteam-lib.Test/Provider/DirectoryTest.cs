using Microsoft.VisualStudio.TestTools.UnitTesting;
using NSubstitute;
using System.Diagnostics.CodeAnalysis;
using vsteam_lib.Provider;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class DirectoryTest
   {
      [TestMethod]
      public void Get_VSTeamPool()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("./SampleFiles/Get-VSTeamPool.json");

         ps.Invoke().Returns(obj);

         var target = new Directory("Agent Pools", "Pool", ps);

         // Act
         var actual = target.GetChildItem();

         // Assert
         Assert.AreEqual(12, actual.Length);
         ps.Received().AddCommand("Sort-Object");
         ps.Received().AddCommand("Get-VSTeamPool");
         ps.DidNotReceive().AddParameter("ProjectName");
      }
   }
}
