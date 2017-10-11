using System.Web.Mvc;

namespace TalentPool.Controllers
{
  [HandleError]
  public class GlobalController : Controller
  {
    /// <summary>
    /// 獲取下拉列表
    /// </summary>
    /// <typeparam name="T">泛型：實體類</typeparam>
    /// <param name="dataList">實體類列表</param>
    /// <param name="columnValue">數值</param>
    /// <param name="columnText">文本</param>
    /// <returns></returns>
    public List<SelectListItem> GetSelectList<T>(List<T> dataList, string columnValue, string columnText) where T : class
    {
      //List<SelectListItem> selectList = new List<SelectListItem>();
      //if (dataList.Count > 0)
      //{
        //foreach (var d in dataList)
        //{
          //SelectListItem item = new SelectListItem();
          //item.Text = d.GetType().GetProperty(columnName1).GetValue(d, null).ToString();
          //tem.Value = d.GetType().GetProperty(columnName2).GetValue(d, null).ToString();
          //selectList.Add(item);
        //}
      //}
      SelectList sList = new SelectList(dataList, columnValue, columnText);
      List<SelectListItem> selectList = sList.ToList();
      return selectList;
    }
  }
}
