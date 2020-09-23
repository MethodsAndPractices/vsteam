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
   public class ProjectCompleterTests
   {
      private readonly Collection<string> _values = new Collection<string>() { "Project1", "Project 2" };

      [TestMethod]
      public void ProjectCompleter_Exercise()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._values);
         ProjectCache.Cache.Shell = ps;
         ProjectCache.Invalidate();

         var target = new ProjectCompleter(ps);
         var fakeBoundParameters = new Dictionary<string, string>();

         // Act
         var actual = target.CompleteArgument(string.Empty, string.Empty, string.Empty, null, fakeBoundParameters);

         // Assert
         Assert.AreEqual(2, actual.Count());
         var e = actual.GetEnumerator();
         e.MoveNext();
         Assert.AreEqual("Project1", e.Current.CompletionText, "Project1");
         e.MoveNext();
         Assert.AreEqual("'Project 2'", e.Current.CompletionText, "Project 2");
      }
   }
}
