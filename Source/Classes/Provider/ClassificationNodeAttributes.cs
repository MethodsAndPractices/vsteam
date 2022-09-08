using System;
using System.Collections.Generic;
using System.Management.Automation;
using System.Xml.Serialization;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class ClassificationNodeAttributes: IInternalObject
   {
      [XmlAttribute("attributes.startDate")]
      public Nullable<DateTime> StartDate { get; set; }

      [XmlAttribute("attributes.finishDate")]
      public Nullable<DateTime> FinishDate { get; set; }

      public PSObject InternalObject { get; set; }

      public ClassificationNodeAttributes(PSObject obj)
      {
         this.InternalObject = obj;

         Common.MoveProperties(this, obj);
      }
      
   }
}
