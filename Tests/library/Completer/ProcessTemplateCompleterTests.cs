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
   public class ProcessTemplateCompleterTests
   {
      private readonly Collection<string> _templates = new Collection<string>() { "Agile", "CMMI", "Scrum", "Scrum With Space", "Basic" };

      [TestMethod]
      public void ProcessTemplateCompleter_Exercise()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         ps.Invoke<string>().Returns(this._templates);
         ProcessTemplateCache.Cache.Shell = ps;
         ProcessTemplateCache.Invalidate();

         var target = new ProcessTemplateCompleter(ps);
         var fakeBoundParameters = new Dictionary<string, string>();

         // Act
         var actual = target.CompleteArgument(string.Empty, string.Empty, string.Empty, null, fakeBoundParameters);

         // Assert
         Assert.AreEqual(5, actual.Count());
         var e = actual.GetEnumerator();
         e.MoveNext();
         Assert.AreEqual("Agile", e.Current.CompletionText, "Agile");
         e.MoveNext();
         Assert.AreEqual("CMMI", e.Current.CompletionText, "CMMI");
         e.MoveNext();
         Assert.AreEqual("Scrum", e.Current.CompletionText, "Scrum");
         e.MoveNext();
         Assert.AreEqual("'Scrum With Space'", e.Current.CompletionText, "Scrum With Space");
         e.MoveNext();
         Assert.AreEqual("Basic", e.Current.CompletionText, "Basic");
      }
   }
}
