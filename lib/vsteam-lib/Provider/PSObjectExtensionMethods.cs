using System.Management.Automation;

namespace vsteam_lib.Provider
{
   public static class PSObjectExtensionMethods
   {
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
         // See if the name contains a period. If so you have to 
         // drill down to the object. Everything before the final
         // object treat as a PSObject
         var parts = name.Split('.');

         if (parts.Length > 1)
         {
            var nextObj = new PSObject();

            for (var i = 0; i < parts.Length - 1; i++)
            {
               nextObj = obj.GetValue<PSObject>(parts[i]);
            }

            return nextObj.GetValue<T>(parts[parts.GetUpperBound(0)]);
         }
         else
         {
            if (obj.Properties.Match(name).Count > 0)
            {
               if (typeof(T) == typeof(string))
               {
                  object temp = obj.Properties[name].Value.ToString();

                  // This allows any type to be returned as a string
                  return (T)temp;
               }
               else
               {
                  return (T)obj.Properties[name].Value;
               }
            }
         }

         return default;
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
      public static void AddTypeName(this PSObject obj, string typeName) => obj.TypeNames.Insert(0, typeName);
   }
}
