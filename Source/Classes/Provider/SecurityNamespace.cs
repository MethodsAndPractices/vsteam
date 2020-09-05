using System.Collections;
using System.Collections.Generic;
using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class SecurityNamespace : Leaf
   {
      public string DisplayName { get; set; }
      public string SeparatorValue { get; set; }
      public long ElementLength { get; set; }
      public long WritePermission { get; set; }
      public long ReadPermission { get; set; }
      public string DataspaceCategory { get; set; }
      public string StructureValue { get; set; }
      public string ExtensionType { get; set; }
      public bool IsRemotable { get; set; }
      public bool UseTokenTranslator { get; set; }
      public long SystemBitMask { get; set; }
      public IList<Action> Actions { get; }

      public SecurityNamespace(PSObject obj) :
         base(obj, obj.GetValue("name"), obj.GetValue("namespaceId"), null)
      {
         this.Actions = new List<Action>();

         foreach (var item in obj.GetValue<object[]>("actions"))
         {
            this.Actions.Add(new Action((PSObject)item));
         }
      }

      public override string ToString() => this.Name;
   }
}
