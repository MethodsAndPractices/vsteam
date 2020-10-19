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
   public class QueryCacheTests
   {
      private readonly Collection<PSObject> _empty = new Collection<PSObject>();
      private readonly Collection<string> _emptyStrings = new Collection<string>();
      private readonly Collection<string> _defaultProject = new Collection<string>() { "UnitTestProject" };
      private readonly Collection<string> _queryNames = new Collection<string>() { "Query1", "Query 2" };
      private readonly Collection<PSObject> _queries = new Collection<PSObject>() { PSObject.AsPSObject(new { Name = "Shared Queries", Id = "10000000-1000-1000-1000-100000000000" }),
                                                                                    PSObject.AsPSObject(new { Name = "My Queries", Id = "20000000-2000-2000-2000-200000000000" })};

      [TestMethod]
      public void QueryCache_HasCacheExpired()
      {
         // Arrange
         var expected = true;

         // Act
         QueryCache.Invalidate();

         // Assert
         Assert.AreEqual(expected, QueryCache.HasCacheExpired, "Cache should be expired");

         // Act
         QueryCache.Update(new List<string>());

         // Assert
         Assert.AreNotEqual(expected, QueryCache.HasCacheExpired, "Cache should not be expired");
      }

      [TestMethod]
      public void QueryCache_Update_With_Null_List()
      {
         // Arrange
         var expected = 2;
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke().Returns(this._queries);
         ps.Invoke<string>(this._queries).Returns(this._queryNames);
         ps.Invoke<string>().Returns(this._defaultProject, this._queryNames);
         QueryCache.Cache.Shell = ps;

         // Act
         QueryCache.Update(null);

         // Assert
         Assert.AreEqual(expected, QueryCache.Cache.Values.Count);
      }

      [TestMethod]
      public void QueryCache_GetCurrent()
      {
         // Arrange
         var expected = 2;
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke().Returns(this._queries);
         ps.Invoke<string>(this._queries).Returns(this._queryNames);

         ps.Invoke<string>().Returns(this._defaultProject, this._queryNames);
         QueryCache.Invalidate();
         QueryCache.Cache.Shell = ps;

         // Act
         var actual = QueryCache.GetCurrent();

         // Assert
         Assert.AreEqual(expected, actual.Count());
      }

      [TestMethod]
      public void QueryCache_Update_Returns_Null()
      {
         // Arrange
         var expected = 0;
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke().Returns(this._empty);
         ps.Invoke<string>().Returns(this._defaultProject, _emptyStrings);
         QueryCache.Cache.Shell = ps;

         // Act
         QueryCache.Update(null);

         // Assert
         Assert.AreEqual(expected, QueryCache.Cache.Values.Count);
      }

      [TestMethod]
      public void QueryCache_Update_With_Empty_List()
      {
         // Arrange
         var expected = 0;
         var ps = BaseTests.PrepPowerShell();
         QueryCache.Cache.Shell = ps;

         // Act
         QueryCache.Update(new List<string>());

         // Assert
         Assert.AreEqual(expected, QueryCache.Cache.Values.Count);
      }

      [TestMethod]
      public void QueryCache_Get_Query_ID()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke().Returns(this._queries);
         ps.Invoke<string>().Returns(this._defaultProject, this._queryNames);
         QueryCache.Cache.Shell = ps;

         var expected = "20000000-2000-2000-2000-200000000000";

         // Force an update
         QueryCache.Update(null);

         // Act
         var actual = QueryCache.GetId("My Queries");

         // Assert
         Assert.AreEqual(expected, actual);
      }

      [TestMethod]
      public void QueryCache_Get_Query_ID_Returns_Name_When_Not_Found()
      {
         // Arrange
         var expected = "My Queries";
         QueryCache.Update(new List<string>());

         // Act
         var actual = QueryCache.GetId("My Queries");

         // Assert
         Assert.AreEqual(expected, actual);
      }
   }
}
