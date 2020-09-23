using System;

namespace vsteam_lib
{
   [Flags]
   public enum WorkItemAreaPermissions
   {
      GENERIC_READ = 1,
      GENERIC_WRITE = 2,
      CREATE_CHILDREN = 4,
      DELETE = 8,
      WORK_ITEM_READ = 16,
      WORK_ITEM_WRITE = 32,
      MANAGE_TEST_PLANS = 64,
      MANAGE_TEST_SUITES = 128
   }
}
