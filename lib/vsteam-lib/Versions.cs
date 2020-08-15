using System;

namespace vsteam_lib
{
   public enum APIs
   {
      Build, Release, Core, Git, DistributedTask, DistributedTaskReleased,
      VariableGroups, Tfvc, Packaging, MemberEntitlementManagement,
      ExtensionsManagement, ServiceEndpoints, Graph, TaskGroups, Policy,
      Processes, Version
   }

   public static class Versions
   {
      public static string GetApiVersion(APIs service)
      {
         switch (service)
         {
            case APIs.Build:
               return Build;
            case APIs.Release:
               return Release;
            case APIs.Core:
               return Core;
            case APIs.Git:
               return Git;
            case APIs.DistributedTask:
               return DistributedTask;
            case APIs.DistributedTaskReleased:
               return DistributedTaskReleased;
            case APIs.VariableGroups:
               return VariableGroups;
            case APIs.Tfvc:
               return Tfvc;
            case APIs.Packaging:
               return Packaging;
            case APIs.MemberEntitlementManagement:
               return MemberEntitlementManagement;
            case APIs.ExtensionsManagement:
               return ExtensionsManagement;
            case APIs.ServiceEndpoints:
               return ServiceEndpoints;
            case APIs.Graph:
               return Graph;
            case APIs.TaskGroups:
               return TaskGroups;
            case APIs.Policy:
               return Policy;
            case APIs.Processes:
               return Processes;
            default:
               return Version;
         }
      }

      public static bool TestGraphSupport() => !string.IsNullOrEmpty(Versions.GetApiVersion(APIs.Graph));

      public static string Account { get; set; } = Environment.GetEnvironmentVariable("TEAM_ACCT");
      public static string DefaultTimeout { get; set; } = Environment.GetEnvironmentVariable("TEAM_TIMEOUT");
      public static string DefaultProject { get; set; } = Environment.GetEnvironmentVariable("TEAM_PROJECT");
      public static string Version { get; set; } = Environment.GetEnvironmentVariable("TEAM_VERSION") ?? "TFS2017";
      public static string Git { get; set; } = "3.0";
      public static string Core { get; set; } = "3.0";
      public static string Build { get; set; } = "3.0";
      public static string Release { get; set; } = "3.0-preview";
      public static string DistributedTask { get; set; } = "3.0-preview";
      public static string DistributedTaskReleased { get; set; } = "";
      public static string VariableGroups { get; set; } = "";
      public static string TaskGroups { get; set; } = "3.0-preview";
      public static string Tfvc { get; set; } = "3.0";
      public static string Packaging { get; set; } = "3.0-preview";
      public static string MemberEntitlementManagement { get; set; } = "";
      public static string ExtensionsManagement { get; set; } = "";
      public static string ServiceEndpoints { get; set; } = "3.0-preview";
      public static string ModuleVersion { get; set; } = null;
      public static string Graph { get; set; } = "";
      public static string Policy { get; set; } = "3.0";
      public static string Processes { get; set; } = "";
   }
}
