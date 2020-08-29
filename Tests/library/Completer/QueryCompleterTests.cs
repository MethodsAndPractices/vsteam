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
   public class QueryCompleterTests
   {
      private readonly Collection<string> _values = new Collection<string>() { "Query1", "Query 2" };

      [TestMethod]
      public void QueryCompleter_Exercise()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._values);
         QueryCache.Cache.Shell = ps;
         QueryCache.Invalidate();

         var target = new QueryCompleter(ps);
         var fakeBoundParameters = new Dictionary<string, string>();

         // Act
         var actual = target.CompleteArgument(string.Empty, string.Empty, string.Empty, null, fakeBoundParameters);

         // Assert
         Assert.AreEqual(2, actual.Count());
         var e = actual.GetEnumerator();
         e.MoveNext();
         Assert.AreEqual("Query1", e.Current.CompletionText, "Query1");
         e.MoveNext();
         Assert.AreEqual("'Query 2'", e.Current.CompletionText, "Query 2");
      }
   }
}
