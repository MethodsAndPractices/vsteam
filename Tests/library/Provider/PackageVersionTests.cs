using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class PackageVersionTests
   {
      [TestMethod]
      public void PackageVersion_Constructor()
      {
         // Arrange
         var obj = BaseTests.LoadJson("Get-VSTeamPackageVersion.json");
         var expectedDesc = "Adds functionality for working with Visual Studio Team Services and Team Foundation Server.";
         var expectedUrl = "https://feeds.dev.azure.com/LoECDA/_apis/Packaging/Feeds/76045f1e-5b7c-0000-9ea5df04e6b6c3f3/Packages/6c163345-4ec5-0000-84a92693e6f066d0/Versions/998abe34-23de-0000-9668b73891e2dada";

         // Act
         var actual = new PackageVersion(obj[0]);

         // Assert
         Assert.IsTrue(actual.IsLatest, "IsLatest");
         Assert.IsTrue(actual.IsListed, "IsListed");
         Assert.AreEqual(expectedUrl, actual.Url, "Url");
         Assert.AreEqual("1137.0.0", actual.Version, "version");
         Assert.AreEqual("@DonovanBrown", actual.Author, "author");
         Assert.AreEqual(expectedDesc, actual.Description, "Description");
         Assert.AreEqual("998abe34-23de-0000-9668b73891e2dada", actual.Id, "Id");
         Assert.AreEqual("9/7/2018 1:33:39 pm", actual.PublishDate.ToString("M/d/yyyy h:mm:ss tt").ToLower(), "PublishDate");
      }
   }
}
