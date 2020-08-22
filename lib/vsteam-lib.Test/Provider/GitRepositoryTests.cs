using Microsoft.VisualStudio.TestTools.UnitTesting;
using NSubstitute;

namespace vsteam_lib.Test.Provider
{
   [Microsoft.VisualStudio.TestTools.UnitTesting.TestClass]
   public class GitRepositoryTests
   {
      [TestMethod]
      public void Constructor()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("./SampleFiles/Get-VSTeamGitRepository.json");

         // Act
         var actual = new GitRepository(obj[0], "Project Name", ps);

         // Assert
         Assert.IsNotNull(actual.Project, "Project");
         Assert.AreEqual(1939413, actual.Size, "Size");
         Assert.AreEqual("Bakeoff", actual.Name, "Name");
         Assert.AreEqual("00000000-0000-0000-0000-000000000001", actual.Id, "Id");
         Assert.AreEqual("refs/heads/master", actual.DefaultBranch, "DefaultBranch");
         Assert.AreEqual("https://dev.azure.com/Test/0/_apis/git/repositories/0", actual.Url, "Url");
         Assert.AreEqual("git@ssh.dev.azure.com:v3/Test/PeopleTracker/Bakeoff", actual.SSHUrl, "SSHUrl");
         Assert.AreEqual("https://Test@dev.azure.com/Test/PeopleTracker/_git/Bakeoff", actual.RemoteUrl, "RemoteUrl");
      }

      [TestMethod]
      public void Get_ChildItem()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var gitRefs = BaseTests.LoadJson("./SampleFiles/Get-VSTeamGitRef.json");
         var obj = BaseTests.LoadJson("./SampleFiles/Get-VSTeamGitRepository.json");
         var target = new GitRepository(obj[0], "Project Name", ps);

         ps.Invoke().Returns(gitRefs);

         // Act
         var actual = target.GetChildItem();

         // Assert
         Assert.AreEqual(1, actual.Length);
         ps.Received().AddCommand("Get-VSTeamGitRef");
      }
   }
}
