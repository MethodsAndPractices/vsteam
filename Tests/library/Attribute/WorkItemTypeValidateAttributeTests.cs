using Microsoft.VisualStudio.TestTools.UnitTesting;
using NSubstitute;
using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;

namespace vsteam_lib.Test
{
   /// <summary>
   ///  This test derives from WorkItemTypeValidateAttribute to gain access
   ///  to the protected method we need to test.
   /// </summary>
   [TestClass]
   [ExcludeFromCodeCoverage]
   public sealed class WorkItemTypeValidateAttributeTests : WorkItemTypeValidateAttribute
   {
      private readonly Collection<string> _emptyStrings = new Collection<string>();
      private readonly Collection<string> _defaultProject = new Collection<string>() { "UnitTestProject" };
      private readonly Collection<string> _workItemTypes = new Collection<string>() { "Bug", "Task", "Issue", "Feature", "User Story" };

      [TestMethod]
      public void WorkItemTypeValidateAttribute_Invalid_Value_Throws()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._defaultProject, this._workItemTypes);
         WorkItemTypeCache.Cache.Shell = ps;
         WorkItemTypeCache.Invalidate();

         // Act
         // Assert
         Assert.ThrowsException<ValidationMetadataException>(() => this.Validate("Test", null));
      }

      [TestMethod]
      public void WorkItemTypeValidateAttribute_Valid_Value_Does_Not_Throw()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._defaultProject, this._workItemTypes);
         WorkItemTypeCache.Cache.Shell = ps;
         WorkItemTypeCache.Invalidate();

         // Act
         this.Validate("Task", null);

         // Assert
      }

      [TestMethod]
      public void WorkItemTypeValidateAttribute_Null_Value_Does_Not_Throw()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._defaultProject, this._workItemTypes);
         WorkItemTypeCache.Cache.Shell = ps;
         WorkItemTypeCache.Invalidate();

         // Act
         this.Validate(null, null);

         // Assert
      }

      [TestMethod]
      public void WorkItemTypeValidateAttribute_Empty_Cache_Does_Not_Throw()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._defaultProject, this._emptyStrings);
         WorkItemTypeCache.Cache.Shell = ps;
         WorkItemTypeCache.Invalidate();

         // Act
         this.Validate("Agile", null);

         // Assert
      }
   }
}
