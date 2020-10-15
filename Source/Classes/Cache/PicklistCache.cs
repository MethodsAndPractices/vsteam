using System.Collections.Generic;
using System.Linq;

namespace vsteam_lib
{
   public static class PickListCache
   {
      internal static InternalCache Cache { get; } = new InternalCache("Get-VSTeamPickList", "referenceName", true);

      internal static bool HasCacheExpired => Cache.HasCacheExpired;
      internal static Dictionary<string, string> IDs { get; } = new Dictionary<string, string>();
      public static void Invalidate() {
         Cache.Invalidate();
         IDs.Clear();
      }

      public static void Update(IEnumerable<string> list)
      {
         IDs.Clear();
         // If a list is passed in use it. If not call Get-VSTeamPickList
         if (null == list)
         {
            // this to test we are logged on, not because we need the project
            if (!string.IsNullOrEmpty(Versions.DefaultProject))
            {
               Cache.Shell.Commands.Clear();

               var pickLists = Cache.Shell.AddCommand("Get-VSTeamPickList")
                                        .Invoke();

               foreach (var pickList in pickLists)
               {
                  string picklistName = pickList.Properties["name"].Value.ToString();
                  string id = pickList.Properties["id"].Value.ToString();
                  IDs.Add(picklistName.ToLower(), id);
               }

               // This will return just the names
               list = Cache.Shell.AddCommand("Select-Object")
                                 .AddParameter("ExpandProperty", "name")
                                 .AddCommand("Sort-Object")
                                 .Invoke<string>(pickLists);
            }
         }
         Cache.PreFill(list);
      }

      public static IEnumerable<string> GetCurrent()
      {
         if (HasCacheExpired)
         {
            Update(null);
         }

         return Cache.Values;
      }

      public static string GetID(string name)
      {
         if (IDs.Count == 0)
         {
            Update(null);
         }
         if (IDs.Keys.Contains(name.ToLower()))
         {
            name = IDs[name.ToLower()];
         }

         return name;

      }
   }
}
