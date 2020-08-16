using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using System.Xml.Serialization;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public static class Common
   {
      public static string GetDefaultProject(IPowerShell powerShell)
      {
         powerShell.Commands.Clear();

         var results = powerShell.AddScript("$Global:PSDefaultParameterValues[\"*-vsteam*:projectName\"]")
                                 .Invoke<string>();

         PowerShellWrapper.LogPowerShellError(powerShell, results);

         return results[0];
      }

      public static void MoveProperties(object target, PSObject source)
      {
         foreach (var prop in target.GetType().GetProperties())
         {
            if (prop.GetSetMethod() == null)
            {
               continue;
            }

            var propertyName = prop.Name;

            // See if there is an attribute to help get more information
            var attrib = (XmlAttributeAttribute)prop.GetCustomAttributes(false).FirstOrDefault(a => a is XmlAttributeAttribute);

            if (attrib != null)
            {
               propertyName = attrib.AttributeName;
            }

            // If this is a nested property (contains a .) let it through
            if (source.HasValue(propertyName) || propertyName.IndexOf(".") != -1)
            {
               prop.SetValue(target, source.GetValue<object>(propertyName));
            }
         }
      }
   }
}
