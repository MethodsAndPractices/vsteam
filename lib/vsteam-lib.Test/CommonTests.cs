using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Xml.Serialization;

namespace vsteam_lib.Test
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class CommonTests
   {
      private class HasDateTime
      {
         [XmlAttribute("createdDate")]
         public DateTime CreatedOn { get; set; }
      }

      private class HasString
      {
         public string createdDate { get; set; } = "2020-08-27T10:37:32.367Z";
      }

      [TestMethod]
      public void StringToDateTime()
      {
         // Arrange
         var target = new HasDateTime();
         var source = PSObject.AsPSObject(new HasString());

         // Act
         Common.MoveProperties(target, source);

         // Assert
         Assert.AreEqual("8/27/2020 10:37:32 AM", target.CreatedOn.ToUniversalTime());
      }
   }
}
