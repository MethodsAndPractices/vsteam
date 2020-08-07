using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Management.Automation.Abstractions;

namespace vsteam_lib
{
   /// <summary>
   /// Cache process template names to reduce the number of
   /// rest APIs calls needed for parameter completion / validation 
   /// </summary>
   public static class ProcessTemplateCache
   {
      public static double TimeStamp { get; set; } = -1;
      public static List<string> Templates { get; set; } = new List<string>();

      /// <summary>
      /// Used for unit testing
      /// </summary>
      internal static IPowerShell _powerShell;

      [ExcludeFromCodeCoverage]
      public static IPowerShell Shell
      {
         get
         {
            if (_powerShell == null)
            {
               _powerShell = new PowerShellWrapper(RunspaceMode.CurrentRunspace);
            }

            return _powerShell;
         }

         set => _powerShell = value;
      }

      public static bool HasCacheExpired => TimeStamp != DateTime.UtcNow.TimeOfDay.TotalMinutes;

      public static void Update(IEnumerable<string> list)
      {
         // If a list is passed in use it. If not call Get-VSTeamProcess
         if (null == list)
         {
            Shell.Commands.Clear();

            list = Shell.AddCommand("Get-VSTeamProcess")
                        .AddCommand("Select-Object")
                        .AddParameter("ExpandProperty", "Name")
                        .AddCommand("Sort-Object")
                        .Invoke<string>();
         }

         if (null != list)
         {
            Templates.Clear();
            foreach (var item in list)
            {
               Templates.Add(item);
            }
         }
         else
         {
            Templates = new List<string>();
         }

         TimeStamp = DateTime.UtcNow.TimeOfDay.TotalMinutes;
      }

      public static IEnumerable<string> GetCurrent()
      {
         if (HasCacheExpired)
         {
            Update(null);
         }

         return Templates;
      }

      public static void Invalidate() => TimeStamp = -1;
   }
}
