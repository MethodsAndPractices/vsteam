using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;

namespace vsteam_lib.Provider
{
   public static class PSObjectExtensionMethods
   {
      public static IList<string> GetStringArray(this PSObject obj, string name)
      {
         var values = new List<string>();

         if (obj.HasValue(name))
         {
            foreach (var item in ((object[])obj.Properties[name].Value))
            {
               values.Add(item.ToString());
            }

            return values;
         }

         return null;
      }

      public static string GetValue(this PSObject obj, string name)
      {
         // See if the name contains a period. If so you have to 
         // drill down to the object. Everything before the final
         // object treat as a PSObject
         var parts = name.Split('.');

         if (parts.Length > 1)
         {
            var nextObj = obj;

            for (var i = 0; i < parts.Length - 1; i++)
            {
               nextObj = nextObj.GetValue<PSObject>(parts[i]);
            }

            return nextObj.Properties[parts[parts.GetUpperBound(0)]]?.Value.ToString();
         }
         else
         {
            // The property might be null and the value of the property might 
            // be null. Protect for both with two ?. below.
            return obj.Properties[name]?.Value?.ToString();
         }
      }

      /// <summary>
      /// Depending on what version of an API you call not all properties are returned.
      /// This method does all the testing to if the property is there and if so returns
      /// the value.
      /// </summary>
      /// <typeparam name="T">the type of the value to return</typeparam>
      /// <param name="obj">the PSObject returned by PowerShell</param>
      /// <param name="name">name of the property to get return</param>
      /// <returns>The value if present or the default value of T</returns>
      public static T GetValue<T>(this PSObject obj, string name)
      {
         var result = default(T);
         var typeofT = typeof(T);
         var baseType = Nullable.GetUnderlyingType(typeofT);
         var isNullable = baseType != null;

         // See if the name contains a period. If so you have to 
         // drill down to the object. Everything before the final
         // object treat as a PSObject
         var parts = name.Split('.');

         if (parts.Length > 1)
         {
            var nextObj = obj;

            for (var i = 0; i < parts.Length - 1; i++)
            {
               nextObj = nextObj.GetValue<PSObject>(parts[i]);
            }

            // nextObj could be null if the property is not found
            if (nextObj != null)
            {
               result = nextObj.GetValue<T>(parts[parts.GetUpperBound(0)]);
            }
         }
         else
         {
            if (obj.Properties.Match(name).Count > 0)
            {
               if (typeofT == typeof(string))
               {
                  object temp = obj.Properties[name].Value.ToString();

                  // This allows any type to be returned as a string
                  result = (T)System.Convert.ChangeType(temp, typeofT);
               }
               else
               {
                  // I am using Change Type as a backup because depending on 
                  // the version of PowerShell you are using some items are 
                  // returned as an int32 or int64 for the same property. This 
                  // should catch any invalid cast exceptions and still convert.
                  // I can't use Change Type for everything because it is 
                  // invalid to cast from a DateTime to a null-able DateTime but 
                  // a direct cast works. So try a direct cast and if that fails.
                  // I also noticed DateTimes coming across as string in 
                  // PowerShell 5 but DateTimes in PowerShell 7. 
                  var temp = obj.Properties[name].Value;
                  try
                  {
                     result = (T)temp;
                  }
                  catch (System.InvalidCastException ivce)
                  {
                     System.Diagnostics.Debug.WriteLine(ivce.Message);

                     // Change Type cannot change to a null-able Type. So see if
                     // this is a null-able type.
                     if (isNullable)
                     {
                        switch (baseType.Name)
                        {
                           case "DateTime":
                              object tempDate = DateTime.Parse(temp.ToString());
                              result = (T)tempDate;
                              break;
                        }
                     }
                     else
                     {
                        result = (T)System.Convert.ChangeType(temp, typeofT);
                     }
                  }
               }
            }
         }

         return result;
      }
      
      public static bool HasValue(this PSObject obj, string name) => obj.Properties.Match(name).Count > 0;

      /// <summary>
      /// The type is used to identify the correct formatter to use.
      /// The format for when it is returned by the function and
      /// returned by the provider are different. Adding a type name
      /// identifies how to format the type.
      /// When returned by calling the function and not the provider.
      /// This will be formatted without a mode column.
      /// When returned by calling the provider.
      /// This will be formatted with a mode column like a file or
      /// directory.
      /// </summary>
      /// <param name="obj"></param>
      /// <param name="typeName"></param>
      public static void AddTypeName(this PSObject obj, string typeName)
      {
         if (!obj.TypeNames.Contains(typeName))
         {
            obj.TypeNames.Insert(0, typeName);
         }
      }

      public static PSObject[] AddTypeName(this IEnumerable<object> list, string typeName)
      {
         var items = list.Select(s => PSObject.AsPSObject(s)).ToArray();

         Array.ForEach(items, s => s.AddTypeName(typeName));

         return items;
      }
   }
}
