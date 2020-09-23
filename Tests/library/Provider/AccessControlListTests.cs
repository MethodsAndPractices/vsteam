using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class AccessControlListTests
   {
      [TestMethod]
      public void AccessControlList_Constructor()
      {
         // Arrange
         var obj = BaseTests.LoadJson("Get-VSTeamAccessControlList.json");

         // Act
         var target = new AccessControlList(obj[0]);

         // Assert
         Assert.AreEqual(1, target.Aces.Count, "Aces");
         Assert.AreEqual(true, target.InheritPermissions, "InheritPermissions");
         Assert.AreEqual("$/00000000-0000-0000-0000-000000000001", target.Token, "Token");
         Assert.AreEqual("$/00000000-0000-0000-0000-000000000001", target.ToString(), "ToString()");
      }
   }
}
