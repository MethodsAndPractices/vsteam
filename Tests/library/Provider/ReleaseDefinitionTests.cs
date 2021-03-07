using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class ReleaseDefinitionTests
   {
      [TestMethod]
      public void ReleaseDefinition_Constructor()
      {
         // Arrange
         var obj = BaseTests.LoadJson("Get-VSTeamReleaseDefinition-ReleaseId40.json", false);

         // Act
         var actual = new ReleaseDefinition(obj[0], "Project Name");

         // Assert
         Assert.IsNotNull(actual.Tags, "Tags");
         Assert.IsNotNull(actual.Triggers, "Triggers");
         Assert.IsNotNull(actual.Variables, "Variables");
         Assert.IsNotNull(actual.Environments, "Environments");
         Assert.IsNotNull(actual.VariableGroups, "VariableGroups");

         Assert.IsNotNull(actual.Artifacts, "Artifacts");
         Assert.IsNotNull(actual.CreatedBy, "CreatedBy");
         Assert.IsNotNull(actual.ModifiedBy, "ModifiedBy");
         Assert.IsNotNull(actual.Properties, "Properties");


         Assert.IsFalse(actual.IsDeleted, "IsDeleted");

         Assert.IsNotNull(actual.Links, "Links");
         Assert.IsNotNull(actual.Links.InternalObject, "Links.InternalObject");
         Assert.AreEqual("https://dev.azure.com/fabrikam/00000000-0000-0000-0000-000000000000/_release?definitionId=40", actual.Links.Web, "Links.Web");

         Assert.AreEqual("40", actual.Id, "Id");
         Assert.AreEqual("\\", actual.Path, "Path");
         Assert.AreEqual(1, actual.Revision, "Revision");
         Assert.AreEqual("Fabrikam-web", actual.Name, "Name");
         Assert.AreEqual(null, actual.Description, "Description");
         Assert.AreEqual("", actual.ReleaseNameFormat, "ReleaseNameFormat");
         Assert.AreEqual("Chuck Reinhart", actual.CreatedByUser, "CreatedByUser");
         Assert.AreEqual("ReleaseDefinition", actual.ResourceType, "ResourceType");
         Assert.AreEqual("12/11/2018 4:48:42 am", actual.CreatedOn.ToString("M/d/yyyy h:mm:ss tt").ToLower(), "CreatedOn");
         Assert.AreEqual("12/11/2018 4:48:42 am", actual.ModifiedOn.ToString("M/d/yyyy h:mm:ss tt").ToLower(), "ModifiedOn");
         Assert.AreEqual("https://vsrm.dev.azure.com/fabrikam/00000000-0000-0000-0000-000000000000/_apis/Release/definitions/40", actual.Url, "Url");
      }

      [TestMethod]
      public void ReleaseDefinition_Constructor_NoEnvs()
      {
         // Arrange
         var obj = BaseTests.LoadJson("Get-VSTeamReleaseDefinition.json");

         // Act
         var actual = new ReleaseDefinition(obj[0], "Project Name");

         // Assert
         Assert.IsNull(actual.Tags, "Tags");
         Assert.IsNull(actual.Triggers, "Triggers");
         Assert.IsNull(actual.Variables, "Variables");
         Assert.IsNull(actual.Environments, "Environments");
         Assert.IsNull(actual.VariableGroups, "VariableGroups");

         Assert.IsNotNull(actual.Artifacts, "Artifacts");
         Assert.IsNotNull(actual.CreatedBy, "CreatedBy");
         Assert.IsNotNull(actual.ModifiedBy, "ModifiedBy");
         Assert.IsNotNull(actual.Properties, "Properties");

         Assert.IsTrue(actual.IsDeleted, "IsDeleted");

         Assert.IsNotNull(actual.Links, "Links");
         Assert.IsNotNull(actual.Links.InternalObject, "Links.InternalObject");
         Assert.AreEqual("https://dev.azure.com/Test/00000000-0000-0000-0000-000000000000/_release?definitionId=2", actual.Links.Web, "Links.Web");

         Assert.AreEqual("2", actual.Id, "Id");
         Assert.AreEqual("\\", actual.Path, "Path");
         Assert.AreEqual(118, actual.Revision, "Revision");
         Assert.AreEqual("PTracker-CD", actual.Name, "Name");
         Assert.AreEqual(null, actual.Description, "Description");
         Assert.AreEqual("Donovan Brown", actual.CreatedByUser, "CreatedByUser");
         Assert.AreEqual("Release-$(rev:r)", actual.ReleaseNameFormat, "ReleaseNameFormat");
         Assert.AreEqual("3/24/2019 4:46:08 pm", actual.CreatedOn.ToString("M/d/yyyy h:mm:ss tt").ToLower(), "CreatedOn");
         Assert.AreEqual("9/16/2019 2:32:37 pm", actual.ModifiedOn.ToString("M/d/yyyy h:mm:ss tt").ToLower(), "ModifiedOn");
         Assert.AreEqual("https://vsrm.dev.azure.com/Test/00000000-0000-0000-0000-000000000000/_apis/Release/definitions/2", actual.Url, "Url");
      }
   }
}
