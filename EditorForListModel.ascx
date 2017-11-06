<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<Model>" %>
<% for(var i = 0; i < Model.ItemList.Count; i++) { %>
  <%: Html.TextBoxFor(model => model.ItemList[i].Name)%>
  <%: Html.TextBoxFor(model => model.ItemList[i].PassWord, new { @class = "password" })%>
<% } %>

or

<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<List<item>>" %>
<% for(var i = 0; i < Model.Count; i++) { %>
  <%: Html.TextBoxFor(model => model[i].Name)%>
  <%: Html.TextBoxFor(model => model[i].PassWord, new { @class = "password" })%>
<% } %>
