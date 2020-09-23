using Microsoft.VisualStudio.TestTools.UnitTesting;
using NSubstitute;
using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;

namespace vsteam_lib.Test
{
   /// <summary>
   ///  This test derives from ProcessTemplateValidateAttribute to gain access
   ///  to the protected method we need to test.
   /// </summary>
   [TestClass]
   [ExcludeFromCodeCoverage]
   public sealed class ProcessTemplateValidateAttributeTests : ProcessTemplateValidateAttribute
   {
      private readonly Collection<string> _empty = new Collection<string>();
      private readonly Collection<string> _templates = new Collection<string>() { "Agile", "Basic", "CMMI", "Scrum", "Scrum with spaces" };

      [TestMethod]
      public void ProcessTemplateValidateAttribute_Invalid_Value_Throws()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._templates);
         ProcessTemplateCache.Cache.Shell = ps;
         ProcessTemplateCache.Invalidate();

         // Act
         // Assert
         Assert.ThrowsException<ValidationMetadataException>(() => this.Validate("Test", null));
      }

      [TestMethod]
      public void ProcessTemplateValidateAttribute_Valid_Value_Does_Not_Throw()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._templates);
         ProcessTemplateCache.Cache.Shell = ps;
         ProcessTemplateCache.Invalidate();

         // Act
         this.Validate("Basic", null);

         // Assert
      }

      [TestMethod]
      public void ProcessTemplateValidateAttribute_Null_Value_Does_Not_Throw()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._templates);
         ProcessTemplateCache.Cache.Shell = ps;
         ProcessTemplateCache.Invalidate();

         // Act
         this.Validate(null, null);

         // Assert
      }

      [TestMethod]
      public void ProcessTemplateValidateAttribute_Empty_Cache_Does_Not_Throw()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._empty);
         ProcessTemplateCache.Cache.Shell = ps;
         ProcessTemplateCache.Invalidate();

         // Act
         this.Validate("Agile", null);

         // Assert
      }
   }
}
