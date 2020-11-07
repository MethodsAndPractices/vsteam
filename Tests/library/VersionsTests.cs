using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Diagnostics.CodeAnalysis;

namespace vsteam_lib.Test
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class VersionsTests
   {
      [TestMethod]
      [DataTestMethod]
      [DataRow("BuildV1", APIs.Build)]
      [DataRow("ReleaseV1", APIs.Release)]
      [DataRow("CoreV1", APIs.Core)]
      [DataRow("GitV1", APIs.Git)]
      [DataRow("DistributedTaskV1", APIs.DistributedTask)]
      [DataRow("DistributedTaskReleasedV1", APIs.DistributedTaskReleased)]
      [DataRow("Pipelines", APIs.Pipelines)]
      [DataRow("VariableGroupsV1", APIs.VariableGroups)]
      [DataRow("TfvcV1", APIs.Tfvc)]
      [DataRow("PackagingV1", APIs.Packaging)]
      [DataRow("MemberEntitlementManagementV1", APIs.MemberEntitlementManagement)]
      [DataRow("ExtensionsManagementV1", APIs.ExtensionsManagement)]
      [DataRow("ServiceEndpointsV1", APIs.ServiceEndpoints)]
      [DataRow("GraphV1", APIs.Graph)]
      [DataRow("TaskGroupsV1", APIs.TaskGroups)]
      [DataRow("PolicyV1", APIs.Policy)]
      [DataRow("HierarchyQuery", APIs.HierarchyQuery)]
      [DataRow("ProcessesV1", APIs.Processes)]
      [DataRow("TFS2017", APIs.Version)]
      public void Versions_ChangeServiceVersions(string expected, APIs version)
      {
         // Arrange
         Versions.SetApiVersion(version, expected);

         // Act
         var actual = Versions.GetApiVersion(version);

         // Assert
         Assert.AreEqual(expected, actual);
      }
   }
}
