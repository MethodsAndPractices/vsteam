using System;

namespace vsteam_lib
{
   [Flags]
   public enum WorkItemIterationPermissions
   {
      GENERIC_READ = 1,
      GENERIC_WRITE = 2,
      CREATE_CHILDREN = 4,
      DELETE = 8
   }
}
