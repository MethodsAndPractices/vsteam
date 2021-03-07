using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class UserEntitlementTests
   {
      [TestMethod]
      public void UserEntitlementTests_Constructor()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-VSTeamUserEntitlement.json", false);
         var members = obj[0].GetValue<object[]>("members");

         // Act
         var target = new UserEntitlement((PSObject)members[0]);

         // Assert
         Assert.AreEqual("mlastName@test.com", target.Email, "Email");
         Assert.AreEqual("Math lastName", target.UserName, "UserName");
         Assert.AreEqual("Math lastName", target.ToString(), "ToString()");
         Assert.AreEqual("Math lastName", target.DisplayName, "DisplayName");
         Assert.AreEqual("mlastName@test.com", target.UniqueName, "UniqueName");
         Assert.AreEqual("Early Adopter", target.AccessLevelName, "AccessLevelName");
         Assert.AreEqual("9/9/2020 6:43:29 am", target.LastAccessedDate.ToString("M/d/yyyy h:mm:ss tt").ToLower(), "LastAccessedDate");
      }

      [TestMethod]
      public void UserEntitlementTests_Constructor_ById()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-VSTeamUserEntitlement-Id.json", false);

         // Act
         var target = new UserEntitlement(obj[0]);

         // Assert
         Assert.AreEqual("test@test.com", target.Email, "Email");
         Assert.AreEqual("Donovan Brown", target.UserName, "UserName");
         Assert.AreEqual("Early Adopter", target.AccessLevelName, "AccessLevelName");
      }
   }
}
