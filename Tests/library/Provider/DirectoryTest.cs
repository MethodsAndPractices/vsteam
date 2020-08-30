﻿using Microsoft.VisualStudio.TestTools.UnitTesting;
using NSubstitute;
using System.Diagnostics.CodeAnalysis;
using vsteam_lib.Provider;

namespace vsteam_lib.Test.Provider
{
   [TestClass]
   [ExcludeFromCodeCoverage]
   public class DirectoryTest
   {
      [TestMethod]
      public void Get_VSTeamPool()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("../../../../SampleFiles/Get-VSTeamPool.json");

         ps.Invoke().Returns(obj);

         var target = new Directory("Agent Pools", "Pool", ps);

         // Act
         var actual = target.GetChildItem();

         // Assert
         Assert.AreEqual(12, actual.Length);
         ps.Received().AddCommand("Sort-Object");
         ps.Received().AddCommand("Get-VSTeamPool");
         ps.DidNotReceive().AddParameter("ProjectName");
      }

      [TestMethod]
      public void Has_ProjectName()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();
         var obj = BaseTests.LoadJson("../../../../SampleFiles/Get-VSTeamPool.json");

         ps.Invoke().Returns(obj);

         var target = new Directory(null, "Agent Pools", "Pool", ps, "MyProject");

         // Act
         var actual = target.GetChildItem();

         // Assert
         Assert.AreEqual(12, actual.Length);
         ps.Received().AddCommand("Sort-Object");
         ps.Received().AddCommand("Get-VSTeamPool");
         ps.Received().AddParameter("ProjectName", "MyProject");
      }

      [TestMethod]
      public void Get_VSTeam()
      {
         // Arrange
         var ps = BaseTests.PrepPowerShell();

         // Act
         var target = new Directory("Teams", "Team", ps);

         // Assert
         Assert.AreEqual("Get-VSTeam", target.Command);
      }
   }
}