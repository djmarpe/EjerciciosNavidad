<%-- 
    Document   : Vista_Login
    Created on : 26-dic-2020, 14:57:52
    Author     : alejandro
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Iniciar sesión</title>
    </head>
    <body>
        <%
            String mensaje = "";
            if (session.getAttribute("mensajeLogin") != null) {
                mensaje = (String) session.getAttribute("mensajeLogin");
            }

            if (!mensaje.isEmpty()) {
        %>
        <h5><%= mensaje%></h5>
        <%
            }
        %>
        <form action="../Controladores/controlador.jsp" name="form_login" method="POST">
            <table>
                <tr>
                    <td>Usuario:</td>
                    <td>
                        <input type="email" name="correo" placeholder="Correo electronico" required>
                    </td>
                </tr>
                <tr>
                    <td>Contraseña:</td>
                    <td>
                        <input type="password" name="contra" placeholder="Contraseña" required>
                    </td>
                </tr>
                <tr>
                    <td colspan="2"><input type="submit" name="iniciarSesion" value="Iniciar Sesion"></td>
                </tr>
            </table>
        </form>
    </body>
</html>
