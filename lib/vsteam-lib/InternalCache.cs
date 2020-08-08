using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Management.Automation.Abstractions;

namespace vsteam_lib
{
   public class InternalCache
   {
      private double _timeStamp = -1;
      public List<string> Values { get; } = new List<string>();

      /// <summary>
      /// Used for unit testing
      /// </summary>
      private IPowerShell _powerShell;

      [ExcludeFromCodeCoverage]
      public IPowerShell Shell
      {
         get
         {
            if (this._powerShell == null)
            {
               this._powerShell = new PowerShellWrapper(RunspaceMode.CurrentRunspace);
            }

            return this._powerShell;
         }

         set => this._powerShell = value;
      }

      internal void Prime(IEnumerable<string> list)
      {
         this.Values.Clear();

         if (null != list)
         {
            foreach (var item in list)
            {
               this.Values.Add(item);
            }
         }

         this._timeStamp = Math.Round(DateTime.UtcNow.TimeOfDay.TotalMinutes);
      }
      
      internal void Invalidate() => this._timeStamp = -1;
      internal bool HasCacheExpired => !this._timeStamp.Equals(Math.Round(DateTime.UtcNow.TimeOfDay.TotalMinutes));
   }
}
