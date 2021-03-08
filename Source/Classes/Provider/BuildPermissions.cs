using System;

namespace vsteam_lib
{
   [Flags]
   public enum BuildPermissions
   {
      ViewBuilds = 1,
      EditBuildQuality = 2,
      RetainIndefinitely = 4,
      DeleteBuilds = 8,
      ManageBuildQualities = 16,
      DestroyBuilds = 32,
      UpdateBuildInformation = 64,
      QueueBuilds = 128,
      ManageBuildQueue = 256,
      StopBuilds = 512,
      ViewBuildDefinition = 1024,
      EditBuildDefinition = 2048,
      DeleteBuildDefinition = 4096,
      OverrideBuildCheckInValidation = 8192,
      AdministerBuildPermissions = 16384
   }
}
