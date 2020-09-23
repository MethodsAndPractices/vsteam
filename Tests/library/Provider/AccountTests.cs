using Microsoft.VisualStudio.TestTools.UnitTesting;
using NSubstitute;
using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class AccountTests
   {
      [TestMethod]
      public void Account_Get_ChildItem_Should_Not_Return_Permissions()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke().Returns(new Collection<PSObject>());
         var target = new Account("Accounts", ps);
         Versions.Graph = string.Empty;

         // Act
         var actual = target.GetChildItem();

         // Assert
         Assert.AreEqual(3, actual.Length);
      }

      [TestMethod]
      public void Account_Get_ChildItem_Should_Return_Permissions()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke().Returns(new Collection<PSObject>());
         var target = new Account("Accounts", ps);
         Versions.Graph = "6.0-preview";

         // Act
         var actual = target.GetChildItem();

         // Assert
         Assert.AreEqual(4, actual.Length);
      }
   }
}
