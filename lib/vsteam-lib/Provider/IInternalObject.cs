using System.Management.Automation;

namespace vsteam_lib.Provider
{
   public interface IInternalObject
   {
      PSObject InternalObject { get; }
   }
}