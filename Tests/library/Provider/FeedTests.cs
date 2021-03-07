using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class FeedTests
   {
      [TestMethod]
      public void Feed_Constructor()
      {
         // Arrange
         var obj = BaseTests.LoadJson("Get-VSTeamFeed.json");

         // Act
         var actual = new Feed(obj[0]);

         // Assert
         Assert.AreEqual("ber", actual.Name, "Name");
         Assert.AreEqual(null, actual.Description, "Description");
         Assert.AreEqual(true, actual.UpstreamEnabled, "UpstreamEnaabled");
         Assert.AreEqual("00000000-0000-0000-0000-000000000001", actual.Id, "Id");
         Assert.AreEqual("00000000-0000-0000-0000-000000000001", actual.FeedId, "FeedId");
         Assert.AreEqual("https://feeds.dev.azure.com/Test/_apis/Packaging/Feeds/00000000-0000-0000-0000-000000000000", actual.Url, "Url");

         Assert.IsNotNull(actual.UpstreamSources, "UpstreamSources");
         Assert.AreEqual(4, actual.UpstreamSources.Count, "UpstreamSources.Count");

         Assert.AreEqual("npmjs", actual.UpstreamSources[0].Name, "Name");
         Assert.AreEqual("ok", actual.UpstreamSources[0].Status, "Status");
         Assert.AreEqual("npm", actual.UpstreamSources[0].Protocol, "Protocol");
         Assert.IsNotNull(actual.UpstreamSources[0].InternalObject, "InternalObject");
         Assert.AreEqual("00000000-0000-0000-0000-000000000010", actual.UpstreamSources[0].ID);
         Assert.AreEqual("public", actual.UpstreamSources[0].UpstreamSourceType, "UpstreamSourceType");
         Assert.AreEqual("https://registry.npmjs.org/", actual.UpstreamSources[0].Location, "Location");
         Assert.AreEqual("https://registry.npmjs.org/", actual.UpstreamSources[0].DisplayLocation, "DisplayLocation");
      }
   }
}
