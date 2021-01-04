<%-- 
    Document   : Vista_Semana
    Created on : 03-ene-2021, 18:15:33
    Author     : alejandro
--%>

<%@page import="Modelo.SemanaAux"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.LinkedList"%>
<%@page import="Modelo.Persona"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Semanas</title>
    </head>
    <body>
        <%

            Persona usuarioLogin = (Persona) session.getAttribute("usuarioLogin");

            LinkedList cambioRol = usuarioLogin.getRoles();

            LinkedList semanas = (LinkedList) session.getAttribute("todasSemanas");

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
                for (int i = 0; i < semanas.size(); i++) {
                    SemanaAux s = (SemanaAux) semanas.get(i);
            %>
            <form action="../Controladores/controlador.jsp" name="form_editDeleteSemana" method="POST">
                <tr>
                    <td>
                        <input type="hidden" name="idSemana" value="<%= s.getIdSemana()%>">
                        <input type="text" name="semana" value="<%= s.getSemana()%>">
                    </td>
                    <td>
                        <input type="submit" name="bt_Semana" value="Editar">
                    </td>
                    <td>
                        <input type="submit" name="bt_Semana" value="Borrar">
                    </td>
                </tr>
            </form>
            <%
                }
            %>
            <form action="../Controladores/controlador.jsp" name="form_addSemana" method="POST">
                <tr>
                    <th colspan="2">Añadir nueva semana</th>
                </tr>
                <tr>
                    <td>
                        <input type="text" name="nuevaSemana" placeholder="Nueva semana">
                    </td>
                    <td colspan="2">
                        <input type="submit" name="bt_Semana" value="Crear semana">
                    </td>
                </tr>
            </form>
        </table>
    </body>
</html>
