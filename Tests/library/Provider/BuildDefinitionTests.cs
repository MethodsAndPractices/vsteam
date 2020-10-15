using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class BuildDefinitionTests
   {
      [TestMethod]
      public void BuildDefinition_Constructor_2017_Git()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-BuildDefinition_2017.json");

         // Act
         var actual = new BuildDefinition(obj[0], "Project Name", ps);

         // Assert
         Assert.IsNull(actual.Tags, "Tags");
         Assert.IsNull(actual.Demands, "Demands");

         Assert.IsNotNull(actual.Queue, "Queue");
         Assert.IsNotNull(actual.Variables, "Variables");
         Assert.IsNotNull(actual.AuthoredBy, "AuthoredBy");
         Assert.IsNotNull(actual.Repository, "Repository");
         Assert.IsNotNull(actual.GitRepository, "GitRepository");
         Assert.IsNotNull(actual.RetentionRules, "RetentionRules");

         Assert.AreEqual("BuildDefinition", actual.ResourceType, "ResourceType");

         Assert.AreEqual(5, actual.JobCancelTimeoutInMinutes, "JobCancelTimeoutInMinutes");
         Assert.AreEqual("projectCollection", actual.JobAuthorizationScope, "JobAuthorizationScope");
         Assert.AreEqual("$(date:yyyyMMdd)$(rev:.r)", actual.BuildNumberFormat, "BuildNumberFormat");

         Assert.AreEqual("8/23/2020 3:12:41 pm", actual.CreatedOn.ToString("M/d/yyyy h:mm:ss tt").ToLower(), "CreatedOn");

         Assert.IsNotNull(actual.Options, "Options");
         Assert.AreEqual(4, actual.Options.Count, "Options.Count");

         Assert.IsNull(actual.Triggers, "Triggers");

         Assert.AreEqual(17, actual.Id, "Id");
         Assert.AreEqual("CI", actual.Name, "Name");
         Assert.AreEqual("\\", actual.Path, "Path");
         Assert.AreEqual(1, actual.Revision, "Revision");

         Assert.AreEqual("CI", actual.ToString(), "ToString()");

         Assert.IsNull(actual.Process, "Process");

         Assert.IsNotNull(actual.Steps, "Steps");
         Assert.AreEqual(5, actual.Steps.Count, "Steps.Count");

         // Testing BuildDefinitionProcessPhaseStep properties
         Assert.IsNotNull(actual.Steps[0].Task, "Steps[0].Task");
         Assert.IsNotNull(actual.Steps[0].Inputs, "Steps[0].Inputs");
         Assert.AreEqual(true, actual.Steps[0].Enabled, "Steps[0].Enabled");
         Assert.AreEqual(null, actual.Steps[0].Condition, "Steps[0].Condition");
         Assert.AreEqual(false, actual.Steps[0].AlwaysRun, "Steps[0].AlwaysRun");
         Assert.AreEqual("NuGet restore", actual.Steps[0].Name, "Steps[0].Name");
         Assert.AreEqual(0, actual.Steps[0].TimeoutInMinutes, "Steps[0].TimeoutInMinutes");
         Assert.AreEqual(false, actual.Steps[0].ContinueOnError, "Steps[0].ContinueOnError");
      }

      [TestMethod]
      public void BuildDefinition_GetChildItem_2017_Git()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-BuildDefinition_2017.json");
         var target = new BuildDefinition(obj[0], "Project Name", ps);

         // Act
         var actual = target.GetChildItem();

         // Assert
         Assert.IsNotNull(actual);
         Assert.AreEqual(5, actual.Length);
      }

      [TestMethod]
      public void BuildDefinition_Constructor_2017_Tfvc()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-BuildDefinition_2017.json");

         // Act
         var actual = new BuildDefinition(obj[1], "Project Name", ps);

         // Assert
         Assert.IsNull(actual.Tags, "Tags");

         Assert.IsNotNull(actual.Demands, "Demands");
         Assert.AreEqual(1, actual.Demands.Count, "Demands.Count");

         Assert.IsNotNull(actual.Queue, "Queue");
         Assert.IsNotNull(actual.Variables, "Variables");
         Assert.IsNotNull(actual.AuthoredBy, "AuthoredBy");
         Assert.IsNotNull(actual.Repository, "Repository");
         Assert.IsNull(actual.GitRepository, "GitRepository");
         Assert.IsNotNull(actual.RetentionRules, "RetentionRules");

         Assert.AreEqual("8/23/2020 10:30:31 pm", actual.CreatedOn.ToString("M/d/yyyy h:mm:ss tt").ToLower(), "CreatedOn");

         Assert.AreEqual(5, actual.JobCancelTimeoutInMinutes, "JobCancelTimeoutInMinutes");
         Assert.AreEqual("projectCollection", actual.JobAuthorizationScope, "JobAuthorizationScope");
         Assert.AreEqual("$(date:yyyyMMdd)$(rev:.r)", actual.BuildNumberFormat, "BuildNumberFormat");
   
         Assert.IsNotNull(actual.Options, "Options");
         Assert.AreEqual(4, actual.Options.Count, "Options.Count");

         Assert.IsNull(actual.Triggers, "Triggers");

         Assert.AreEqual(18, actual.Id, "Id");
         Assert.AreEqual("\\", actual.Path, "Path");
         Assert.AreEqual("TFVC-CI", actual.Name, "Name");
         Assert.AreEqual(2, actual.Revision, "Revision");

         Assert.IsNull(actual.Process, "Process");
      }

      [TestMethod]
      public void BuildDefinition_Constructor_2018()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-BuildDefinition_2018.json");

         // Act
         var actual = new BuildDefinition(obj[0], "Project Name", ps);

         // Assert
         Assert.IsNotNull(actual.Tags, "Tags");
         Assert.AreEqual(0, actual.Tags.Count, "Tags.Count");

         Assert.IsNull(actual.Demands, "Demands");

         Assert.IsNotNull(actual.Queue, "Queue"); 
         Assert.IsNotNull(actual.Variables, "Variables");
         Assert.IsNotNull(actual.AuthoredBy, "AuthoredBy");
         Assert.IsNotNull(actual.Repository, "Repository");
         Assert.IsNotNull(actual.GitRepository, "GitRepository");
         Assert.IsNotNull(actual.RetentionRules, "RetentionRules");

         Assert.AreEqual("8/23/2020 3:16:22 pm", actual.CreatedOn.ToString("M/d/yyyy h:mm:ss tt").ToLower(), "CreatedOn");

         Assert.AreEqual(5, actual.JobCancelTimeoutInMinutes, "JobCancelTimeoutInMinutes");
         Assert.AreEqual("projectCollection", actual.JobAuthorizationScope, "JobAuthorizationScope"); 
         Assert.AreEqual("$(date:yyyyMMdd)$(rev:.r)", actual.BuildNumberFormat, "BuildNumberFormat");

         Assert.IsNotNull(actual.Options, "Options");
         Assert.AreEqual(2, actual.Options.Count, "Options.Count");

         Assert.IsNull(actual.Triggers, "Triggers");

         Assert.AreEqual(27, actual.Id, "Id");
         Assert.AreEqual("CI", actual.Name, "Name");
         Assert.AreEqual("\\", actual.Path, "Path");
         Assert.AreEqual(1, actual.Revision, "Revision");

         Assert.IsNotNull(actual.Process, "Process");
         Assert.AreEqual(1, actual.Process.Phases.Count, "Process.Steps.Count");
         Assert.AreEqual("Number of phases: 1", actual.Process.ToString(), "Process.ToString()");

         Assert.IsNotNull(actual.Process.Phases[0].Steps, "Process.Phases[0].Steps");
         Assert.IsNotNull(actual.Process.Phases[0].Target, "Process.Phases[0].Target");
         Assert.AreEqual(6, actual.Process.Phases[0].StepCount, "Process.Phases[0].StepsCount");
         Assert.AreEqual(6, actual.Process.Phases[0].Steps.Count, "Process.Phases[0].Steps.Count");
         Assert.AreEqual("succeeded()", actual.Process.Phases[0].Condition, "Process.Phases[0].Condition");
         Assert.AreEqual(1, actual.Process.Phases[0].JobCancelTimeoutInMinutes, "Process.Phases[0].JobCancelTimeoutInMinutes");
         Assert.AreEqual("projectCollection", actual.Process.Phases[0].JobAuthorizationScope, "Process.Phases[0].JobAuthorizationScope");
      }

      [TestMethod]
      public void BuildDefinition_GetChildItem_2018()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-BuildDefinition_2018.json");
         var target = new BuildDefinition(obj[0], "Project Name", ps);

         // Act
         var actual = target.GetChildItem();

         // Assert
         Assert.IsNotNull(actual, "actual");
      }

      [TestMethod]
      public void BuildDefinition_Constructor_AzD_Classic()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-BuildDefinition_AzD.json");

         // Act
         var actual = new BuildDefinition(obj[0], "Project Name", ps);

         // Assert
         Assert.IsNotNull(actual.Tags, "Tags");
         Assert.AreEqual(0, actual.Tags.Count, "Tags.Count");

         Assert.IsNull(actual.Demands, "Demands");

         Assert.AreEqual("9/16/2019 2:34:16 am", actual.CreatedOn.ToString("M/d/yyyy h:mm:ss tt").ToLower(), "CreatedOn");

         // Not on this build def
         Assert.AreEqual(null, actual.BuildNumberFormat, "BuildNumberFormat");
         Assert.AreEqual(5, actual.JobCancelTimeoutInMinutes, "JobCancelTimeoutInMinutes");
         Assert.AreEqual("projectCollection", actual.JobAuthorizationScope, "JobAuthorizationScope");

         Assert.IsNotNull(actual.Queue, "Queue");
         Assert.IsNotNull(actual.Variables, "Variables");
         Assert.IsNotNull(actual.AuthoredBy, "AuthoredBy");
         Assert.IsNotNull(actual.Repository, "Repository");
         Assert.IsNotNull(actual.GitRepository, "GitRepository");
         Assert.IsNotNull(actual.RetentionRules, "RetentionRules");

         Assert.IsNotNull(actual.Options, "Options");
         Assert.AreEqual(2, actual.Options.Count, "Options.Count");

         Assert.IsNotNull(actual.Triggers, "Triggers");
         Assert.AreEqual(1, actual.Triggers.Count, "Triggers.Count");

         Assert.AreEqual(23, actual.Id, "Id");
         Assert.AreEqual("\\", actual.Path, "Path");
         Assert.AreEqual("PTracker-CI", actual.Name, "Name");
         Assert.AreEqual(163, actual.Revision, "Revision");

         Assert.IsNotNull(actual.Process, "Process");
         Assert.IsNotNull(actual.Process.Phases, "Process.Phases");
      }

      [TestMethod]
      public void BuildDefinition_GetChildItem_AzD_Classic()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-BuildDefinition_AzD.json");
         var target = new BuildDefinition(obj[0], "Project Name", ps);

         // Act
         var actual = target.GetChildItem();

         // Assert
         Assert.IsNotNull(actual, "actual");
         Assert.AreEqual(4, actual.Length);
      }

      [TestMethod]
      public void BuildDefinition_Constructor_AzD_YAML()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-BuildDefinition_AzD.json");

         // Act
         var actual = new BuildDefinition(obj[7], "Project Name", ps);

         // Assert
         Assert.IsNotNull(actual.Tags, "Tags");
         Assert.AreEqual(2, actual.Tags.Count, "Tags.Count");

         Assert.IsNull(actual.Demands, "Demands");

         Assert.AreEqual("9/25/2019 8:55:54 pm", actual.CreatedOn.ToString("M/d/yyyy h:mm:ss tt").ToLower(), "CreatedOn");

         // Not on this build def
         Assert.AreEqual(0, actual.JobCancelTimeoutInMinutes, "JobCancelTimeoutInMinutes");
         Assert.AreEqual("projectCollection", actual.JobAuthorizationScope, "JobAuthorizationScope");
         Assert.AreEqual("$(date:yyyyMMdd)$(rev:.r)", actual.BuildNumberFormat, "BuildNumberFormat");

         Assert.IsNotNull(actual.Queue, "Queue");
         Assert.IsNotNull(actual.Variables, "Variables");
         Assert.IsNotNull(actual.AuthoredBy, "AuthoredBy");
         Assert.IsNotNull(actual.Repository, "Repository");
         Assert.IsNull(actual.RetentionRules, "RetentionRules");
         Assert.IsNotNull(actual.GitRepository, "GitRepository");

         Assert.IsNull(actual.Options, "Options");
         
         Assert.IsNotNull(actual.Triggers, "Triggers");
         Assert.AreEqual(1, actual.Triggers.Count, "Triggers.Count");

         Assert.AreEqual(46, actual.Id, "Id");
         Assert.AreEqual("\\Vars", actual.Path, "Path");
         Assert.AreEqual("Vars CI", actual.Name, "Name");
         Assert.AreEqual(1, actual.Revision, "Revision");

         Assert.IsNotNull(actual.Process, "Process");
         Assert.IsNull(actual.Process.Phases, "Process.Phases");
         Assert.AreEqual("/azure-pipelines.yml", actual.Process.ToString(), "Process.ToString()");
      }

      [TestMethod]
      public void BuildDefinition_GetChildItem_AzD_YAML()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-BuildDefinition_AzD.json");
         var target = new BuildDefinition(obj[7], "Project Name", ps);

         // Act
         var actual = target.GetChildItem();

         // Assert
         Assert.IsNotNull(actual, "actual");
         Assert.AreEqual(1, actual.Length, "actual.Length");
      }
   }
}
