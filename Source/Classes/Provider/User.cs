using System.Management.Automation;

namespace vsteam_lib
{
   public class User : SecurityLeaf
   {
      private string uniqueName;

      public string MetaType { get; set; }

      /// <summary>
      /// This might be set if read from a Build as a nested User. If 
      /// read from other functions this will not be set and the MailAddress
      /// should be returned.
      /// </summary>
      public string UniqueName
      {
         get
         {
            if(string.IsNullOrEmpty(this.uniqueName))
            {
               return this.MailAddress;
            }

            return this.uniqueName;
         }

         set => this.uniqueName = value;
      }

      /// <summary>
      /// Used to pass down pipelines
      /// </summary>
      public string MemberDescriptor => this.Descriptor;

      public User(PSObject obj) : base(obj)
      {
      }

      public override string ToString() => base.DisplayName;
   }
}
