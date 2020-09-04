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

         // Act
         var target = new Descriptor(obj[0]);

         // Assert
         Assert.IsNotNull(target.Links, "Links");
         Assert.AreEqual("scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2", target.ToString(), "ToString");
         Assert.AreEqual("https://vssps.dev.azure.com/test/_apis/Graph/Scopes/scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2", target.Links.Subject, "Links.Subject");
      }
   }
}
