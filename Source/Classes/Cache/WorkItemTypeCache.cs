using System.Collections.Generic;

namespace vsteam_lib
{
   /// <summary>
   /// Cache process template names to reduce the number of
   /// rest APIs calls needed for parameter completion / validation 
   /// </summary>
   public static class WorkItemTypeCache
   {
      /// <summary>
      /// This is where all the work is done. Every other call just delegates to this object.
      /// </summary>
      internal static InternalCache Cache { get; } = new InternalCache("Get-VSTeamWorkItemType", "Name", true);
      
      internal static bool HasCacheExpired => Cache.HasCacheExpired;

      public static void Invalidate() => Cache.Invalidate();

      public static void Update(IEnumerable<string> list) => Cache.Update(list);

      public static IEnumerable<string> GetCurrent() => Cache.GetCurrent();
   }
}
