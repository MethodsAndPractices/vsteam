using System.Collections.Generic;
using System.Linq;

namespace vsteam_lib
{
   public static class QueryCache
   {
      internal static InternalCache Cache { get; } = new InternalCache("Get-VSTeamQuery", "Name", true);

      internal static bool HasCacheExpired => Cache.HasCacheExpired;
      internal static Dictionary<string, string> Ids { get; } = new Dictionary<string, string>();

      public static void Invalidate() => Cache.Invalidate();

      public static void Update(IEnumerable<string> list)
      {
         Ids.Clear();

         // If a list is passed in use it. If not call Get-VSTeamProcess
         if (null == list)
         {
            var projectName = Common.GetDefaultProject(Cache.Shell);

            if (!string.IsNullOrEmpty(projectName))
            {
               Cache.Shell.Commands.Clear();

               // Use this to store the ids
               var queries = Cache.Shell.AddCommand("Get-VSTeamQuery")
                                        .AddParameter("ProjectName", projectName)
                                        .Invoke();

               foreach (var query in queries)
               {
                  Ids.Add(query.Properties["Name"].Value.ToString(), query.Properties["Id"].Value.ToString());
               }

               // This will return just the names
               list = Cache.Shell.AddCommand("Select-Object")
                                 .AddParameter("ExpandProperty", "Name")
                                 .AddCommand("Sort-Object")
                                 .Invoke<string>(queries);
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

      public static string GetId(string name)
      {
         if (Ids.Keys.Contains(name))
         {
            return Ids[name];
         }

         return name;
      }
   }
}
