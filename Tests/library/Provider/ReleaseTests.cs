using Microsoft.VisualStudio.TestTools.UnitTesting;
using NSubstitute;
using System.Collections.ObjectModel;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class ReleaseTests
   {
      [TestMethod]
      public void Release_Constructor()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-VSTeamRelease.json");

         // Act
         var target = new Release(obj[0], ps, "Project Name");

         // Assert
         Assert.AreEqual(259, target.Id, "Id");
         Assert.AreEqual("active", target.Status, "Status");
         Assert.AreEqual(259, target.ReleaseId, "ReleaseId");
         Assert.IsNotNull(target.Environments, "Environments");
         Assert.AreEqual("2", target.DefinitionId, "DefinitionId");
         Assert.AreEqual(0, target.Environments.Count, "Environments.Count");
         Assert.AreEqual("PTracker-CD", target.DefinitionName, "DefinitionName");
         Assert.AreEqual("00000000-0000-0000-0000-000000000000", target.ProjectId, "ProjectId");

         Assert.IsNotNull(target.Variables, "Variables");
         Assert.IsNotNull(target.ReleaseDefinition, "ReleaseDefinition");

         Assert.AreEqual("Test@Test.com", target.ModifiedBy.UniqueName, "ModifiedBy.UniqueName");
         Assert.AreEqual("Donovan Brown", target.CreatedBy.DisplayName, "CreatedBy.DisplayName");
         Assert.AreEqual("11/14/2019 12:56:09 am", target.CreatedOn.ToString("M/d/yyyy h:mm:ss tt").ToLower(), "CreatedOn.ToString()");

         Assert.AreEqual("Donovan Brown", target.CreatedByUser, "CreatedByUser");
         Assert.AreEqual("Donovan Brown", target.ModifiedByUser, "ModifiedByUser");
      }

      [TestMethod]
      public void Release_Constructor_Expand_Environments()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-VSTeamRelease-id178-expandEnvironments.json", false);

         // Act
         var target = new Release(obj[0], ps, "Project Name");

         // Assert
         Assert.AreEqual(178, target.Id, "Id");
         Assert.AreEqual("active", target.Status, "Status");
         Assert.AreEqual("Release-132", target.Name, "Name");
         Assert.IsNotNull(target.Environments, "Environments");
         Assert.AreEqual(19, target.Environments.Count, "Environments.Count");
         Assert.AreEqual("PTracker-CD", target.DefinitionName, "DefinitionName");

         Assert.IsNotNull(target.Variables, "Variables");
         Assert.IsNotNull(target.ReleaseDefinition, "ReleaseDefinition");

         Assert.AreEqual("test@test.com", target.ModifiedBy.UniqueName, "ModifiedBy.UniqueName");
         Assert.AreEqual("Donovan Brown", target.CreatedBy.DisplayName, "CreatedBy.DisplayName");
         Assert.AreEqual("7/13/2019 3:49:31 pm", target.CreatedOn.ToString("M/d/yyyy h:mm:ss tt").ToLower(), "CreatedOn.ToString()");
      }

      [TestMethod]
      public void Release_GetChildItem()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-VSTeamRelease-id178-expandEnvironments.json", false);
         var target = new Release(obj[0], ps, "Project Name");
         var envs = obj[0].GetValue<object[]>("environments");
         var environments = new Collection<PSObject>(envs.Select(e => PSObject.AsPSObject(e)).ToList());
         ps.Invoke().Returns(environments);

         // Act
         var children = target.GetChildItem();

         // Assert
         Assert.AreEqual(19, children.Length);
      }
   }
}
