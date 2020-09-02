using Microsoft.VisualStudio.TestTools.UnitTesting;
using NSubstitute;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;
using System.Linq;

namespace vsteam_lib.Test
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class WorkItemTypeCacheTests
   {
      private readonly Collection<string> _emptyStrings = new Collection<string>();
      private readonly Collection<string> _defaultProject = new Collection<string>() { "UnitTestProject" };
      private readonly Collection<string> _workItemTypes = new Collection<string>() { "Bug", "Task", "Issue", "Feature", "User Story" };

      [TestMethod]
      public void WorkItemTypeCache_HasCacheExpired()
      {
         // Arrange
         var expected = true;

         // Act
         WorkItemTypeCache.Invalidate();

         // Assert
         Assert.AreEqual(expected, WorkItemTypeCache.HasCacheExpired, "Cache should be expired");

         // Act
         WorkItemTypeCache.Update(new List<string>());

         // Assert
         Assert.AreNotEqual(expected, WorkItemTypeCache.HasCacheExpired, "Cache should not be expired");
      }

      [TestMethod]
      public void WorkItemTypeCache_Update_With_Null_List()
      {
         // Arrange
         var expected = 5;
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._workItemTypes);
         WorkItemTypeCache.Cache.Shell = ps;

         // Act
         WorkItemTypeCache.Update(null);

         // Assert
         Assert.AreEqual(expected, WorkItemTypeCache.Cache.Values.Count);
      }

      [TestMethod]
      public void WorkItemTypeCache_GetCurrent()
      {
         // Arrange
         var expected = 5;
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._workItemTypes);
         WorkItemTypeCache.Cache.Shell = ps;

         // Act
         var actual = WorkItemTypeCache.GetCurrent();

         // Assert
         Assert.AreEqual(expected, actual.Count());
      }

      [TestMethod]
      public void WorkItemTypeCache_Update_Returns_Null()
      {
         // Arrange
         var expected = 0;
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._defaultProject, _emptyStrings);
         WorkItemTypeCache.Cache.Shell = ps;

         // Act
         WorkItemTypeCache.Update(null);

         // Assert
         Assert.AreEqual(expected, WorkItemTypeCache.Cache.Values.Count);
      }

      [TestMethod]
      public void WorkItemTypeCache_Update_With_Empty_List()
      {
         // Arrange
         var expected = 0;
         var ps = BaseTests.PrepPowerShell();
         WorkItemTypeCache.Cache.Shell = ps;

         // Act
         WorkItemTypeCache.Update(new List<string>());

         // Assert
         Assert.AreEqual(expected, WorkItemTypeCache.Cache.Values.Count);
      }
   }
}
