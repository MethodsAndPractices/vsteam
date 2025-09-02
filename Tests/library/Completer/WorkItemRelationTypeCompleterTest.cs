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
   public class WorkItemRelationTypeCompleterTest
   {

        private readonly Collection<string> _values = new Collection<string>() { "Produces For", "Predecessor", "Parent" };

        private readonly Collection<PSObject> _relationObjects = new Collection<PSObject>() {
         PSObject.AsPSObject(new {Name = "Produces For", ReferenceName = "System.LinkTypes.Remote.Dependency-Forward" }),
         PSObject.AsPSObject(new {Name = "Predecessor", ReferenceName = "System.LinkTypes.Dependency-Reverse" }),
         PSObject.AsPSObject(new {Name = "Parent", ReferenceName = "System.LinkTypes.Hierarchy-Reverse" })
      };


        private readonly Dictionary<string, string> _relations = new Dictionary<string, string> {

         { "'Produces For'", "System.LinkTypes.Remote.Dependency-Forward" },
         { "Predecessor", "System.LinkTypes.Dependency-Reverse" },
         { "Parent", "System.LinkTypes.Hierarchy-Reverse" }
      };

      [TestMethod]
      public void WorkImteRelations_Exercise()
      {
            // Arrange
            var ps = BaseTests.PrepPowerShell();
            ps.Invoke().Returns(this._relationObjects);
            ps.Invoke<string>(this._relationObjects).Returns(this._values);
            RelationTypeCache.Cache.Shell = ps;
            RelationTypeCache.Invalidate();

            var target = new WorkItemRelationTypeCompleter(ps);
            var fakeBoundParameters = new Dictionary<string, string>();

            // Act
            var actual = target.CompleteArgument(string.Empty, string.Empty, "P", null, fakeBoundParameters);

            // Assert
            Assert.AreEqual(_relations.Count, actual.Count());
            var e = actual.GetEnumerator();
            foreach (var relation in _relations)
            {
                e.MoveNext();
                Assert.AreEqual(relation.Key, e.Current.CompletionText);
            }
             

      }
   }
}
