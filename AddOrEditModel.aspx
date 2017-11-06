<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Dialog.Master" Inherits="System.Web.Mvc.ViewPage<Model>" %>
<head>
  <script>
  //替換Name（多餘的“.”導致EditorFor傳Model失敗）for itemlist
  $(".ExectionC").each(function () {
    $(this).attr("name", $(this).attr("name").replace(/\./, ''));
  });
  function CheckData()
  {
    return ValidateBeforeSave();
  }
  </script>
</head>
<body>
  <%using (Html.BeginForm("SaveModel", "ModelIndex", FormMethod.Post, new { enctype = "multipart/form-data", onsubmit = "return CheckData();" })){ %>>
  <%: Html.EditorFor(model => model)%>
  or
  <%: Html.EditorFor(model => model.ItemList)%>
  <%} %>
</body>
