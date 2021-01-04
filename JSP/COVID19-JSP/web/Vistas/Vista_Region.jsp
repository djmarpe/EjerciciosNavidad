<%-- 
    Document   : Vista_Region
    Created on : 30-dic-2020, 11:28:53
    Author     : alejandro
--%>

<%@page import="Modelo.RegionAux"%>
<%@page import="Modelo.Region"%>
<%@page import="Modelo.Persona"%>
<%@page import="java.util.LinkedList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Regiones</title>
    </head>
    <body>
        <%

            Persona usuarioLogin = (Persona) session.getAttribute("usuarioLogin");

            LinkedList cambioRol = usuarioLogin.getRoles();

            LinkedList regiones = (LinkedList) session.getAttribute("todasRegiones");

        %>

        <h1>Bienvenido: <%= usuarioLogin.getNombre() + " " + usuarioLogin.getApellidos()%></h1>

        <%
            if (cambioRol.get(0).equals("Administrador / Gestor")) {
        %>
        <form action="../Controladores/controlador.jsp" name="form_cambiarRol" method="POST">
            <input type="submit" name="bt_cambioRol" value="Ir a Gestor">
        </form>
        <%
            }
        %>

        <form action="../Controladores/controlador.jsp" name="form_cerrarSesion" method="POST">
            <input type="submit" name="cerrarSesion" value="Cerrar Sesion">
        </form>

        <h4>Todas las regiones</h4>
        <table>
            <tr>
                <th>
                    Nombre
                </th>
                <th colspan="2">
                    Opciones
                </th>
            </tr>
            <%
                for (int i = 0; i < regiones.size(); i++) {
                    RegionAux r = (RegionAux) regiones.get(i);
            %>
            <form action="../Controladores/controlador.jsp" name="form_editDeleteRegion" method="POST">
                <tr>
                    <td>
                        <input type="hidden" name="idRegion" value="<%= r.getIdRegion()%>">
                        <input type="text" name="region" value="<%= r.getNombre()%>">
                    </td>
                    <td>
                        <input type="submit" name="bt_Region" value="Editar">
                    </td>
                    <td>
                        <input type="submit" name="bt_Region" value="Borrar">
                    </td>
                </tr>
            </form>
            <%
                }
            %>
            <form action="../Controladores/controlador.jsp" name="form_addRegion" method="POST">
                <tr>
                    <th colspan="2">Añadir nueva región</th>
                </tr>
                <tr>
                    <td>
                        <input type="text" name="nuevaRegion" placeholder="Nueva region">
                    </td>
                    <td colspan="2">
                        <input type="submit" name="bt_Region" value="Crear region">
                    </td>
                </tr>
            </form>
        </table>

    </body>
</html>
