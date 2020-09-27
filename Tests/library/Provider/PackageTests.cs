using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class PackageTests
   {
      [TestMethod]
      public void Package_Constructor()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-VSTeamPackage.json");

         // Act
         var actual = new Package(obj[2], "MyFeed", ps);

         // Assert
         Assert.AreEqual("VSTeam", actual.Name, "Name");
         Assert.AreEqual("MyFeed", actual.FeedId, "FeedId");
         Assert.AreEqual("NuGet", actual.ProtocolType, "ProtocolType");
         Assert.AreEqual("vsteam", actual.NormalizedName, "NormalizedName");
         Assert.AreEqual(Guid.Parse("6c163345-4ec5-0000-84a9-2693e6f066d0"), actual.Id, "Id");
         Assert.AreEqual("https://feeds.dev.azure.com/Test/_apis/Packaging/Feeds/76045f1e-5b7c-0000-9ea5-df04e6b6c3f3/Packages/6c163345-4ec5-0000-84a9-2693e6f066d0", actual.Url, "Url");

         Assert.IsNotNull(actual.Links, "Links");
         Assert.IsNotNull(actual.Versions, "versions");
      }
   }
}
