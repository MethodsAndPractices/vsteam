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
   public class ProcessTemplateCacheTests
   {
      private readonly Collection<string> _items = new Collection<string>() { "Agile", "Basic", "CMMI", "Scrum", "Scrum with spaces" };

      [TestMethod]
      public void ProcessTemplateCache_HasCacheExpired()
      {
         // Arrange
         var expected = true;

         // Act
         ProcessTemplateCache.Invalidate();

         // Assert
         Assert.AreEqual(expected, ProcessTemplateCache.HasCacheExpired, "Cache should be expired");

         // Act
         ProcessTemplateCache.Update(new List<string>());

         // Assert
         Assert.AreNotEqual(expected, ProcessTemplateCache.HasCacheExpired, "Cache should not be expired");
      }

      [TestMethod]
      public void ProcessTemplateCache_Update_With_Null_List()
      {
         // Arrange
         var expected = 5;
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._items);
         ProcessTemplateCache.Cache.Shell = ps;

         // Act
         ProcessTemplateCache.Update(null);

         // Assert
         Assert.AreEqual(expected, ProcessTemplateCache.Cache.Values.Count);
      }

      [TestMethod]
      public void ProcessTemplateCache_GetCurrent()
      {
         // Arrange
         var expected = 5;
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._items);
         ProcessTemplateCache.Cache.Shell = ps;
         ProcessTemplateCache.Invalidate();

         // Act
         var actual = ProcessTemplateCache.GetCurrent();

         // Assert
         Assert.AreEqual(expected, actual.Count());
      }

      [TestMethod]
      public void ProcessTemplateCache_Update_Returns_Null()
      {
         // Arrange
         var expected = 0;
         var ps = BaseTests.PrepPowerShell();
         ProcessTemplateCache.Cache.Shell = ps;

         // Act
         ProcessTemplateCache.Update(null);

         // Assert
         Assert.AreEqual(expected, ProcessTemplateCache.Cache.Values.Count);
      }

      [TestMethod]
      public void ProcessTemplateCache_Update_With_Empty_List()
      {
         // Arrange
         var expected = 0;
         var ps = BaseTests.PrepPowerShell();
         ProcessTemplateCache.Cache.Shell = ps;

         // Act
         ProcessTemplateCache.Update(new List<string>());

         // Assert
         Assert.AreEqual(expected, ProcessTemplateCache.Cache.Values.Count);
      }
   }
}
