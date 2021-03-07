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
   public class ProjectCacheTests
   {
      private readonly Collection<string> _templates = new Collection<string>() { "Project1", "Project 2" };

      [TestMethod]
      public void ProjectCache_HasCacheExpired()
      {
         // Arrange
         var expected = true;

         // Act
         ProjectCache.Invalidate();

         // Assert
         Assert.AreEqual(expected, ProjectCache.HasCacheExpired, "Cache should be expired");

         // Act
         ProjectCache.Update(new List<string>());

         // Assert
         Assert.AreNotEqual(expected, ProjectCache.HasCacheExpired, "Cache should not be expired");
      }

      [TestMethod]
      public void ProjectCache_Update_With_Null_List()
      {
         // Arrange
         var expected = 2;
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._templates);
         ProjectCache.Cache.Shell = ps;

         // Act
         ProjectCache.Update(null);

         // Assert
         Assert.AreEqual(expected, ProjectCache.Cache.Values.Count);
      }

      [TestMethod]
      public void ProjectCache_GetCurrent()
      {
         // Arrange
         var expected = 2;
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._templates);
         ProjectCache.Cache.Shell = ps;
         ProjectCache.Invalidate();

         // Act
         var actual = ProjectCache.GetCurrent(false);

         // Assert
         Assert.AreEqual(expected, actual.Count());
      }

      [TestMethod]
      public void ProjectCache_Update_Returns_Null()
      {
         // Arrange
         var expected = 0;
         var ps = BaseTests.PrepPowerShell();
         ProjectCache.Cache.Shell = ps;

         // Act
         ProjectCache.Update(null);

         // Assert
         Assert.AreEqual(expected, ProjectCache.Cache.Values.Count);
      }

      [TestMethod]
      public void ProjectCache_Update_With_Empty_List()
      {
         // Arrange
         var expected = 0;
         var ps = BaseTests.PrepPowerShell();
         ProjectCache.Cache.Shell = ps;

         // Act
         ProjectCache.Update(new List<string>());

         // Assert
         Assert.AreEqual(expected, ProjectCache.Cache.Values.Count);
      }
   }
}
