using System.Collections.Generic;

namespace vsteam_lib
{
   /// <summary>
   /// Cache process template names to reduce the number of
   /// rest APIs calls needed for parameter completion / validation 
   /// </summary>
   public static class ProcessTemplateCache
   {
      internal static InternalCache Cache { get; } = new InternalCache("Get-VSTeamProcess", "Name", false);

      internal static bool HasCacheExpired => Cache.HasCacheExpired;

      public static void Invalidate() => Cache.Invalidate();

      public static void Update(IEnumerable<string> list) => Cache.Update(list);

      public static IEnumerable<string> GetCurrent() => Cache.GetCurrent();
   }
}
