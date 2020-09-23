using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class DescriptorTests
   {
      [TestMethod]
      public void DescriptorTests_Constructor()
      {
         // Arrange
         var obj = BaseTests.LoadJson("descriptor.scope.TestProject.json", false);
         var n = System.Environment.NewLine;
         var expectedLinks = $"Self: https://vssps.dev.azure.com/test/_apis/Graph/Descriptors/010d06f0-00d5-472a-bb47-58947c230876{n}StorageKey: https://vssps.dev.azure.com/test/_apis/Graph/StorageKeys/scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2{n}Subject: https://vssps.dev.azure.com/test/_apis/Graph/Scopes/scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2{n}";

         // Act
         var target = new Descriptor(obj[0]);

         // Assert
         Assert.IsNotNull(target.Links, "Links");
         Assert.AreEqual(expectedLinks, target.Links.ToString(), "ToString");
         Assert.AreEqual("scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2", target.Name, "Name");
         Assert.AreEqual("scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2", target.ToString(), "ToString");
         Assert.AreEqual("https://vssps.dev.azure.com/test/_apis/Graph/Scopes/scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2", target.Links.Subject, "Links.Subject");
      }
   }
}
