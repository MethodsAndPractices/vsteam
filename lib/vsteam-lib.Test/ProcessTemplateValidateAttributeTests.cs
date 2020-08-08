using Microsoft.VisualStudio.TestTools.UnitTesting;
using NSubstitute;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Management.Automation;
using System.Text;

namespace vsteam_lib.Test
{
   /// <summary>
   ///  This test derives from ProcessTemplateValidateAttribute to gain access
   ///  to the protected method we need to test.
   /// </summary>
   [TestClass]
   public sealed class ProcessTemplateValidateAttributeTests : ProcessTemplateValidateAttribute
   {
      private readonly Collection<string> _templates = new Collection<string>() { "Agile", "Basic", "CMMI", "Scrum", "Scrum with spaces" };

      [TestMethod]
      [ExpectedException(typeof(ValidationMetadataException))]
      public void Invalid_Value_Throws()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._templates);
         ProcessTemplateCache.Shell = ps;
         ProcessTemplateCache.Invalidate();

         // Act
         this.Validate("Test", null);

         // Assert
      }

      [TestMethod]
      public void Valid_Value_Does_Not_Throw()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._templates);
         ProcessTemplateCache.Shell = ps;
         ProcessTemplateCache.Invalidate();

         // Act
         this.Validate("Basic", null);

         // Assert
      }
   }
}
