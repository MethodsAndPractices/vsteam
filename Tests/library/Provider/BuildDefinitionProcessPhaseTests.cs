using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Management.Automation;

namespace vsteam_lib.Test.Provider
{
   [Microsoft.VisualStudio.TestTools.UnitTesting.TestClass]
   public class BuildDefinitionProcessPhaseTests
   {
      [TestMethod]
      public void GetChildren()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("Get-BuildDefinition_AzD.json");
         var buildDef = new BuildDefinition(obj[0], "Project Name", ps);
         var target = (PSObject)buildDef.GetChildItem()[0];

         // Act
         var actual = ((BuildDefinitionProcessPhase)target.ImmediateBaseObject).GetChildItem();

         // Assert
         Assert.AreEqual(4, actual.Length);
      }
   }
}
