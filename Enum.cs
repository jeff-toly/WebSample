using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using System.Web.Mvc;

namespace TalentPool.Models
{
  public class EnumInTalentPool
  {
    /// <summary>  
    /// 根據枚舉類獲取對應的下拉列表(value類型為Int數值)  
    /// </summary>  
    /// <param name="enumType">枚舉類的類型:typeof(enumTypeName)</param>  
    /// <returns></returns>  
    public List<SelectListItem> EnumToList(Type enumType)  
    {   
      var list = new List<SelectListItem>();   
      var fields = enumType.GetFields();   
      foreach (var f in fields)   
      {    
        var item = new SelectListItem();    
        if (f.Name.Equals("value__")) continue;    
        var description = (DescriptionAttribute)Attribute.GetCustomAttribute(f, typeof(DescriptionAttribute));    
        item.Text = description.Description;    
        item.Value = f.GetRawConstantValue().ToString();    
        list.Add(item);   
      }   
      return list;  
    }
    
    /// <summary>  
    /// 根據枚舉類獲取對應的下拉列表(value類型為String英文描述)  
    /// </summary>  
    /// <param name="enumType">枚舉類的類型:typeof(enumTypeName)</param>  
    /// <returns></returns>  
    public List<SelectListItem> EnumStringToList(Type enumType)  
    {   
      var list = new List<SelectListItem>();   
      var values = Enum.GetValues(enumType);   
      foreach (var e in values)   
      {    
        var item = new SelectListItem();    
        var info = e.GetType().GetField(Enum.GetName(enumType, e));    
        var description = (DescriptionAttribute)Attribute.GetCustomAttribute(info, typeof(DescriptionAttribute));    
        item.Text = description.Description;    
        //item.Value = ((int)e).ToString();-->Int類型    
        item.Value = e.ToString();    
        list.Add(item);   
      }   
      return list;  
    }
    
    /// <summary>  
    /// 獲取描述符  
    /// </summary>  
    /// <typeparam name="T">數值或者英文描述的類型：string或int</typeparam>  
    /// <param name="enumType">枚舉類型的類別</param>  
    /// <param name="value">數值或者英文描述</param>  
    /// <returns></returns>  
    public string GetDescription<T>(Type enumType, T value)  
    {   
      var _value = Enum.Parse(enumType, value.ToString());   
      var info = _value.GetType().GetField(Enum.GetName(enumType, (int)_value));   
      var description = (DescriptionAttribute)Attribute.GetCustomAttribute(info, typeof(DescriptionAttribute));   
      return description.Description;  
    }
  }
}
