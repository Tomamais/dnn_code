<!DOCTYPE html>

<%@ Page Language="C#" %>
<script runat="server">
    public ArrayList portals;
    public List<UserInfo> usersAdmin = new List<UserInfo>();
    public Dictionary<string, string> usersPasswords = new Dictionary<string, string>();

    public void ResetarSenhas(object sender, System.EventArgs e)
    {
        try
        {
            foreach (UserInfo user in usersAdmin)
            {
                UserController.ResetPasswordToken(user);
                var passwordChanged = UserController.ChangePasswordByToken(user.PortalID, user.Username, "adminadminadmin", user.PasswordResetToken.ToString());
                usersPasswords.Add(user.Username, passwordChanged.ToString());
            }
        }
        catch (Exception ex)
        {
            Response.Write(ex.ToString());
        }
    }
    
    void Page_Load(object sender, System.EventArgs e)
    {
        try
        {
            // garante a autenticação
            if (User.Identity.IsAuthenticated)
            {
                if (User.Identity.Name == "host")
                {
                    portals = new PortalController().GetPortals();

                    foreach (PortalInfo portal in portals)
                    {
                        var portalUsers = new DotNetNuke.Security.Roles.RoleController().GetUsersByRoleName(portal.PortalID, "Administrators");

                        foreach (var user in portalUsers)
                        {
                            UserInfo userInfo = (UserInfo)user;

                            if (!usersAdmin.Exists(u => u.UserID == userInfo.UserID))
                            {
                                usersAdmin.Add(userInfo);
                            }
                        }
                    }
                }
                else
                {
                    Response.Redirect("~/");
                }
            }
            else
            {
                Response.Redirect("~/");
            }
        }
        catch (Exception ex)
        {

            Response.Write(ex.ToString());
        }
    }
</script>
<html  lang="pt-BR">
    <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        <title>Recuperando a senha dos usuários</title>
    </head>
    <body>  
        <form runat="server">
            <h1>Recuperando a senha dos usuários</h1>
            <h2>Portais (<%=portals.Count %>)</h2>
            <ul>
                <% foreach (PortalInfo portal in portals)
                   { %>
                <li>
                    <%=string.Format("{0} - {1}", portal.PortalID, portal.PortalName) %></li>
                <% } %>
            </ul>

            <h2>Usuários na Role Administrator (<%=usersAdmin.Count %>)</h2>
            <ul>
                <% foreach (UserInfo user in usersAdmin)
                   { %>
                <li>
                    <%=string.Format("{0} - {1} - {2} - {3}", "UserName", user.Username, "PortaID", user.PortalID) %></li>
                <% } %>
            </ul>

            <asp:Button ID="ButtonResetarSenhas" runat="server" OnClick="ResetarSenhas" Text="Resetar senhas" />

            <%if (usersPasswords.Count() > 0) { %>
                <h2>Senhas redefinidas (<%=usersPasswords.Count() %>)</h2>
                <ul>
                    <% foreach (KeyValuePair<string, string> user in usersPasswords)
                       { %>
                    <li>
                        <%=string.Format("{0} - {1}", user.Key, user.Value) %></li>
                    <% } %>
                </ul>
            <% } %>
        </form>
    </body>
</html>