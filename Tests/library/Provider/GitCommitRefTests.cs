using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class GitCommitRefTests
   {
      [TestMethod]
      public void GitCommitRefTests_Constructor()
      {
         // Arrange
         var obj = BaseTests.LoadJson("Get-VSTeamGitCommit.json");

         // Act
         var target = new GitCommitRef(obj[0], "Project Name");

         // Assert
         Assert.AreEqual(0, target.Adds, "Adds");
         Assert.AreEqual(3, target.Edits, "Edits");
         Assert.AreEqual(0, target.Deletes, "Deletes");
         Assert.AreEqual("Clean up.", target.Comment, "Comment");
         Assert.AreEqual("6843b66ef58214061b996508ae37a8bbd67a12c2", target.CommitId, "CommitId");
         Assert.AreEqual("https://dev.azure.com/Test/PeopleTracker/_git/Bakeoff/commit/6843b66ef58214061b996508ae37a8bbd67a12c2", target.RemoteUrl, "RemoteUrl");
         Assert.AreEqual("https://dev.azure.com/Test/00000000-0000-0000-0000-000000000000/_apis/git/repositories/00000000-0000-0000-0000-000000000000/commits/6843b66ef58214061b996508ae37a8bbd67a12c2", target.Url, "Url");


         Assert.IsNotNull(target.Author, "Author");
         Assert.IsNotNull(target.Committer, "Committer");
         Assert.AreEqual("Donovan Brown", target.Committer.Name, "Committer.Name");
         Assert.AreEqual("Test@Test.com", target.Committer.Email, "Committer.Email");
         Assert.AreEqual("8/8/2019 8:58:58 pm", target.Committer.Date.ToString("M/d/yyyy h:mm:ss tt").ToLower(), "Committer.Date");
      }
   }
}
