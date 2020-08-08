using System.Collections.Generic;

namespace vsteam_lib
{
   /// <summary>
   /// Cache process template names to reduce the number of
   /// rest APIs calls needed for parameter completion / validation 
   /// </summary>
   public static class ProcessTemplateCache
   {
      internal static InternalCache Cache { get; } = new InternalCache();
      internal static bool HasCacheExpired => Cache.HasCacheExpired;
      
      public static void Invalidate() => Cache.Invalidate();

      public static void Update(IEnumerable<string> list)
      {
         // If a list is passed in use it. If not call Get-VSTeamProcess
         if (null == list)
         {
            Cache.Shell.Commands.Clear();

            list = Cache.Shell.AddCommand("Get-VSTeamProcess")
                              .AddCommand("Select-Object")
                              .AddParameter("ExpandProperty", "Name")
                              .AddCommand("Sort-Object")
                              .Invoke<string>();
         }

         Cache.Prime(list);
      }

      public static IEnumerable<string> GetCurrent()
      {
         if (HasCacheExpired)
         {
            Update(null);
         }

         return Cache.Values;
      }
   }
}
