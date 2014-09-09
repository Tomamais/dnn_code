<!DOCTYPE html>
<%@ Page Language="C#" %>
<script runat="server">
	void Page_Load(object sender, System.EventArgs e)
	{
		DotNetNuke.Entities.Users.UserInfo user = DotNetNuke.Entities.Users.UserController.GetUserByName("host");
		
		if (user != null)
		{
			DotNetNuke.Entities.Users.UserController.ResetPasswordToken(user);
			var passwordChanged = DotNetNuke.Entities.Users.UserController.ChangePasswordByToken(user.PortalID, user.Username, "[newhostpassword]", user.PasswordResetToken.ToString());
			
			if(passwordChanged)
			{
				Response.Write("THE PASSWORD HAS BEEN CHANGED SUCCESSFULLY");
			}
			else
			{
				Response.Write("THE PASSWORD CANNOT BE CHANGED");
			}

		}
		else
		{
			Response.Write("USER NOT FOUND");
		}
		
	}
</script>
<html lang="pt-BR">
	<head>
		<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
		<title>Reseting host password</title>
	</head>

	<body>
	</body>
</html>