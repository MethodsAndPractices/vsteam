using Microsoft.VisualStudio.TestTools.UnitTesting;
using NSubstitute;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;

namespace vsteam_lib.Test
{
    [TestClass]
    [ExcludeFromCodeCoverage]
    public class RelationTypeToReferenceNameAttributeTest
    {

        private readonly Collection<string> _relationNames = new Collection<string>() { "Produces For", "Predecessor", "Parent" };
        private readonly Collection<PSObject> _relations = new Collection<PSObject>() {
             PSObject.AsPSObject(new {Name = "Produces For", ReferenceName = "System.LinkTypes.Remote.Dependency-Forward" }),
             PSObject.AsPSObject(new {Name = "Predecessor", ReferenceName = "System.LinkTypes.Dependency-Reverse" }),
             PSObject.AsPSObject(new {Name = "Parent", ReferenceName = "System.LinkTypes.Hierarchy-Reverse" })
        };

        [TestMethod]
        public void RelationTypeTransformToReferenceNameAttribute_Null()
        {
            // Arrange
            string expected = null;
            var target = new RelationTypeToReferenceNameAttribute();

            // Act
            var actual = target.Transform(null, null);

            // Assert
            Assert.AreEqual(expected, actual);
        }

        [TestMethod]
        [ExpectedException(typeof(KeyNotFoundException))]
        public void RelationTypeTransformToReferenceNameAttribute_Name_Not_Found()
        {
            // Arrange
            var target = new RelationTypeToReferenceNameAttribute();

            var ps = BaseTests.PrepPowerShell();
            ps.Invoke().Returns(this._relations);
            ps.Invoke<string>(this._relations).Returns(this._relationNames);
            RelationTypeCache.Cache.Shell = ps;

            // Act
            var actual = target.Transform(null, "NonExistingName");
        }

    }
}
