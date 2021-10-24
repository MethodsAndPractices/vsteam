using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;
using System.Collections.Generic;
using System.Management.Automation;

namespace vsteam_lib.Test
{
   /// <summary>
   ///  This test derives from ProcessTemplateValidateAttribute to gain access
   ///  to the protected method we need to test.
   /// </summary>
   [TestClass]
   [ExcludeFromCodeCoverage]
   public sealed class TimeZoneValidateAttributeTests : TimeZoneValidateAttribute
   {
      private readonly List<string> _timeZoneIds = new List<string>() {
            {"Alaskan Standard Time"},
            {"UTC-09"},
            {"Pacific Standard Time (Mexico)"},
            {"UTC-08"},
            {"Pacific Standard Time"},
            {"US Mountain Standard Time"}
      };

      [TestMethod]
      public void TimeZoneValidateAttribute_Invalid_Value_Throws()
      {
         // Arrange

         // Act

         // Assert
         Assert.ThrowsException<ValidationMetadataException>(() => this.Validate("Test", null));
      }

      [TestMethod]
      public void TimeZoneValidateAttribute_Valid_Value_Does_Not_Throw()
      {
         // Arrange

         // Act
         foreach (var id in _timeZoneIds)
         {
            this.Validate(id, null);
         }

         // Assert
      }

      [TestMethod]
      public void TimeZoneValidateAttribute_Null_Value_Does_Not_Throw()
      {
         // Arrange

         // Act
         this.Validate(null, null);

         // Assert
      }
   }
}
