using System.Collections.Generic;
using System.Linq;

namespace vsteam_lib
{
   public static class RelationTypeCache
   {
      private const string commandName = "Get-VSTeamWorkItemRelationType";
      internal static InternalCache Cache { get; } = new InternalCache(commandName, "Name", false);

      internal static bool HasCacheExpired => Cache.HasCacheExpired;
      internal static Dictionary<string, string> ReferenceNames { get; } = new Dictionary<string, string>();

      public static void Invalidate() => Cache.Invalidate();

      public static void Update(Dictionary<string, string> cacheItems)
      {
         ReferenceNames.Clear();
         IEnumerable<string> list;

         // If a list is passed in use it. If not call Get-VSTeamWorkItemRelationType
         if (null == cacheItems)
         {
            Cache.Shell.Commands.Clear();

            // Use this to store the relationNames
            var relations = Cache.Shell.AddCommand(commandName)
                                    .AddParameter("Usage", "WorkItemLink")
                                    .Invoke();

            foreach (var relation in relations)
            {
               ReferenceNames.Add(relation.Properties["Name"].Value.ToString(), relation.Properties["ReferenceName"].Value.ToString());
            }

            // This will return just the names
            list = Cache.Shell.AddCommand("Select-Object")
                              .AddParameter("ExpandProperty", "Name")
                              .AddCommand("Sort-Object")
                              .Invoke<string>(relations);

         }
         else
         {
            foreach(var relation in cacheItems) {
               ReferenceNames.Add(relation.Key, relation.Value);
            }
            list = cacheItems.Keys;
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

      public static string GetReferenceName(string name)
      {
         return ReferenceNames[name];
      }
   }
}
