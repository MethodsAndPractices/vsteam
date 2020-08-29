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
      private readonly string _command;
      private readonly string _property;
      private readonly bool _requiresProject;

      public InternalCache(string command, string property, bool requiresProject)
      {
         this._command = command;
         this._property = property;
         this._requiresProject = requiresProject;
      }

      [ExcludeFromCodeCoverage]
      public IPowerShell Shell
      {
         get
         {
            if (this._powerShell != null)
            {
               return this._powerShell;
            }

            return new PowerShellWrapper(RunspaceMode.CurrentRunspace);
         }

         set => this._powerShell = value;
      }

      internal void Update(IEnumerable<string> list)
      {
         // If a list is passed in use it. If not call Get-VSTeamProcess
         if (null == list)
         {
            if (this._requiresProject)
            {
               var projectName = Common.GetDefaultProject(this.Shell);

               if (!string.IsNullOrEmpty(projectName))
               {
                  this.Shell.Commands.Clear();

                  list = this.Shell.AddCommand(this._command)
                                   .AddParameter("ProjectName", projectName)
                                   .AddCommand("Select-Object")
                                   .AddParameter("ExpandProperty", this._property)
                                   .AddCommand("Sort-Object")
                                   .Invoke<string>();
               }
            }
            else
            {
               this.Shell.Commands.Clear();

               list = this.Shell.AddCommand(this._command)
                                .AddCommand("Select-Object")
                                .AddParameter("ExpandProperty", this._property)
                                .AddCommand("Sort-Object")
                                .Invoke<string>();            
            }
         }

         this.Prime(list);
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

      internal IEnumerable<string> GetCurrent()
      {
         if(HasCacheExpired)
         {
            Update(null);
         }

         return Values;
      }

      internal void Invalidate() => this._timeStamp = -1;
      internal bool HasCacheExpired => !this._timeStamp.Equals(Math.Round(DateTime.UtcNow.TimeOfDay.TotalMinutes));
   }
}
