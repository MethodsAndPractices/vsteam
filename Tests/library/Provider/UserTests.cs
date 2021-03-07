using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class UserTests
   {
      [TestMethod]
      public void User_Constructor_Without_MetaType()
      {
         // Arrange
         var obj = BaseTests.LoadJson("Get-VSTeamUser.json");

         // Act
         var target = new User(obj[0]);

         // Assert
         Assert.AreEqual("vsts", target.Origin, "Origin");
         Assert.AreEqual(null, target.MetaType, "MetaTaype");
         Assert.AreEqual("AgentPool", target.Domain, "Domain");
         Assert.AreEqual("", target.MailAddress, "MailAddress");
         Assert.AreEqual(null, target.ProjectName, "ProjectName");
         Assert.IsNotNull(target.InternalObject, "InternalObject");
         Assert.AreEqual("user", target.SubjectKind, "SubjectKind");
         Assert.AreEqual("redacted", target.Descriptor, "Descriptor");
         Assert.AreEqual("Agent Pool Service (10)", target.DisplayName, "DisplayName");
         Assert.AreEqual("00000000-0000-0000-0000-000000000001", target.OriginId, "OriginId");
         Assert.AreEqual("00000000-0000-0000-0000-000000000011", target.PrincipalName, "PrincipalName");
         Assert.AreEqual("https://vssps.dev.azure.com/Test/_apis/Graph/Users/redacted", target.Url, "Url");

         Assert.IsNotNull(target.Links, "Links");
         Assert.IsNotNull(target.Links.InternalObject, "Links.InternalObject");
         Assert.AreEqual("https://vssps.dev.azure.com/Test/_apis/Graph/Users/redacted", target.Links.Self, "Links.Self");
         Assert.AreEqual("https://vssps.dev.azure.com/Test/_apis/Graph/Memberships/redacted", target.Links.Memberships, "Links.Memberships");
         Assert.AreEqual("https://vssps.dev.azure.com/Test/_apis/Graph/MembershipStates/redacted", target.Links.MembershipState, "Links.MembershipState");
         Assert.AreEqual("https://vssps.dev.azure.com/Test/_apis/Graph/StorageKeys/redacted", target.Links.StorageKey, "Links.StorageKey");
         Assert.AreEqual("https://dev.azure.com/Test/_apis/GraphProfile/MemberAvatars/redacted", target.Links.Avatar, "Links.Avatar");
      }

      [TestMethod]
      public void User_Constructor_With_MetaType()
      {
         // Arrange
         var obj = BaseTests.LoadJson("Get-VSTeamUser.json");

         // Act
         var target = new User(obj[3]);

         // Assert
         Assert.AreEqual("aad", target.Origin, "Origin");
         Assert.AreEqual("member", target.MetaType, "MetaType");
         Assert.AreEqual(null, target.ProjectName, "ProjectName");
         Assert.IsNotNull(target.InternalObject, "InternalObject");
         Assert.AreEqual("user", target.SubjectKind, "SubjectKind");
         Assert.AreEqual("Redacted", target.Descriptor, "Descriptor");
         Assert.AreEqual("Donovan Brown", target.DisplayName, "DisplayName");
         Assert.AreEqual("Redacted", target.MemberDescriptor, "MemberDescriptor");
         Assert.AreEqual("test@microsoft.com", target.MailAddress, "MailAddress");
         Assert.AreEqual("test@microsoft.com", target.PrincipalName, "PrincipalName");
         Assert.AreEqual("00000000-0000-0000-0000-000000000088", target.Domain, "Domain");
         Assert.AreEqual("00000000-0000-0000-0000-000000000008", target.OriginId, "OriginId");
         Assert.AreEqual("https://vssps.dev.azure.com/Test/_apis/Graph/Users/Redacted", target.Url, "Url");

         Assert.IsNotNull(target.Links, "Links");
         Assert.IsNotNull(target.Links.InternalObject, "Links.InternalObject");
         Assert.AreEqual("https://vssps.dev.azure.com/Test/_apis/Graph/Users/Redacted", target.Links.Self, "Links.Self");
         Assert.AreEqual("https://vssps.dev.azure.com/Test/_apis/Graph/Memberships/Redacted", target.Links.Memberships, "Links.Memberships");
         Assert.AreEqual("https://vssps.dev.azure.com/Test/_apis/Graph/MembershipStates/Redacted", target.Links.MembershipState, "Links.MembershipState");
         Assert.AreEqual("https://vssps.dev.azure.com/Test/_apis/Graph/StorageKeys/Redacted", target.Links.StorageKey, "Links.StorageKey");
         Assert.AreEqual("https://dev.azure.com/Test/_apis/GraphProfile/MemberAvatars/Redacted", target.Links.Avatar, "Links.Avatar");
      }
   }
}
