using Microsoft.VisualStudio.TestTools.UnitTesting;
using NSubstitute;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Management.Automation;

namespace vsteam_lib.Test
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class RelationTypeCacheTests
    {
      private readonly Collection<PSObject> _empty = new Collection<PSObject>();
      private readonly Collection<string> _emptyStrings = new Collection<string>();
      private readonly Collection<string> _relationNames = new Collection<string>() { "Produces For", "Predecessor", "Parent" };
      private readonly Collection<PSObject> _relations = new Collection<PSObject>() {
         PSObject.AsPSObject(new {Name = "Produces For", ReferenceName = "System.LinkTypes.Remote.Dependency-Forward" }),
         PSObject.AsPSObject(new {Name = "Predecessor", ReferenceName = "System.LinkTypes.Dependency-Reverse" }),
         PSObject.AsPSObject(new {Name = "Parent", ReferenceName = "System.LinkTypes.Hierarchy-Reverse" })
      };

      [TestMethod]
      public void RelationTypeCache_HasCacheExpired()
      {
         // Arrange
         var expected = true;

        // Act
        RelationTypeCache.Invalidate();

         // Assert
         Assert.AreEqual(expected, RelationTypeCache.HasCacheExpired, "Cache should be expired");

        // Act
        RelationTypeCache.Update(new Dictionary<string, string>());

         // Assert
         Assert.AreNotEqual(expected, RelationTypeCache.HasCacheExpired, "Cache should not be expired");
      }

      [TestMethod]
      public void RelationTypeCache_Update_With_Null_List()
      {
         // Arrange
         int expected = 3;
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke().Returns(this._relations);
         ps.Invoke<string>(this._relations).Returns(this._relationNames);
         RelationTypeCache.Cache.Shell = ps;

         // Act
         RelationTypeCache.Update(null);

         // Assert
         Assert.AreEqual(expected, RelationTypeCache.Cache.Values.Count);
      }

      [TestMethod]
      public void RelationTypeCache_GetCurrent()
      {
         // Arrange
         var expected = 3;
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke().Returns(this._relations);
         ps.Invoke<string>(this._relations).Returns(this._relationNames);

         ps.Invoke<string>().Returns(this._relationNames);
         RelationTypeCache.Invalidate();
         RelationTypeCache.Cache.Shell = ps;

         // Act
         var actual = RelationTypeCache.GetCurrent();

         // Assert
         Assert.AreEqual(expected, actual.Count());
      }

      [TestMethod]
      public void RelationTypeCache_Update_Returns_Null()
      {
         // Arrange
         var expected = 0;
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke().Returns(this._empty);
         ps.Invoke<string>().Returns(_emptyStrings);
         RelationTypeCache.Cache.Shell = ps;

         // Act
         RelationTypeCache.Update(null);

         // Assert
         Assert.AreEqual(expected, RelationTypeCache.Cache.Values.Count);
      }

      [TestMethod]
      public void RelationTypeCache_Update_With_Empty_List()
      {
         // Arrange
         var expected = 0;
         var ps = BaseTests.PrepPowerShell();
         RelationTypeCache.Cache.Shell = ps;

         // Act
         RelationTypeCache.Update(new Dictionary<string, string>());

         // Assert
         Assert.AreEqual(expected, RelationTypeCache.Cache.Values.Count);
      }

      [TestMethod]
      public void RelationTypeCache_Get_ReferenceName()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke().Returns(this._relations);
         ps.Invoke<string>().Returns(this._relationNames);
         RelationTypeCache.Cache.Shell = ps;

         var expected = "System.LinkTypes.Hierarchy-Reverse";

         // Force an update
         RelationTypeCache.Update(null);

         // Act
         var actual = RelationTypeCache.GetReferenceName("Parent");

         // Assert
         Assert.AreEqual(expected, actual);
      }

      [TestMethod]
      [ExpectedException(typeof(KeyNotFoundException))]
      public void RelationTypeCache_Get_ReferenceName_Throws_When_Not_Found()
      {
         // Arrange
         RelationTypeCache.Update(new Dictionary<string, string>() {
                { "key1", "value1"},
                { "key2", "value2"}
            });

         // Act
         var actual = RelationTypeCache.GetReferenceName("NonExistingName");

      }
   }
}
