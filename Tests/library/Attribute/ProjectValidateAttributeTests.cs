using Microsoft.VisualStudio.TestTools.UnitTesting;
using NSubstitute;
using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;

namespace vsteam_lib.Test
{
   /// <summary>
   ///  This test derives from ProjectValidateAttribute to gain access
   ///  to the protected method we need to test.
   /// </summary>
   [TestClass]
   [ExcludeFromCodeCoverage]
   public sealed class ProjectValidateAttributeTests : ProjectValidateAttribute
   {
      public ProjectValidateAttributeTests() : base(false)
      {

      }

      private readonly Collection<string> _empty = new Collection<string>();
      private readonly Collection<string> _values = new Collection<string>() { "Project1", "Project2", "Project3", "Project4", "Project 5" };

      [TestMethod]
      public void ProjectValidateAttribute_Invalid_Value_Throws()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._values);
         ProjectCache.Cache.Shell = ps;
         ProjectCache.Invalidate();

         // Act
         // Assert
         Assert.ThrowsException<ValidationMetadataException>(() => this.Validate("Test", null));
      }

      [TestMethod]
      public void ProjectValidateAttribute_Valid_Value_Does_Not_Throw()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._values);
         ProjectCache.Cache.Shell = ps;
         ProjectCache.Invalidate();

         // Act
         this.Validate("Project2", null);

         // Assert
      }

      [TestMethod]
      public void ProjectValidateAttribute_Valid_Value_Wrong_Case_Does_Not_Throw()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._values);
         ProjectCache.Cache.Shell = ps;
         ProjectCache.Invalidate();

         // Act
         this.Validate("project2", null);

         // Assert
      }

      [TestMethod]
      public void ProjectValidateAttribute_Null_Value_Does_Not_Throw()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._values);
         ProjectCache.Cache.Shell = ps;
         ProjectCache.Invalidate();

         // Act
         this.Validate(null, null);

         // Assert
      }

      [TestMethod]
      public void ProjectValidateAttribute_Empty_Cache_Does_Not_Throw()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._empty);
         ProjectCache.Cache.Shell = ps;
         ProjectCache.Invalidate();

         // Act
         this.Validate("Project1", null);

         // Assert
      }
   }
}
