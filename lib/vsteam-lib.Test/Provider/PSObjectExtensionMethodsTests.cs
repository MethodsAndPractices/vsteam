using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class PSObjectExtensionMethodsTests
   {
      [TestMethod]
      public void String_To_Nullable_DateTime()
      {
         // Arrange
         var target = PSObject.AsPSObject(new { finishTime = "2019-06-04T13:32:30.17Z" });
         var expected = DateTime.Parse("2019-06-04T13:32:30.17Z");

         // Act
         var actual = target.GetValue<DateTime?>("finishTime");

         // Assert
         Assert.AreEqual(expected, actual);
      }

      [TestMethod]
      public void Int32_To_Long()
      {
         // Arrange
         var target = PSObject.AsPSObject(new { revision = 8 });

         // Act
         var actual = target.GetValue<long>("revision");

         // Assert
         Assert.AreEqual(8, actual);
      }
   }
}
