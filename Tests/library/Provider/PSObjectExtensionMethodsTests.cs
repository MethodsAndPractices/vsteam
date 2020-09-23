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
      public void GetValue_String_To_Nullable_DateTime()
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
      public void GetValue_Int32_To_Long()
      {
         // Arrange
         var target = PSObject.AsPSObject(new { revision = 8 });

         // Act
         var actual = target.GetValue<long>("revision");

         // Assert
         Assert.AreEqual(8, actual);
      }

      [TestMethod]
      public void GetValue_Missing_Nested_Property_As_String()
      {
         // Arrange
         var target = PSObject.AsPSObject(new { revision = PSObject.AsPSObject(new { value = 0 }) });

         // Act
         var actual = target.GetValue("revision.test");

         // Assert
         Assert.AreEqual(null, actual);
      }

      [TestMethod]
      public void GetValue_Missing_Property_As_String()
      {
         // Arrange
         var target = PSObject.AsPSObject(new { revision = PSObject.AsPSObject(new { value = 0 }) });

         // Act
         var actual = target.GetValue("test");

         // Assert
         Assert.AreEqual(null, actual);
      }

      [TestMethod]
      public void GetValue_Null_Property_As_String()
      {
         // Arrange
         var target = PSObject.AsPSObject(new { test = (string)null });

         // Act
         var actual = target.GetValue("test");

         // Assert
         Assert.AreEqual(null, actual);
      }

      [TestMethod]
      public void GetValue_Nested_Property_As_Long()
      {
         // Arrange
         var target = PSObject.AsPSObject(new { revision = PSObject.AsPSObject(new { value = 1 }) });

         // Act
         var actual = target.GetValue<long>("revision.value");

         // Assert
         Assert.AreEqual(1, actual);
      }

      [TestMethod]
      public void GetValue_Long_Property_As_String()
      {
         // Arrange
         var target = PSObject.AsPSObject(new { value = 1 });

         // Act
         var actual = target.GetValue<string>("value");

         // Assert
         Assert.AreEqual("1", actual);
      }
   }
}
