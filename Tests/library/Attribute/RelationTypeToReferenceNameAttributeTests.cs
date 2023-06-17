using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test
{
    [TestClass]
    [ExcludeFromCodeCoverage]
    public class RelationTypeToReferenceNameAttributeTest
    {
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

            // Act
            var actual = target.Transform(null, "NonExistingName");
        }

    }
}
