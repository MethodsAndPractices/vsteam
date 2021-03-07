using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class SecurityNamespaceTests
   {
      [TestMethod]
      public void SecurityNamespaceTests_Constructor()
      {
         // Arrange
         var obj = BaseTests.LoadJson("Get-VSTeamSecurityNamespace.json");

         // Act
         var target = new SecurityNamespace(obj[0]);

         // Assert
         Assert.AreEqual("Analytics", target.Name, "Name");
         Assert.IsNull(target.ExtensionType, "ExtensionType");
         Assert.AreEqual(false, target.IsRemotable, "IsRemotable");
         Assert.AreEqual(30, target.SystemBitMask, "SystemBitMask");
         Assert.AreEqual(-1, target.ElementLength, "ElementLength");
         Assert.AreEqual(1, target.ReadPermission, "ReadPermission");
         Assert.AreEqual("/", target.SeparatorValue, "SeparatorValue");
         Assert.AreEqual("1", target.StructureValue, "StructureValue");
         Assert.AreEqual(2, target.WritePermission, "WritePermission");
         Assert.AreEqual("Analytics", target.DisplayName, "DisplayName");
         Assert.AreEqual(false, target.UseTokenTranslator, "UseTokenTranslator");
         Assert.AreEqual("Default", target.DataspaceCategory, "DataspaceCategory");

         Assert.AreEqual("Analytics", target.ToString(), "ToString()");

         Assert.IsNotNull(target.Actions, "Actions");
         Assert.AreEqual(5, target.Actions.Count, "Actions.Count");
         Assert.AreEqual(1, target.Actions[0].Bit, "Actions[0].Bit");
         Assert.AreEqual("Read", target.Actions[0].Name, "Actions[0].Name");
         Assert.AreEqual(Guid.Empty, target.Actions[0].NamespaceId, "Actions[0].NamespaceId");
         Assert.AreEqual("View analytics", target.Actions[0].DisplayName, "Actions[0].DisplayName");
      }
   }
}
