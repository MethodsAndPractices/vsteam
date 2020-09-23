using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class QueryTransformToIDAttributeTests
   {
      [TestMethod]
      public void QueryTransformToIDAttribute_Null()
      {
         // Arrange
         string expected = null;
         var target = new QueryTransformToIDAttribute();

         // Act
         var actual = target.Transform(null, null);

         // Assert
         Assert.AreEqual(expected, actual);
      }

      [TestMethod]
      public void QueryTransformToIDAttribute_ID_Not_Found()
      {
         // Arrange
         string expected = "UnitTest";
         var target = new QueryTransformToIDAttribute();

         // Act
         var actual = target.Transform(null, "UnitTest");

         // Assert
         Assert.AreEqual(expected, actual);
      }

      [TestMethod]
      public void QueryTransformToIDAttribute_GUID_Passed_In()
      {
         // Arrange
         string expected = "24a9d798-5ad3-4130-840d-1368f2103cdb";
         var target = new QueryTransformToIDAttribute();

         // Act
         var actual = target.Transform(null, "24a9d798-5ad3-4130-840d-1368f2103cdb");

         // Assert
         Assert.AreEqual(expected, actual);
      }
   }
}
