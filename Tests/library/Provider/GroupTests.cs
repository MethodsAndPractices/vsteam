using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class GroupTests
   {
      [TestMethod]
      public void Group_Constructor()
      {
         // Arrange
         var obj = BaseTests.LoadJson("Get-VSTeamGroup.json");

         // Act
         var target = new Group(obj[0]);

         // Assert
         Assert.AreEqual("vsts", target.Origin, "Origin");
         Assert.AreEqual(null, target.MailAddress, "MailAddress");
         Assert.IsNotNull(target.InternalObject, "InternalObject");
         Assert.AreEqual("Test", target.ProjectName, "ProjectName");
         Assert.AreEqual("group", target.SubjectKind, "SubjectKind");
         Assert.AreEqual("redacted", target.Descriptor, "Descriptor");
         Assert.AreEqual("redacted",  target.ContainerDescriptor, "ContainerDescriptor");
         Assert.AreEqual("00000000-0000-0000-0000-000000000000", target.OriginId, "OriginId");
         Assert.AreEqual("Project Collection Build Administrators", target.DisplayName, "DisplayName");
         Assert.AreEqual("https://vssps.dev.azure.com/Test/_apis/Graph/Groups/redacted", target.Url, "Url");
         Assert.AreEqual("[Test]\\Project Collection Build Administrators", target.PrincipalName, "PrincipalName");
         Assert.AreEqual("vstfs:///Framework/IdentityDomain/00000000-0000-0000-0000-000000000000", target.Domain, "Domain");
         Assert.AreEqual("Members of this group should include accounts for people who should be able to administer the build resources.", target.Description, "Description");




      Assert.IsNotNull(target.Links, "Links");
         Assert.IsNotNull(target.Links.InternalObject, "Links.InternalObject");
         Assert.AreEqual("https://vssps.dev.azure.com/Test/_apis/Graph/Groups/redacted", target.Links.Self, "Links.Self");
         Assert.AreEqual("https://vssps.dev.azure.com/Test/_apis/Graph/Memberships/redacted", target.Links.Memberships, "Links.Memberships");
         Assert.AreEqual("https://vssps.dev.azure.com/Test/_apis/Graph/MembershipStates/redacted", target.Links.MembershipState, "Links.MembershipState");
         Assert.AreEqual("https://vssps.dev.azure.com/Test/_apis/Graph/StorageKeys/redacted", target.Links.StorageKey, "Links.StorageKey");
      }
   }
}
