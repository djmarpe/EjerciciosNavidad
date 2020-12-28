<%-- 
    Document   : Vista_Gestor
    Created on : 28-dic-2020, 14:43:31
    Author     : alejandro
--%>

<%@page import="Modelo.Region"%>
<%@page import="java.util.LinkedList"%>
<%@page import="Modelo.Persona"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gestor de datos</title>
    </head>
    <body>
        <%
            Persona usuarioLogin = (Persona) session.getAttribute("usuarioLogin");

            LinkedList semanasDisponibles = (LinkedList) session.getAttribute("semanasDisponibles");

            LinkedList regiones = (LinkedList) session.getAttribute("regionesDisponibles");

            String semana = (String) session.getAttribute("semana");
        %>

        <h1>Bienvenido: <%= usuarioLogin.getNombre() + " " + usuarioLogin.getApellidos()%></h1>

        <%
            if (semanasDisponibles.size() > 0) {
        %>
        <form action="../Controladores/controlador.jsp" name="form_semanas" method="POST">
            Semana a buscar:
            <select name="semanaFiltrar"  onclick="this.form.submit();">
                <option disabled selected>Seleccione una semana</option>
                <%
                    for (int i = 0; i < semanasDisponibles.size(); i++) {
                %>
                <option name="semana"><%= semanasDisponibles.get(i)%></option>
                <%
                    }
                %>
            </select>
        </form>
        <%
            }

            if (semana != null && regiones != null) {
        %>

        <h3><%= semana%></h3>
        <% if (regiones.size() > 0) {
        %>
        <table>
            <tr>
                <th>Región</th>
                <th>Número de Infectados</th>
                <th>Número de Fallecidos</th>
                <th>Número de Altas</th>
            </tr>
            <% for (int i = 0; i < regiones.size(); i++) {
                    Region r = (Region) regiones.get(i);
            %>
            <form action="../Controladores/controlador.jsp" name="form_semanas" method="POST">
                <tr>
                    <td><input type="text" name="region" value="<%= r.getRegion()%>" readonly></td>
                    <td><input type="number" name="numInfectados" value="<%= r.getNumInfectados()%>"></td>
                    <td><input type="number" name="numFallecidos" value="<%= r.getNumFallecidos()%>"></td>
                    <td><input type="number" name="numAltas" value="<%= r.getNumAltas()%>"></td>
                    <td>
                        <input type="submit" name="bt_Gesstor" value="Editar">
                    </td>
                    <td>
                        <input type="submit" name="bt_Gesstor" value="Borrar">
                    </td>
                </tr>
            </form>
            <%
                }
            %>

        </table>

        <%
        } else {
        %>
        <h3>No hay datos</h3>
        <%
                }
            }
        %>
    </body>
</html>
