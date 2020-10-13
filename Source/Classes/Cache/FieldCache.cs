using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace vsteam_lib
{
   public static class FieldCache
   {
      internal static InternalCache Cache { get; } = new InternalCache("Get-VSTeamField", "referenceName", true);

      internal static bool HasCacheExpired => Cache.HasCacheExpired;
      internal static Dictionary<string, string> ShortNames { get; } = new Dictionary<string, string>();
      internal static Dictionary<string, string> RefNames { get; } = new Dictionary<string, string>();
      public static void Invalidate() => Cache.Invalidate();

      public static void Update(IEnumerable<string> list)
      {
         RefNames.Clear();
         ShortNames.Clear();
         // If a list is passed in use it. If not call Get-VSTeamField
         if (null == list)
         {
            // this to test we are logged on, not because we need the project
            var projectName = Common.GetDefaultProject(Cache.Shell);

            if (!string.IsNullOrEmpty(projectName))
            {
               Cache.Shell.Commands.Clear();

               var fields = Cache.Shell.AddCommand("Get-VSTeamField")
                                        .Invoke();

               // Setup RefNames so we can do a case insensitive Lookup of a short name to the reference name. 
               Regex afterLastDot = new Regex(@"^.*\.(.+)$");
               foreach (var field in fields)
               {
                  string fieldRefName = field.Properties["referenceName"].Value.ToString();
                  string shortname = afterLastDot.Replace(fieldRefName,"$1");
                  RefNames.Add(fieldRefName.ToLower(), fieldRefName);
                  ShortNames.Add(shortname.ToLower(), fieldRefName);
               }

               // This will return just the names
               list = Cache.Shell.AddCommand("Select-Object")
                                 .AddParameter("ExpandProperty", "referenceName")
                                 .AddCommand("Sort-Object")
                                 .Invoke<string>(fields);
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

      public static string GetRefName(string name)
      {
         if (RefNames.Count == 0) 
         {
            Update(null);
         }
         if (ShortNames.Keys.Contains(name.ToLower()))
         {
            name = ShortNames[name.ToLower()];
         }
         if (RefNames.Keys.Contains(name.ToLower()))
         {
            name = RefNames[name.ToLower()];
         }

         return name;
         
      }
   }
}
