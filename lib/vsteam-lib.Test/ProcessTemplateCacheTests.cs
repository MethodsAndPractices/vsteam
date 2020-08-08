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
      private readonly Collection<string> _templates = new Collection<string>() { "Agile", "Basic", "CMMI", "Scrum", "Scrum with spaces" };

      [TestMethod]
      public void Update_And_Invalidate_Cache()
      {
         // Arrange
         double expected = -1;

         // Act
         ProcessTemplateCache.Invalidate();

         // Assert
         Assert.AreEqual(expected, ProcessTemplateCache.TimeStamp, "TimeStamp was not reset");

         // Act
         ProcessTemplateCache.Update(new List<string>());

         // Assert
         Assert.AreNotEqual(expected, ProcessTemplateCache.TimeStamp, "TimeStamp was not updated");
      }

      [TestMethod]
      public void HasCacheExpired()
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
         Assert.AreNotEqual(expected, ProcessTemplateCache.TimeStamp, "Cache should not be expired");
      }

      [TestMethod]
      public void Update_With_Null_List()
      {
         // Arrange
         var expected = 5;
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._templates);
         ProcessTemplateCache.Shell = ps;

         // Act
         ProcessTemplateCache.Update(null);

         // Assert
         Assert.AreEqual(expected, ProcessTemplateCache.Templates.Count);
      }

      [TestMethod]
      public void GetCurrent()
      {
         // Arrange
         var expected = 5;
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._templates);
         ProcessTemplateCache.Shell = ps;

         // Act
         var actual = ProcessTemplateCache.GetCurrent();

         // Assert
         Assert.AreEqual(expected, actual.Count());
      }

      [TestMethod]
      public void Update_Returns_Null()
      {
         // Arrange
         var expected = 0;
         var ps = BaseTests.PrepPowerShell();
         ProcessTemplateCache.Shell = ps;

         // Act
         ProcessTemplateCache.Update(null);

         // Assert
         Assert.AreEqual(expected, ProcessTemplateCache.Templates.Count);
      }

      [TestMethod]
      public void Update_With_Empty_List()
      {
         // Arrange
         var expected = 0;
         var ps = BaseTests.PrepPowerShell();
         ProcessTemplateCache.Shell = ps;

         // Act
         ProcessTemplateCache.Update(new List<string>());

         // Assert
         Assert.AreEqual(expected, ProcessTemplateCache.Templates.Count);
      }
   }
}
