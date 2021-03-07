using System;

namespace vsteam_lib
{
   [Flags]
   public enum IdentityPermissions
   {
      Read = 1,
      Write = 2,
      Delete = 4,
      ManageMembership = 8,
      CreateScope = 16,
      RestoreScope = 32
   }
}
