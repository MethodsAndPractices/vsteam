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
   public class QueueCompleterTests
   {
      private readonly Collection<string> _values = new Collection<string>() { "Item1", "Item 2" };

      [TestMethod]
      public void QueueCompleter_Exercise()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._values);
         QueryCache.Cache.Shell = ps;
         QueryCache.Invalidate();

         var target = new QueueCompleter(ps);
         var fakeBoundParameters = new Dictionary<string, string>();

         // Act
         var actual = target.CompleteArgument(string.Empty, string.Empty, string.Empty, null, fakeBoundParameters);

         // Assert
         Assert.AreEqual(2, actual.Count());
         var e = actual.GetEnumerator();
         e.MoveNext();
         Assert.AreEqual("Item1", e.Current.CompletionText, "Item1");
         e.MoveNext();
         Assert.AreEqual("'Item 2'", e.Current.CompletionText, "Item 2");
      }
   }
}
