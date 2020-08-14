using System;

namespace vsteam_lib
{
   public static class Versions
   {
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
