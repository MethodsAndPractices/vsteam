using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class AccessControlEntryTests
   {
      [TestMethod]
      public void AccessControlEntry_Contructor()
      {
         // Arrange
         var obj = BaseTests.LoadJson("Get-VSTeamAccessControlList.json");
         var en = ((PSObject)obj[0].Properties["acesDictionary"].Value).Properties.GetEnumerator();
         en.MoveNext();
         var ace = (PSObject)en.Current.Value;

         // Act
         var target = new AccessControlEntry(ace);

         // Assert
         Assert.AreEqual(0, target.Deny, "Deny");
         Assert.AreEqual(1, target.Allow, "Allow");
         Assert.IsNotNull(target.ExtendedInfo, "ExtendedInfo");
         Assert.AreEqual("Microsoft.TeamFoundation.Identity;S-00000000-0000-0000-0000-000000000000-00000000-0000-0000-0000-000000000000-0-3", target.Descriptor, "Descriptor");
         Assert.AreEqual("Microsoft.TeamFoundation.Identity;S-00000000-0000-0000-0000-000000000000-00000000-0000-0000-0000-000000000000-0-3: Allow=1, Deny=0", target.ToString(), "ToString()");
      }
   }
}
