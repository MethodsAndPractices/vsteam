using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class ClassificationNodeTests
   {
      [TestMethod]
      public void ClassificationNodeTests_Constructor()
      {
         // Arrange
         var obj = BaseTests.LoadJson("Get-VSTeamClassificationNode.json");

         // Act
         var target = new ClassificationNode(obj[1], "Project Name");

         // Assert
         Assert.IsNull(target.ParentUrl, "ParentUrl");
         Assert.IsNotNull(target.Children, "Children");
         Assert.AreEqual(true, target.HasChildren, "HasChildren");
         Assert.AreEqual(Guid.Empty, target.Identifier, "Identifier");
         Assert.AreEqual(target.Id, target.NodeId.ToString(), "NodeId");
         Assert.AreEqual("\\PeopleTracker\\Iteration", target.Path, "Path");
         Assert.AreEqual("iteration", target.StructureType, "StructureType");
         Assert.AreEqual("https://dev.azure.com/Test/00000000-0000-0000-0000-000000000000/_apis/wit/classificationNodes/Iterations", target.Url, "Url");
      }

      [TestMethod]
      public void ClassificationNodeTests_Constructor_ById()
      {
         // Arrange
         var obj = BaseTests.LoadJson("Get-VSTeamClassificationNode-depth3-ids82.json");

         // Act
         var target = new ClassificationNode(obj[0], "Project Name");

         // Assert
         Assert.IsNull(target.ParentUrl, "ParentUrl");
         Assert.IsNotNull(target.Children, "Children");
         Assert.AreEqual(true, target.HasChildren, "HasChildren");
         Assert.AreEqual(Guid.Empty, target.Identifier, "Identifier");
         Assert.AreEqual("\\PeopleTracker\\Iteration", target.Path, "Path");
         Assert.AreEqual("iteration", target.StructureType, "StructureType");
         Assert.AreEqual("https://dev.azure.com/Test/00000000-0000-0000-0000-000000000000/_apis/wit/classificationNodes/Iterations", target.Url, "Url");
      }

      [TestMethod]
      public void ClassificationNodeTests_Constructor_WithParent()
      {
         // Arrange
         var obj = BaseTests.LoadJson("Get-VSTeamClassificationNode-depth4-ids84.json");

         // Act
         var target = new ClassificationNode(obj[0], "Project Name");

         // Assert
         Assert.IsNull(target.Children, "Children");
         Assert.IsNotNull(target.ParentUrl, "ParentUrl");
         Assert.AreEqual(false, target.HasChildren, "HasChildren");
         Assert.AreEqual(Guid.Empty, target.Identifier, "Identifier");
         Assert.AreEqual("iteration", target.StructureType, "StructureType");
         Assert.AreEqual("\\PeopleTracker\\Iteration\\Sprint 1", target.Path, "Path");
         Assert.AreEqual("https://dev.azure.com/Test/00000000-0000-0000-0000-000000000000/_apis/wit/classificationNodes/Iterations/Sprint%201", target.Url, "Url");
         Assert.AreEqual("https://dev.azure.com/Test/00000000-0000-0000-0000-000000000000/_apis/wit/classificationNodes/Iterations", target.ParentUrl, "ParentUrl");
      }
   }
}
