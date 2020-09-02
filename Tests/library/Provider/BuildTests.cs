using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class BuildTests
   {
      [TestMethod]
      public void Build_Constructor()
      {
         // Arrange
         var obj = BaseTests.LoadJson("Get-VSTeamBuild.json");

         // Act
         var actual = new Build(obj[0], "Project Name");

         // Assert
         Assert.IsNotNull(actual.RequestedBy, "RequestedBy");
         Assert.IsNotNull(actual.RequestedFor, "RequestedFor");
         Assert.AreEqual("completed", actual.Status, "Status");
         Assert.AreEqual("succeeded", actual.Result, "Result");
         Assert.IsNotNull(actual.LastChangedBy, "LastChangedBy");
         Assert.AreEqual("568", actual.BuildNumber, "BuildNumber");
         Assert.AreEqual("PTracker-CI", actual.BuildDefinition, "BuildDefinition");
         Assert.AreEqual("11/14/2019 12:49:37 AM", actual.StartTime.ToString(), "startTime");

         Assert.AreEqual("Test@test.com", actual.RequestedBy.UniqueName, "RequestedBy.UniqueName");
         Assert.AreEqual("Donovan Brown", actual.RequestedFor.DisplayName, "RequestedFor.DisplayName");
         Assert.AreEqual("Microsoft.VisualStudio.Services.ReleaseManagement", actual.LastChangedBy.ToString(), "LastChangedBy.ToString()");
      }
   }
}
