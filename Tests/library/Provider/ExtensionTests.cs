using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class ExtensionTests
   {
      [TestMethod]
      public void Extension_Constructor()
      {
         // Arrange
         var obj = BaseTests.LoadJson("Get-VSTeamExtension.json");

         // Act
         var actual = new Extension(obj[0]);

         // Assert
         Assert.AreEqual("20200807.2", actual.Version, "Version");
         Assert.AreEqual("CloudTest", actual.PublisherName, "PublisherName");
         Assert.AreEqual("asg-cloudtest", actual.PublisherId, "PublisherId");
         Assert.AreEqual("asg-cloudtest-attachments", actual.ExtensionId, "ExtensionId");

         Assert.IsNotNull(actual.InstallState, "InstallState");
         Assert.AreEqual("none", actual.InstallState.Flags, "InstallState.Flags");
         Assert.IsNotNull(actual.InstallState.InternalObject, "InstallState.InternalObject");
         Assert.IsTrue(actual.InstallState.ToString().StartsWith("Flags: none, Last Updated: "), "InstallState.ToString()");
         Assert.AreEqual("8/10/2020 8:31:07 pm", actual.InstallState.LastUpdated.ToString("M/d/yyyy h:mm:ss tt").ToLower(), "InstallState.LastUpdated");
      }
   }
}
