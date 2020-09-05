using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class ProcessTests
   {
      [TestMethod]
      public void Process_Constructor()
      {
         // Arrange
         var obj = BaseTests.LoadJson("Get-VSTeamProcess.json");

         // Act
         var target = new Process(obj[0]);

         // Assert
         Assert.AreEqual("Scrum", target.Name, "Name");
         Assert.AreEqual("system", target.Type, "Type");
         Assert.AreEqual(true, target.IsEnabled, "IsEnabled");
         Assert.AreEqual(false, target.IsDefault, "IsDefault");
         Assert.AreEqual("Scrum", target.ToString(), "ToString()");
         Assert.AreEqual("Scrum", target.ProcessTemplate, "ProcessTemplate");
         Assert.AreEqual("6b724908-ef14-45cf-84f8-768b5384da45", target.Id, "Id");
         Assert.AreEqual("6b724908-ef14-45cf-84f8-768b5384da45", target.TypeId, "TypeId");
         Assert.AreEqual("00000000-0000-0000-0000-000000000000", target.ParentProcessTypeId, "ParentProcessTypeId");
         Assert.AreEqual("This template is for teams who follow the Scrum framework.", target.Description, "Description");
      }
   }
}
