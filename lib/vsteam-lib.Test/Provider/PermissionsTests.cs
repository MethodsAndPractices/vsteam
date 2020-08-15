using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;
using vsteam_lib.Provider;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class PermissionsTests
   {
      [TestMethod]
      public void Get_ChildItem()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var target = new Permissions("Permissions", ps);

         // Act
         var actual = target.GetChildItem();

         // Assert
         Assert.AreEqual(2, actual.Length);
         Assert.AreEqual("Groups", ((Directory)actual[0]).Name);
         Assert.AreEqual("Users", ((Directory)actual[1]).Name);
      }
   }
}
