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

            LinkedList cambioRol = usuarioLogin.getRoles();

            LinkedList semanasDisponibles = (LinkedList) session.getAttribute("semanasDisponibles");

            LinkedList regionesSemanas = (LinkedList) session.getAttribute("regionesPorSemanas");

            LinkedList regionesDisponibles = (LinkedList) session.getAttribute("regionesDisponibles");

            String semana = (String) session.getAttribute("semana");
        %>

        <h1>Bienvenido: <%= usuarioLogin.getNombre() + " " + usuarioLogin.getApellidos()%></h1>

        <%
            if (cambioRol.get(0).equals("Administrador / Gestor")) {
        %>
        <form action="../Controladores/controlador.jsp" name="form_cambiarRol" method="POST">
            <input type="submit" name="bt_cambioRol" value="Ir a Admin">
        </form>
        <%
            }
        %>

        <form action="../Controladores/controlador.jsp" name="form_cerrarSesion" method="POST">
            <input type="submit" name="cerrarSesion" value="Cerrar Sesion">
        </form>

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

            if (semana != null && regionesSemanas != null) {
        %>

        <h3><%= semana%></h3>
        <% if (regionesSemanas.size() > 0) {
        %>
        <table>
            <tr>
                <th>Región</th>
                <th>Número de Infectados</th>
                <th>Número de Fallecidos</th>
                <th>Número de Altas</th>
                <th colspan="2">Opciones</th>
            </tr>
            <% for (int i = 0; i < regionesSemanas.size(); i++) {
                    Region r = (Region) regionesSemanas.get(i);
            %>
            <form action="../Controladores/controlador.jsp" name="form_regionesPorSemanas" method="POST">
                <tr>
                    <td><input type="text" name="region" value="<%= r.getRegion()%>" readonly></td>
                    <td><input type="number" name="numInfectados" value="<%= r.getNumInfectados()%>"></td>
                    <td><input type="number" name="numFallecidos" value="<%= r.getNumFallecidos()%>"></td>
                    <td><input type="number" name="numAltas" value="<%= r.getNumAltas()%>"></td>
                    <td>
                        <input type="submit" name="bt_Gestor" value="Editar">
                    </td>
                    <td>
                        <input type="submit" name="bt_Gestor" value="Borrar">
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

            if (regionesDisponibles instanceof LinkedList) {
        %>
        <form action="../Controladores/controlador.jsp" name="form_addRegionASemana" method="POST">
            <table>
                <tr>
                    <th>
                        Región
                    </th>
                    <th>
                        Número de infectados
                    </th>
                    <th>
                        Número de fallecidos
                    </th>
                    <th>
                        Número de altas
                    </th>
                    <th>
                        Opciones
                    </th>
                </tr>

                <tr>
                    <td>
                        <select name="regionDisponible_region">
                            <%
                                for (int i = 0; i < regionesDisponibles.size(); i++) {
                            %>
                            <option name="regionDisponibleOption_region"><%= regionesDisponibles.get(i)%></option>
                            <%
                                }
                            %>
                        </select>
                    </td>
                    <td>
                        <input type="number" name="numInfecciones_region" placeholder="Número de infectados">
                    </td>
                    <td>
                        <input type="number" name="numFallecidos_region" placeholder="Número de fallecidos">
                    </td>
                    <td>
                        <input type="number" name="numAltas_region" placeholder="Número de altas">
                    </td>
                    <td>
                        <input type="submit" name="bt_Gestor" value="Introducir region">
                    </td>
                </tr>
            </table>
        </form>
        <%                }
            }
        %>
    </body>
</html>
