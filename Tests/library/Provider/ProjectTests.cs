using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;
using vsteam_lib.Provider;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class ProjectTests
   {
      [TestMethod]
      public void Project_Constructor()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-VSTeamProject.json");

         // Act
         var target = new Project(obj[0], ps);

         // Assert
         Assert.AreEqual(159, target.Revision, "Revision");
         Assert.AreEqual("Voting-App", target.Name, "Name");
         Assert.AreEqual("wellFormed", target.State, "State");
         Assert.IsNotNull(target.InternalObject, "InternalObject");
         Assert.AreEqual("private", target.Visibility, "Visibility");
         Assert.AreEqual("Voting-App", target.ToString(), "ToString()");
         Assert.AreEqual("Vote App", target.Description, "Description");
         Assert.AreEqual("Voting-App", target.ProjectName, "ProjectName");
         Assert.AreEqual("00000000-0000-0000-0000-000000000001", target.Id, "Id");
         Assert.AreEqual("https://dev.azure.com/Test/_apis/projects/00000000-0000-0000-0000-000000000001", target.Url, "Url");
      }

      [TestMethod]
      public void Project_GetChildItem()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-VSTeamProject.json");
         var target = new Project(obj[0], ps);

         // Act
         var actual = target.GetChildItem();

         // Assert
         Assert.AreEqual(7, actual.Length);
         Assert.AreEqual("Build Definitions", ((Directory)actual[0]).Name);
         Assert.AreEqual("Builds", ((Directory)actual[1]).Name);
         Assert.AreEqual("Queues", ((Directory)actual[2]).Name);
         Assert.AreEqual("Release Definitions", ((Directory)actual[3]).Name);
         Assert.AreEqual("Releases", ((Releases)actual[4]).Name);
         Assert.AreEqual("Repositories", ((Directory)actual[5]).Name);
         Assert.AreEqual("Teams", ((Directory)actual[6]).Name);
      }
   }
}
